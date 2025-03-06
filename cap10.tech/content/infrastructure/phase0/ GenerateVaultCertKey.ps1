# GenerateVaultSignedCert.ps1
# This script generates an encrypted private key for vault.cap10.tech,
# creates a certificate signing request (CSR), and then signs the CSR using
# your existing wildcard CA certificate and key (cap10.tech.crt and cap10.tech.key).
#
# Prerequisites:
# - OpenSSL must be installed and available in the system PATH.
# - Your CA certificate and private key (cap10.tech.crt and cap10.tech.key)
#   must be available in the script's directory (or update the paths accordingly).
# - The CA key must be permitted to sign certificates for subdomains.
#
# Usage:
#   .\GenerateVaultSignedCert.ps1

# Prompt for passphrase to encrypt the Vault private key
$secureVaultPassphrase = Read-Host "Enter a passphrase for the vault private key" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureVaultPassphrase)
$vaultPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

# Prompt for passphrase for the CA private key
$secureCAPassphrase = Read-Host "Enter the passphrase for your CA private key (if any, else leave blank)" -AsSecureString
$BSTR_CA = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureCAPassphrase)
$caPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_CA)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR_CA)

# Define file paths
$vaultKeyPath = "vault.key"
$vaultCsrPath = "vault.csr"
$vaultCertPath = "vault.crt"

# Paths for your wildcard CA certificate and key. Adjust if needed.
$caCertPath = "cap10.tech.crt"
$caKeyPath  = "cap10.tech.key"

# Check if OpenSSL is available
if (-not (Get-Command openssl -ErrorAction SilentlyContinue)) {
    Write-Error "OpenSSL not found in PATH. Please install OpenSSL and ensure it's in your system PATH."
    exit 1
}

# Generate an encrypted private key for vault.cap10.tech using AES-256 encryption
Write-Output "Generating encrypted private key for vault.cap10.tech..."
$genKeyCmd = "openssl genrsa -aes256 -passout pass:$vaultPassphrase -out $vaultKeyPath 2048"
Invoke-Expression $genKeyCmd

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to generate the vault private key."
    exit 1
}

# Generate a CSR using the encrypted private key
Write-Output "Generating CSR for vault.cap10.tech..."
$subject = "/CN=vault.cap10.tech"
$genCsrCmd = "openssl req -new -key $vaultKeyPath -passin pass:$vaultPassphrase -out $vaultCsrPath -subj `"$subject`""
Invoke-Expression $genCsrCmd

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to generate CSR."
    exit 1
}

# Sign the CSR with your wildcard CA certificate and key to create the vault certificate.
# Adjust the extensions as needed; here we set basic constraints for a typical server certificate.
Write-Output "Signing the CSR with your wildcard CA to generate the vault certificate..."
# Create a temporary config file for extensions
$tempExtFile = "vault_ext.cnf"
@"
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = vault.cap10.tech
"@ | Out-File -Encoding ASCII $tempExtFile

# Sign the CSR. The -passin flag is used if your CA key is encrypted.
$signCsrCmd = "openssl x509 -req -in $vaultCsrPath -CA $caCertPath -CAkey $caKeyPath -CAcreateserial -passin pass:$caPassphrase -out $vaultCertPath -days 365 -extfile $tempExtFile"
Invoke-Expression $signCsrCmd

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to sign the CSR with the CA certificate."
    Remove-Item $tempExtFile -Force
    exit 1
}

# Clean up the temporary extension file and CA serial file (if created)
Remove-Item $tempExtFile -Force
if (Test-Path "cap10.tech.srl") { Remove-Item "cap10.tech.srl" -Force }

Write-Output "Successfully generated vault.crt and vault.key for vault.cap10.tech."
