#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

AUTO_YES=false
DRY_RUN=false
SKIP_INSTALL=false

RUN_TOOLS=true
RUN_GIT=true
RUN_MAVEN=true
RUN_ENV_FILE=false
RUN_BASHRC=false
RUN_NPMRC=false

WITH_NODE=false

GIT_SCOPE="global"
GIT_NAME=""
GIT_EMAIL=""
DEFAULT_BRANCH="main"
CREDENTIAL_MODE="keep"
SPRING_DB_URL="jdbc:postgresql://localhost:5432/bookanga_db"
NPM_REGISTRY=""

REQUIRED_JAVA_MAJOR=21

print_help() {
  cat <<'EOF'
Usage: ./utils/scripts/setup-dev.sh [options]

Interactive setup for machine + project tools.
By default, the script asks what to run at execution time.

Options:
  --yes                           Non-interactive shortcut (accept default flow)
  --dry-run                       Print actions without applying changes
  --skip-install                  Do not install missing tools, only validate
  --with-node                     Include Node.js + npm in tool checks
  --with-env-file                 Force .env.local configuration
  --configure-bashrc              Force ~/.bashrc JAVA_HOME configuration
  --configure-npmrc               Force ~/.npmrc managed block configuration
  --skip-maven                    Skip Maven bootstrap
  --npm-registry "https://..."    Registry value used for ~/.npmrc managed block

  --git-scope global|local        Git config scope (default: global)
  --git-name "Your Name"          Git user.name to set
  --git-email "you@mail.com"      Git user.email to set
  --default-branch main|dev       Git init.defaultBranch (default: main)
  --credential keep|cache|store|libsecret
                                  Git credential.helper behavior (default: keep)
  -h, --help                      Show this help

Examples:
  ./utils/scripts/setup-dev.sh
  ./utils/scripts/setup-dev.sh --yes
  ./utils/scripts/setup-dev.sh --dry-run
EOF
}

print_section() {
  printf "\n🔧 %s\n" "$1"
}

print_ok() {
  printf "✅ %s\n" "$1"
}

print_warn() {
  printf "⚠️  %s\n" "$1"
}

print_info() {
  printf "ℹ️  %s\n" "$1"
}

print_fail() {
  printf "❌ %s\n" "$1"
}

run_cmd() {
  local cmd="$1"
  if [[ "$DRY_RUN" == true ]]; then
    echo "[dry-run] $cmd"
  else
    eval "$cmd"
  fi
}

confirm() {
  local question="$1"
  if [[ "$AUTO_YES" == true ]]; then
    return 0
  fi

  read -r -p "$question [y/N]: " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_pkg_manager() {
  if has_cmd apt-get; then
    echo "apt"
  elif has_cmd dnf; then
    echo "dnf"
  elif has_cmd yum; then
    echo "yum"
  elif has_cmd pacman; then
    echo "pacman"
  elif has_cmd zypper; then
    echo "zypper"
  else
    echo "unknown"
  fi
}

install_packages() {
  local manager="$1"
  shift
  local packages=("$@")

  if [[ ${#packages[@]} -eq 0 ]]; then
    return
  fi

  case "$manager" in
    apt)
      run_cmd "sudo apt-get update"
      run_cmd "sudo apt-get install -y ${packages[*]}"
      ;;
    dnf)
      run_cmd "sudo dnf install -y ${packages[*]}"
      ;;
    yum)
      run_cmd "sudo yum install -y ${packages[*]}"
      ;;
    pacman)
      run_cmd "sudo pacman -Sy --noconfirm ${packages[*]}"
      ;;
    zypper)
      run_cmd "sudo zypper install -y ${packages[*]}"
      ;;
    *)
      echo "Error: unsupported package manager. Install manually: ${packages[*]}"
      return 1
      ;;
  esac
}

package_for_tool() {
  local tool_key="$1"
  local manager="$2"

  case "$tool_key" in
    git)
      echo "git"
      ;;
    java)
      case "$manager" in
        apt) echo "openjdk-21-jdk" ;;
        dnf|yum|zypper) echo "java-21-openjdk-devel" ;;
        pacman) echo "jdk21-openjdk" ;;
      esac
      ;;
    maven)
      echo "maven"
      ;;
    docker)
      case "$manager" in
        apt) echo "docker.io" ;;
        *) echo "docker" ;;
      esac
      ;;
    compose)
      case "$manager" in
        pacman|zypper) echo "docker-compose" ;;
        *) echo "docker-compose-plugin" ;;
      esac
      ;;
    aws)
      case "$manager" in
        pacman|zypper) echo "aws-cli" ;;
        *) echo "awscli" ;;
      esac
      ;;
    pg_isready)
      case "$manager" in
        apt) echo "postgresql-client" ;;
        *) echo "postgresql" ;;
      esac
      ;;
    curl)
      echo "curl"
      ;;
    unzip)
      echo "unzip"
      ;;
    node)
      echo "nodejs"
      ;;
    npm)
      echo "npm"
      ;;
    *)
      echo ""
      ;;
  esac
}

ensure_tool() {
  local cmd_name="$1"
  local tool_key="$2"

  if has_cmd "$cmd_name"; then
      print_ok "Tool '$cmd_name' already available."
    return
  fi

  print_warn "Tool '$cmd_name' not found."
  if [[ "$SKIP_INSTALL" == true ]]; then
    print_warn "Install skipped (--skip-install). Please install '$tool_key' manually."
    return 1
  fi

  local manager
  manager="$(detect_pkg_manager)"
  if [[ "$manager" == "unknown" ]]; then
    print_warn "Could not detect a supported package manager."
    return 1
  fi

  local package_name
  package_name="$(package_for_tool "$tool_key" "$manager")"
  if [[ -z "$package_name" ]]; then
    print_warn "No package mapping for tool '$tool_key' on '$manager'."
    return 1
  fi

  print_info "Installing '$package_name' using $manager..."
  install_packages "$manager" "$package_name"

  if has_cmd "$cmd_name"; then
    print_ok "Tool '$cmd_name' installed successfully."
  else
    print_fail "Tool '$cmd_name' is still unavailable after install attempt."
    return 1
  fi
}

ensure_docker_compose() {
  if docker compose version >/dev/null 2>&1 || has_cmd docker-compose; then
    print_ok "Docker Compose is available."
    return
  fi

  print_warn "Docker Compose not found."
  if [[ "$SKIP_INSTALL" == true ]]; then
    print_warn "Install skipped (--skip-install). Please install Docker Compose manually."
    return 1
  fi

  local manager
  manager="$(detect_pkg_manager)"
  if [[ "$manager" == "unknown" ]]; then
    print_warn "Could not detect a supported package manager."
    return 1
  fi

  local package_name
  package_name="$(package_for_tool "compose" "$manager")"
  print_info "Installing '$package_name' using $manager..."
  install_packages "$manager" "$package_name"

  if docker compose version >/dev/null 2>&1 || has_cmd docker-compose; then
    print_ok "Docker Compose installed successfully."
  else
    print_fail "Docker Compose is still unavailable after install attempt."
    return 1
  fi
}

parse_java_major() {
  if ! has_cmd java; then
    echo ""
    return
  fi
  java -version 2>&1 | awk -F\" '/version/ {print $2}' | awk -F. '{print $1}'
}

configure_bashrc_java_home() {
  local bashrc_file="$HOME/.bashrc"
  local java_bin
  java_bin="$(readlink -f "$(command -v java)")"
  local java_home
  java_home="${java_bin%/bin/java}"
  local start_marker="# >>> bookanga-setup JAVA_HOME >>>"
  local end_marker="# <<< bookanga-setup JAVA_HOME <<<"

  if [[ -z "$java_home" ]]; then
    echo "Could not detect JAVA_HOME from java binary."
    return
  fi

  print_section "Configuring ~/.bashrc JAVA_HOME"

  if [[ "$DRY_RUN" == true ]]; then
    print_info "[dry-run] update $bashrc_file with JAVA_HOME=$java_home"
    return
  fi

  touch "$bashrc_file"

  if grep -qE '^export JAVA_HOME=' "$bashrc_file" && ! grep -Fq "$start_marker" "$bashrc_file"; then
    local current_java_home
    current_java_home="$(grep -E '^export JAVA_HOME=' "$bashrc_file" | tail -n1 | sed 's/^export JAVA_HOME=//')"
    if [[ "$current_java_home" != "$java_home" ]] && ! confirm "Detected existing JAVA_HOME in ~/.bashrc. Overwrite with detected value?"; then
      print_info "Keeping existing ~/.bashrc JAVA_HOME configuration."
      return
    fi
  fi

  if grep -Fq "$start_marker" "$bashrc_file"; then
    if ! confirm "Managed JAVA_HOME block already exists in ~/.bashrc. Overwrite it?"; then
      print_info "Keeping existing managed JAVA_HOME block."
      return
    fi
    awk -v start="$start_marker" -v end="$end_marker" '
      $0 == start {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$bashrc_file" > "${bashrc_file}.tmp"
    mv "${bashrc_file}.tmp" "$bashrc_file"
  fi

  {
    printf "\n%s\n" "$start_marker"
    printf "export JAVA_HOME=%s\n" "$java_home"
    printf 'export PATH="$JAVA_HOME/bin:$PATH"\n'
    printf "%s\n" "$end_marker"
  } >> "$bashrc_file"

  print_ok "Updated $bashrc_file"
}

configure_npmrc() {
  local npmrc_file="$HOME/.npmrc"
  local start_marker="# >>> bookanga-setup npmrc >>>"
  local end_marker="# <<< bookanga-setup npmrc <<<"
  local content="fund=false\naudit=false"

  if [[ -n "$NPM_REGISTRY" ]]; then
    content+="\nregistry=${NPM_REGISTRY}"
  fi

  print_section "Configuring ~/.npmrc"

  if [[ "$DRY_RUN" == true ]]; then
    print_info "[dry-run] update $npmrc_file managed npm block"
    return
  fi

  touch "$npmrc_file"

  if [[ -n "$NPM_REGISTRY" ]] && grep -qE '^registry=' "$npmrc_file"; then
    local current_registry
    current_registry="$(grep -E '^registry=' "$npmrc_file" | tail -n1 | sed 's/^registry=//')"
    if [[ "$current_registry" != "$NPM_REGISTRY" ]] && ! confirm "Detected existing npm registry '$current_registry'. Overwrite with '$NPM_REGISTRY'?"; then
      print_info "Keeping existing npm registry configuration."
      return
    fi
  fi

  if grep -Fq "$start_marker" "$npmrc_file"; then
    if ! confirm "Managed npmrc block already exists. Overwrite it?"; then
      print_info "Keeping existing managed npmrc block."
      return
    fi
    awk -v start="$start_marker" -v end="$end_marker" '
      $0 == start {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$npmrc_file" > "${npmrc_file}.tmp"
    mv "${npmrc_file}.tmp" "$npmrc_file"
  elif [[ -s "$npmrc_file" ]] && ! confirm "Detected existing ~/.npmrc content. Append managed project block?"; then
    print_info "Keeping existing ~/.npmrc without changes."
    return
  fi

  {
    printf "\n%s\n" "$start_marker"
    printf "%b\n" "$content"
    printf "%s\n" "$end_marker"
  } >> "$npmrc_file"

  print_ok "Updated $npmrc_file"
}

confirm_with_default() {
  local question="$1"
  local default_answer="${2:-N}"

  if [[ "$AUTO_YES" == true ]]; then
    [[ "$default_answer" =~ ^[Yy]$ ]]
    return
  fi

  local hint="[y/N]"
  if [[ "$default_answer" =~ ^[Yy]$ ]]; then
    hint="[Y/n]"
  fi

  read -r -p "$question $hint: " answer
  if [[ -z "$answer" ]]; then
    [[ "$default_answer" =~ ^[Yy]$ ]]
  else
    [[ "$answer" =~ ^[Yy]$ ]]
  fi
}

prompt_runtime_plan() {
  if [[ "$AUTO_YES" == true ]]; then
    return
  fi

  print_section "Escolha de acoes (tempo de execucao)"

  if ! confirm_with_default "Executar validacao/instalacao de ferramentas?" "Y"; then
    RUN_TOOLS=false
  fi

  if [[ "$RUN_TOOLS" == true ]] && confirm_with_default "Incluir verificacao de Node.js + npm?" "N"; then
    WITH_NODE=true
  fi

  if ! confirm_with_default "Executar configuracao do Git?" "Y"; then
    RUN_GIT=false
  fi

  if confirm_with_default "Configurar .env.local?" "N"; then
    RUN_ENV_FILE=true
  fi

  if confirm_with_default "Configurar JAVA_HOME no ~/.bashrc?" "N"; then
    RUN_BASHRC=true
  fi

  if confirm_with_default "Configurar bloco gerenciado no ~/.npmrc?" "N"; then
    RUN_NPMRC=true
    if [[ -z "$NPM_REGISTRY" ]]; then
      read -r -p "NPM registry (enter para padrao): " maybe_registry
      if [[ -n "$maybe_registry" ]]; then
        NPM_REGISTRY="$maybe_registry"
      fi
    fi
  fi

  if ! confirm_with_default "Executar bootstrap Maven (dependency:go-offline + compile)?" "Y"; then
    RUN_MAVEN=false
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --yes) AUTO_YES=true ;;
      --dry-run) DRY_RUN=true ;;
      --skip-install) SKIP_INSTALL=true ;;
      --skip-maven) RUN_MAVEN=false ;;
      --with-node) WITH_NODE=true ;;
      --configure-npmrc) RUN_NPMRC=true ;;
      --with-env-file) RUN_ENV_FILE=true ;;
      --configure-bashrc) RUN_BASHRC=true ;;
      --git-scope|--git-name|--git-email|--default-branch|--credential|--db-url|--npm-registry)
        if [[ $# -lt 2 ]]; then
          echo "Error: missing value for $1"
          exit 1
        fi
        case "$1" in
          --git-scope) GIT_SCOPE="$2" ;;
          --git-name) GIT_NAME="$2" ;;
          --git-email) GIT_EMAIL="$2" ;;
          --default-branch) DEFAULT_BRANCH="$2" ;;
          --credential) CREDENTIAL_MODE="$2" ;;
          --db-url) SPRING_DB_URL="$2" ;;
          --npm-registry) NPM_REGISTRY="$2" ;;
        esac
        shift
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
    esac
    shift
  done
}

validate_inputs() {
  if [[ "$GIT_SCOPE" != "global" && "$GIT_SCOPE" != "local" ]]; then
    echo "Error: --git-scope must be 'global' or 'local'."
    exit 1
  fi

  if [[ -z "$DEFAULT_BRANCH" ]]; then
    echo "Error: --default-branch cannot be empty."
    exit 1
  fi

  case "$CREDENTIAL_MODE" in
    keep|cache|store|libsecret) ;;
    *)
      echo "Error: --credential must be one of keep|cache|store|libsecret."
      exit 1
      ;;
  esac

  if [[ ! -f "${PROJECT_ROOT}/pom.xml" ]]; then
    echo "Error: pom.xml not found in project root: ${PROJECT_ROOT}"
    exit 1
  fi
}

setup_tools() {
  print_section "Validating/installing tools"

  ensure_tool git "git"
  ensure_tool java "java"
  ensure_tool mvn "maven"
  ensure_tool docker "docker"
  ensure_docker_compose
  ensure_tool aws "aws"
  ensure_tool pg_isready "pg_isready"
  ensure_tool curl "curl"
  ensure_tool unzip "unzip"

  if [[ "$WITH_NODE" == true ]]; then
    ensure_tool node "node"
    ensure_tool npm "npm"
  fi

  local java_major
  java_major="$(parse_java_major)"
  if [[ -n "$java_major" && "$java_major" != "$REQUIRED_JAVA_MAJOR" ]]; then
    print_warn "Detected Java $java_major, project expects Java $REQUIRED_JAVA_MAJOR (pom.xml)."
  fi
}

set_git_value() {
  local scope_flag="$1"
  local key="$2"
  local desired="$3"
  local current

  current="$(git config "$scope_flag" --get "$key" || true)"
  if [[ "$current" == "$desired" ]]; then
    print_ok "Git $key already set to '$desired' ($scope_flag)."
    return
  fi

  if [[ -z "$current" ]] || confirm "Git $key is '$current' and will be changed to '$desired' ($scope_flag). Overwrite?"; then
    run_cmd "git -C \"${PROJECT_ROOT}\" config $scope_flag \"$key\" \"$desired\""
    print_ok "Updated Git $key ($scope_flag)."
  else
    print_info "Skipped Git $key"
  fi
}

setup_git() {
  local scope_flag="--global"
  if [[ "$GIT_SCOPE" == "local" ]]; then
    scope_flag="--local"
  fi

  print_section "Configuring Git ($GIT_SCOPE)"

  if [[ -z "$GIT_NAME" ]]; then
    GIT_NAME="$(git -C "${PROJECT_ROOT}" config "$scope_flag" --get user.name || true)"
    if [[ -z "$GIT_NAME" && "$AUTO_YES" == false ]]; then
      read -r -p "Git user.name: " GIT_NAME
    fi
  fi

  if [[ -z "$GIT_EMAIL" ]]; then
    GIT_EMAIL="$(git -C "${PROJECT_ROOT}" config "$scope_flag" --get user.email || true)"
    if [[ -z "$GIT_EMAIL" && "$AUTO_YES" == false ]]; then
      read -r -p "Git user.email: " GIT_EMAIL
    fi
  fi

  if [[ -n "$GIT_NAME" ]]; then
    set_git_value "$scope_flag" "user.name" "$GIT_NAME"
  fi
  if [[ -n "$GIT_EMAIL" ]]; then
    set_git_value "$scope_flag" "user.email" "$GIT_EMAIL"
  fi

  set_git_value "$scope_flag" "init.defaultBranch" "$DEFAULT_BRANCH"

  case "$CREDENTIAL_MODE" in
    keep)
      print_info "Keeping current credential.helper unchanged."
      ;;
    cache)
      set_git_value "$scope_flag" "credential.helper" "cache --timeout=3600"
      ;;
    store)
      set_git_value "$scope_flag" "credential.helper" "store"
      ;;
    libsecret)
      if [[ ! -x "/usr/lib/git-core/git-credential-libsecret" ]]; then
        print_warn "/usr/lib/git-core/git-credential-libsecret not found."
      else
        set_git_value "$scope_flag" "credential.helper" "/usr/lib/git-core/git-credential-libsecret"
      fi
      ;;
  esac
}

setup_env_file() {
  if [[ "$RUN_ENV_FILE" == false ]]; then
    print_info "Skipping .env.local setup"
    return
  fi

  local env_file="${PROJECT_ROOT}/.env.local"
  print_section "Configuring .env.local"

  if [[ ! -f "$env_file" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      print_info "[dry-run] create $env_file"
      return
    fi
    cat > "$env_file" <<EOF
# Local environment variables for API Ecommerce Bookanga
SPRING_DATASOURCE_URL=${SPRING_DB_URL}
EOF
    print_ok "Created $env_file"
    return
  fi

  local current_db_url
  current_db_url="$(grep -E '^SPRING_DATASOURCE_URL=' "$env_file" | tail -n1 | sed 's/^SPRING_DATASOURCE_URL=//' || true)"

  if [[ -n "$current_db_url" && "$current_db_url" != "$SPRING_DB_URL" ]] && ! confirm "Existing SPRING_DATASOURCE_URL differs. Overwrite?"; then
    print_info "Keeping existing .env.local SPRING_DATASOURCE_URL."
    return
  fi

  if [[ -z "$current_db_url" ]] || confirm "Update SPRING_DATASOURCE_URL in .env.local?"; then
    run_cmd "sed -i 's|^SPRING_DATASOURCE_URL=.*|SPRING_DATASOURCE_URL=${SPRING_DB_URL}|' \"$env_file\""
    if ! grep -q '^SPRING_DATASOURCE_URL=' "$env_file"; then
      run_cmd "printf '\nSPRING_DATASOURCE_URL=%s\n' \"$SPRING_DB_URL\" >> \"$env_file\""
    fi
    print_ok "Updated $env_file"
  else
    print_info "Skipped .env.local update"
  fi
}

bootstrap_project() {
  if [[ "$RUN_MAVEN" == false ]]; then
    print_info "Skipping Maven bootstrap"
    return
  fi

  print_section "Bootstrapping project with Maven"
  run_cmd "cd \"${PROJECT_ROOT}\" && mvn -q -DskipTests dependency:go-offline"
  run_cmd "cd \"${PROJECT_ROOT}\" && mvn -q -DskipTests compile"
  print_ok "Maven bootstrap finished."
}

main() {
  parse_args "$@"
  validate_inputs

  print_section "Bookanga setup"
  print_info "Project root: ${PROJECT_ROOT}"
  print_info "Target outcome: machine ready to build the project end-to-end."

  prompt_runtime_plan

  if [[ "$RUN_TOOLS" == true ]]; then
    setup_tools
  else
    print_info "Skipping tools validation/install"
  fi

  if [[ "$RUN_GIT" == true ]]; then
    setup_git
  else
    print_info "Skipping Git configuration"
  fi

  setup_env_file

  if [[ "$RUN_BASHRC" == true ]]; then
    configure_bashrc_java_home
  else
    print_info "Skipping ~/.bashrc JAVA_HOME configuration"
  fi

  if [[ "$RUN_NPMRC" == true ]]; then
    configure_npmrc
  else
    print_info "Skipping ~/.npmrc configuration"
  fi

  bootstrap_project

  print_ok "Setup finished."
}

main "$@"
