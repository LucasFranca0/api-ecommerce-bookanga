# Zephyr Scale Cloud MCP Server

This MCP server exposes tools generated from the Zephyr Scale Cloud OpenAPI spec.
The default tool set is filtered to these tags:

- Test Cases
- Test Cycles
- Test Executions
- Test Plans
- Folders
- Statuses
- Priorities
- Attachments

## Setup from scratch

1. Install Node.js 18+ (verify with `node -v`).
2. Pick the Zephyr API base URL:
   - Default (US): `https://api.zephyrscale.smartbear.com/v2`
   - EU region: `https://eu.api.zephyrscale.smartbear.com/v2`
3. Get your Jira project key:
   - In Jira: open the project -> **Project settings** -> **Details** -> **Key**.
   - Or from the URL (e.g. `/jira/software/projects/KEY/` or issue key `KEY-123`).
4. Generate a Zephyr API token in Jira: avatar (bottom-left) -> **Zephyr API keys** -> **Create access token**.
   - Copy the token immediately (it is shown only once).
   - The token is a JWT with 3 parts separated by dots.
5. Add the environment variables to `~/.bashrc` and reload it (`source ~/.bashrc`).
6. Build the server (`npm install && npm run build`).
7. Register the server in `~/.config/github-copilot/intellij/mcp.json` and restart IntelliJ (or reload Copilot) so the new MCP entry is picked up.

## Install and build

```bash
cd utils/mcp
npm install
npm run build
```

## Environment

The server reads its configuration from environment variables.
Add the required ones to your `~/.bashrc`:

```bash
# >>> bookanga-zephyr-mcp >>>
export ZEPHYR_BASE_URL="https://api.zephyrscale.smartbear.com/v2"
export ZEPHYR_API_TOKEN="your_api_token"
# <<< bookanga-zephyr-mcp <<<
```

Token note: `ZEPHYR_API_TOKEN` must be the JWT created in **Zephyr API keys** (not the token ID). The JWT has 3 parts separated by dots and is shown only once after creation.

Optional variables:

- `ZEPHYR_AUTH_HEADER` (default: `Authorization`)
- `ZEPHYR_AUTH_PREFIX` (default: `Bearer`)
- `ZEPHYR_TIMEOUT_MS` (default: `30000`)
- `ZEPHYR_OPENAPI_URL` (default: Zephyr Cloud OpenAPI URL)
- `ZEPHYR_OPENAPI_PATH` (local OpenAPI file path)
- `ZEPHYR_TAGS` (comma-separated list to filter tags)

## MCP configuration

IntelliJ Copilot (and local tools) expects a `mcp.json` under the user config path. On this machine the file is:

`~/.config/github-copilot/intellij/mcp.json`

Example `mcp.json` used here (note the `servers` key and absolute path to the server):

```json
{
  "servers": {
    "zephyr": {
      "command": "node",
      "args": ["/home/lucas/IdeaProjects/api-ecommerce-bookanga/utils/mcp/dist/index.js"],
      "env": {
        "ZEPHYR_BASE_URL": "${ZEPHYR_BASE_URL}",
        "ZEPHYR_API_TOKEN": "${ZEPHYR_API_TOKEN}"
      }
    }
  }
}
```

If you prefer a repo-local registration, keep a `.ai/mcp/mcp.json` with the same `servers` structure. Use environment variable references (e.g. `${ZEPHYR_API_TOKEN}`) rather than hardcoding secrets. If your repo lives in another path, update `args` to the correct absolute path to `dist/index.js`.

## Tool naming and usage

Tools are generated from the OpenAPI `operationId`. The naming format is:

```
zephyr.<operationId>
```

Example:

```
zephyr.listTestCases
```

Input parameters follow the OpenAPI schema for each endpoint. Query and path
parameters are passed as top-level properties. JSON bodies are passed via `body`.

## Multipart uploads (attachments)

For multipart endpoints, provide a `multipart` object. Use `fileBase64`,
`fileName`, and `contentType` for file fields. Example:

```json
{
  "multipart": {
    "file": {
      "fileBase64": "<base64>",
      "fileName": "evidence.png",
      "contentType": "image/png"
    }
  }
}
```

## Testing performed (examples)

Prerequisites: Node 18+, valid `ZEPHYR_BASE_URL` and `ZEPHYR_API_TOKEN` set in `~/.bashrc` and loaded (`source ~/.bashrc`).

Build the MCP server:

```bash
cd utils/mcp
npm install
npm run build
```

Copilot MCP configuration (used by IntelliJ Copilot):

`~/.config/github-copilot/intellij/mcp.json` contains a `zephyr` entry pointing to the server executable. Example (absolute path used in this repo):

```json
{
  "servers": {
    "zephyr": {
      "command": "node",
      "args": ["/home/lucas/IdeaProjects/api-ecommerce-bookanga/utils/mcp/dist/index.js"],
      "env": {
        "ZEPHYR_BASE_URL": "${ZEPHYR_BASE_URL}",
        "ZEPHYR_API_TOKEN": "${ZEPHYR_API_TOKEN}"
      }
    }
  }
}
```

Smoke test — list tools (via an MCP client that spawns the server):

```bash
node --input-type=module - <<'EOF'
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
const client = new Client({ name: "mcp-test", version: "0.0.1" });
const transport = new StdioClientTransport({
  command: "node",
  args: ["dist/index.js"],
  env: { ZEPHYR_BASE_URL: process.env.ZEPHYR_BASE_URL, ZEPHYR_API_TOKEN: process.env.ZEPHYR_API_TOKEN },
  cwd: process.cwd(),
});
await client.connect(transport);
const list = await client.listTools();
console.log('tools:', list.tools.length);
await client.close();
EOF
```

Create a test case via the MCP server (example). Replace `PROJECT_KEY` with your Jira project key:

```bash
node --input-type=module - <<'EOF'
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
const client = new Client({ name: "mcp-test", version: "0.0.1" });
const transport = new StdioClientTransport({
  command: "node",
  args: ["dist/index.js"],
  env: { ZEPHYR_BASE_URL: process.env.ZEPHYR_BASE_URL, ZEPHYR_API_TOKEN: process.env.ZEPHYR_API_TOKEN },
  cwd: process.cwd(),
});
await client.connect(transport);
const result = await client.callTool({ name: "zephyr.createTestCase", arguments: { body: { projectKey: "PROJECT_KEY", name: "teste" } } });
console.log(result.content?.[0]?.text ?? result);
await client.close();
EOF
```

Verify with `zephyr.listTestCases` (example). Replace `PROJECT_KEY` with your Jira project key:

```bash
node --input-type=module - <<'EOF'
/* similar setup as above */
const r = await client.callTool({ name: "zephyr.listTestCases", arguments: { projectKey: "PROJECT_KEY", maxResults: 1 } });
console.log(r.content?.[0]?.text);
await client.close();
EOF
```

Observed during validation (example project key used here was `KAN`):

- `listTools` returned 49 tools (includes `zephyr.listTestCases`, `zephyr.createTestCase`, ...)
- `createTestCase` returned `{ "id": 338651259, "self": ".../testcases/KAN-T1", "key": "KAN-T1" }`
- `listTestCases` returned the created `KAN-T1`

Notes & troubleshooting:

- If you receive HTTP 401, verify `ZEPHYR_API_TOKEN` is a valid JWT (3 parts) and not an ID.
- For EU region use `https://eu.api.zephyrscale.smartbear.com/v2` as `ZEPHYR_BASE_URL`.
- Never commit API tokens to the repository. Keep them in local shell files (e.g., `~/.bashrc`) or a secrets manager.

If you want, a small `utils/mcp/scripts` smoke-test helper can be added to automate these steps.
