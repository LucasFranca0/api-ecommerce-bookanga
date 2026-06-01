import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import YAML from "yaml";
import { Buffer } from "node:buffer";
import fs from "node:fs/promises";

const DEFAULT_OPENAPI_URL =
  "https://support.smartbear.com/zephyr-scale-cloud/api-docs/api.cloud.stripped.yml";
const DEFAULT_TAGS = [
  "Test Cases",
  "Test Cycles",
  "Test Executions",
  "Test Plans",
  "Folders",
  "Statuses",
  "Priorities",
  "Attachments",
];

type JsonSchema = Record<string, unknown>;

type Parameter = {
  name: string;
  in: "path" | "query" | "header" | "cookie";
  required?: boolean;
  description?: string;
  schema?: JsonSchema;
};

type RequestBodyMeta = {
  required: boolean;
  jsonSchema?: JsonSchema;
  multipart: boolean;
};

type OperationMeta = {
  name: string;
  description: string;
  method: string;
  path: string;
  parameters: Parameter[];
  requestBody?: RequestBodyMeta;
};

type ToolDefinition = {
  name: string;
  description: string;
  inputSchema: JsonSchema;
};

function normalizeBaseUrl(url: string): string {
  return url.replace(/\/+$/, "");
}

function resolveRef(spec: Record<string, unknown>, ref: string): unknown {
  if (!ref.startsWith("#/")) {
    return undefined;
  }
  const parts = ref.slice(2).split("/");
  let current: any = spec;
  for (const part of parts) {
    current = current?.[part];
    if (!current) {
      return undefined;
    }
  }
  return current;
}

function resolveSchema(spec: Record<string, unknown>, schema: any, seen = new Set<string>()): any {
  if (!schema) {
    return schema;
  }
  if (schema.$ref && typeof schema.$ref === "string") {
    if (seen.has(schema.$ref)) {
      return {};
    }
    seen.add(schema.$ref);
    const resolved = resolveRef(spec, schema.$ref);
    return resolveSchema(spec, resolved, seen);
  }
  if (schema.type === "array" && schema.items) {
    return { ...schema, items: resolveSchema(spec, schema.items, seen) };
  }
  if (schema.type === "object" && schema.properties) {
    const properties: Record<string, unknown> = {};
    for (const [key, value] of Object.entries(schema.properties)) {
      properties[key] = resolveSchema(spec, value, seen);
    }
    return { ...schema, properties };
  }
  return schema;
}

function parseTags(): Set<string> {
  const raw = process.env.ZEPHYR_TAGS;
  if (!raw) {
    return new Set(DEFAULT_TAGS);
  }
  return new Set(
    raw
      .split(",")
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0),
  );
}

function buildToolName(operationId: string | undefined, method: string, path: string): string {
  if (operationId) {
    return `zephyr.${operationId}`;
  }
  const normalizedPath = path
    .replace(/[{}]/g, "")
    .replace(/[^a-zA-Z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
  return `zephyr.${method.toLowerCase()}_${normalizedPath}`;
}

function buildInputSchema(
  spec: Record<string, unknown>,
  parameters: Parameter[],
  requestBody?: RequestBodyMeta,
): JsonSchema {
  const properties: Record<string, JsonSchema> = {};
  const required: string[] = [];

  for (const param of parameters) {
    const schema = resolveSchema(spec, param.schema) ?? { type: "string" };
    properties[param.name] = {
      ...schema,
      description: param.description,
    };
    if (param.required) {
      required.push(param.name);
    }
  }

  if (requestBody) {
    if (requestBody.jsonSchema) {
      properties.body = resolveSchema(spec, requestBody.jsonSchema) ?? {
        type: "object",
        additionalProperties: true,
      };
      if (requestBody.required) {
        required.push("body");
      }
    }
    if (requestBody.multipart) {
      properties.multipart = {
        type: "object",
        description:
          "Multipart payload. Use file objects with fileBase64, fileName and contentType for uploads.",
        additionalProperties: true,
      };
      if (requestBody.required && !requestBody.jsonSchema) {
        required.push("multipart");
      }
    }
  }

  const schema: JsonSchema = {
    type: "object",
    properties,
    additionalProperties: false,
  };
  if (required.length > 0) {
    schema.required = required;
  }
  return schema;
}

function parseRequestBody(spec: Record<string, unknown>, requestBody: any): RequestBodyMeta | undefined {
  if (!requestBody) {
    return undefined;
  }
  const resolved = requestBody.$ref ? resolveRef(spec, requestBody.$ref as string) : requestBody;
  if (!resolved) {
    return undefined;
  }
  const content = resolved.content ?? {};
  const jsonSchema = content["application/json"]?.schema
    ? resolveSchema(spec, content["application/json"].schema)
    : undefined;
  const multipart = Boolean(content["multipart/form-data"]);
  return {
    required: Boolean(resolved.required),
    jsonSchema,
    multipart,
  };
}

function collectParameters(spec: Record<string, unknown>, pathItem: any, operation: any): Parameter[] {
  const combined = [...(pathItem?.parameters ?? []), ...(operation?.parameters ?? [])];
  return combined
    .map((param) => (param.$ref ? resolveRef(spec, param.$ref as string) : param))
    .filter(Boolean)
    .map((param: any) => ({
      name: param.name,
      in: param.in,
      required: param.required,
      description: param.description,
      schema: param.schema,
    }));
}

async function loadOpenApiSpec(): Promise<Record<string, unknown>> {
  const localPath = process.env.ZEPHYR_OPENAPI_PATH;
  if (localPath) {
    const text = await fs.readFile(localPath, "utf8");
    return YAML.parse(text);
  }
  const url = process.env.ZEPHYR_OPENAPI_URL ?? DEFAULT_OPENAPI_URL;
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch OpenAPI spec: ${response.status} ${response.statusText}`);
  }
  const text = await response.text();
  return YAML.parse(text);
}

function buildToolsFromSpec(spec: Record<string, unknown>): { tools: ToolDefinition[]; map: Map<string, OperationMeta> } {
  const tools: ToolDefinition[] = [];
  const map = new Map<string, OperationMeta>();
  const tagFilter = parseTags();
  const paths = (spec.paths ?? {}) as Record<string, any>;

  for (const [path, pathItem] of Object.entries(paths)) {
    for (const method of ["get", "post", "put", "patch", "delete", "head", "options"]) {
      const operation = pathItem?.[method];
      if (!operation) {
        continue;
      }
      const tags: string[] = operation.tags ?? [];
      if (!tags.some((tag) => tagFilter.has(tag))) {
        continue;
      }
      const nameBase = buildToolName(operation.operationId, method, path);
      let name = nameBase;
      let suffix = 1;
      while (map.has(name)) {
        name = `${nameBase}_${suffix}`;
        suffix += 1;
      }
      const parameters = collectParameters(spec, pathItem, operation);
      const requestBody = parseRequestBody(spec, operation.requestBody);
      const inputSchema = buildInputSchema(spec, parameters, requestBody);
      const summary = operation.summary ?? operation.operationId ?? name;
      const description = `[${method.toUpperCase()}] ${path} - ${summary}`;

      const meta: OperationMeta = {
        name,
        description,
        method,
        path,
        parameters,
        requestBody,
      };

      tools.push({
        name,
        description,
        inputSchema,
      });
      map.set(name, meta);
    }
  }

  return { tools, map };
}

function buildUrl(baseUrl: string, operation: OperationMeta, args: Record<string, unknown>): URL {
  const normalizedBase = normalizeBaseUrl(baseUrl);
  let resolvedPath = operation.path;
  for (const param of operation.parameters.filter((p) => p.in === "path")) {
    const value = args[param.name];
    if (value === undefined) {
      if (param.required) {
        throw new Error(`Missing required path parameter: ${param.name}`);
      }
      continue;
    }
    resolvedPath = resolvedPath.replace(`{${param.name}}`, encodeURIComponent(String(value)));
  }
  if (!resolvedPath.startsWith("/")) {
    resolvedPath = `/${resolvedPath}`;
  }
  const url = new URL(`${normalizedBase}${resolvedPath}`);
  for (const param of operation.parameters.filter((p) => p.in === "query")) {
    const value = args[param.name];
    if (value === undefined) {
      continue;
    }
    if (Array.isArray(value)) {
      for (const item of value) {
        url.searchParams.append(param.name, String(item));
      }
    } else {
      url.searchParams.append(param.name, String(value));
    }
  }
  return url;
}

function appendFormValue(form: FormData, key: string, value: unknown): void {
  if (Array.isArray(value)) {
    for (const item of value) {
      appendFormValue(form, key, item);
    }
    return;
  }
  if (value && typeof value === "object" && "fileBase64" in value) {
    const file = value as { fileBase64: string; fileName?: string; contentType?: string };
    const buffer = Buffer.from(file.fileBase64, "base64");
    const blob = new Blob([buffer], {
      type: file.contentType ?? "application/octet-stream",
    });
    form.append(key, blob, file.fileName ?? "file");
    return;
  }
  form.append(key, String(value ?? ""));
}

async function executeOperation(operation: OperationMeta, args: Record<string, unknown>) {
  const baseUrl = process.env.ZEPHYR_BASE_URL;
  const token = process.env.ZEPHYR_API_TOKEN;
  if (!baseUrl) {
    throw new Error("ZEPHYR_BASE_URL is not set.");
  }
  if (!token) {
    throw new Error("ZEPHYR_API_TOKEN is not set.");
  }

  const authHeader = process.env.ZEPHYR_AUTH_HEADER ?? "Authorization";
  const authPrefix = process.env.ZEPHYR_AUTH_PREFIX ?? "Bearer";
  const timeoutMs = Number.parseInt(process.env.ZEPHYR_TIMEOUT_MS ?? "30000", 10);

  const url = buildUrl(baseUrl, operation, args);
  const headers: Record<string, string> = {
    Accept: "application/json",
    [authHeader]: `${authPrefix} ${token}`,
  };

  for (const param of operation.parameters.filter((p) => p.in === "header")) {
    const value = args[param.name];
    if (value !== undefined) {
      headers[param.name] = String(value);
    }
  }

  let body: BodyInit | undefined;
  if (operation.requestBody) {
    if (args.body !== undefined) {
      headers["Content-Type"] = "application/json";
      body = JSON.stringify(args.body);
    } else if (args.multipart !== undefined) {
      const form = new FormData();
      for (const [key, value] of Object.entries(args.multipart as Record<string, unknown>)) {
        appendFormValue(form, key, value);
      }
      body = form;
    } else if (operation.requestBody.required) {
      throw new Error("Request body is required.");
    }
  }

  const controller = new AbortController();
  const timeout = Number.isFinite(timeoutMs) && timeoutMs > 0 ? timeoutMs : 30000;
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    const response = await fetch(url, {
      method: operation.method.toUpperCase(),
      headers,
      body,
      signal: controller.signal,
    });
    const text = await response.text();
    if (!response.ok) {
      throw new Error(`Zephyr API error ${response.status}: ${text || response.statusText}`);
    }
    if (!text) {
      return `${response.status} ${response.statusText}`;
    }
    const contentType = response.headers.get("content-type") ?? "";
    if (contentType.includes("application/json")) {
      const parsed = JSON.parse(text);
      return JSON.stringify(parsed, null, 2);
    }
    return text;
  } finally {
    clearTimeout(timeoutId);
  }
}

const spec = await loadOpenApiSpec();
const { tools, map } = buildToolsFromSpec(spec);

const server = new Server(
  {
    name: "zephyr-scale-mcp",
    version: "0.1.0",
  },
  {
    capabilities: {
      tools: {},
    },
  },
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools,
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const toolName = request.params.name;
  const operation = map.get(toolName);
  if (!operation) {
    throw new Error(`Unknown tool: ${toolName}`);
  }
  const args = (request.params.arguments ?? {}) as Record<string, unknown>;
  const result = await executeOperation(operation, args);
  return {
    content: [
      {
        type: "text",
        text: result,
      },
    ],
  };
});

const transport = new StdioServerTransport();
await server.connect(transport);
