# Create-SecureInfrastructure.ps1
# This script creates the required directory structure and files for a secure Vault environment
# using Docker Desktop on Windows with best practices applied.
# Base Directory: C:\Users\cap10bill\dev\logbooking\cap10.tech\content\infrastructure\phase0

# Define base directory
$baseDir = "C:\Users\cap10bill\dev\logbooking\cap10.tech\content\infrastructure\phase0"

# Define additional directories
$vaultConfigDir = Join-Path $baseDir "vault\config"
$vaultLogsDir   = Join-Path $baseDir "vault\logs"

# Create base directory if it doesn't exist
if (!(Test-Path $baseDir)) {
    Write-Output "Creating base directory: $baseDir"
    New-Item -Path $baseDir -ItemType Directory -Force
} else {
    Write-Output "Base directory already exists: $baseDir"
}

# Create vault/config directory
if (!(Test-Path $vaultConfigDir)) {
    Write-Output "Creating Vault config directory: $vaultConfigDir"
    New-Item -Path $vaultConfigDir -ItemType Directory -Force
} else {
    Write-Output "Vault config directory already exists: $vaultConfigDir"
}

# Create vault/logs directory for audit logs
if (!(Test-Path $vaultLogsDir)) {
    Write-Output "Creating Vault logs directory: $vaultLogsDir"
    New-Item -Path $vaultLogsDir -ItemType Directory -Force
} else {
    Write-Output "Vault logs directory already exists: $vaultLogsDir"
}

# Create docker-compose.yml in the base directory
$dockerComposePath = Join-Path $baseDir "docker-compose.yml"
$dockerComposeContent = @"
version: "3.8"
services:
  vault:
    image: vault:latest
    container_name: vault
    ports:
      - "8200:8200"
    environment:
      # Use production values here – initialization will be manual
      VAULT_LOCAL_CONFIG: |
        {
          "listener": [{
            "tcp": {
              "address": "0.0.0.0:8200",
              "tls_cert_file": "/vault/config/vault.crt",
              "tls_key_file": "/vault/config/vault.key"
            }
          }],
          "storage": {
            "raft": {
              "path": "/vault/data",
              "node_id": "vault-node1"
            }
          },
          "ui": true,
          "audit": [{
            "file_path": "/vault/logs/audit.log",
            "log_raw": true
          }]
        }
    volumes:
      - ./vault/config:/vault/config
      - ./vault/logs:/vault/logs
      - vault_data:/vault/data
    cap_add:
      - IPC_LOCK
    command: "server"

  caddy:
    image: caddy:latest
    container_name: caddy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
volumes:
  vault_data:
  caddy_data:
  caddy_config:
"@
Write-Output "Creating docker-compose.yml..."
Set-Content -Path $dockerComposePath -Value $dockerComposeContent -Force

# Create Vault secure configuration file: vault/config/config.hcl (optional if using VAULT_LOCAL_CONFIG env variable)
$configHclPath = Join-Path $vaultConfigDir "config.hcl"
$configHclContent = @"
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/vault/config/vault.crt"
  tls_key_file  = "/vault/config/vault.key"
}

storage "raft" {
  path    = "/vault/data"
  node_id = "vault-node1"
}

audit {
  file_path = "/vault/logs/audit.log"
  log_raw   = true
}

ui = true
"@
Write-Output "Creating Vault secure config file: config.hcl..."
Set-Content -Path $configHclPath -Value $configHclContent -Force

# Create Caddyfile in the base directory
$caddyFilePath = Join-Path $baseDir "Caddyfile"
$caddyFileContent = @"
vault.local {
    reverse_proxy vault:8200
    tls youremail@example.com
}
"@
Write-Output "Creating Caddyfile..."
Set-Content -Path $caddyFilePath -Value $caddyFileContent -Force

Write-Output "Secure Vault project files created successfully in $baseDir"
