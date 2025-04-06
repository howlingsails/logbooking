# Infrastructure Phase 0 - Secure Vault Environment Setup

## Overview

This project provides a secure environment for deploying HashiCorp Vault using best practices. It emphasizes secure communications with TLS, a robust storage backend with Integrated Raft, comprehensive audit logging, and secure initialization procedures. Additionally, Caddy is used for TLS termination and reverse proxying.

## Directory Structure

The project directory is organized as follows:

- **docker-compose.yml**  
  Docker Compose file to orchestrate Vault and Caddy containers.

- **vault/config/config.hcl**  
  Vault configuration file, including TLS settings, Raft storage, and audit logging.

- **vault/logs/**  
  Directory for Vault audit logs.

- **Caddyfile**  
  Caddy configuration file for reverse proxy and TLS termination.

- **Create-SecureInfrastructure.ps1**  
  PowerShell script to automatically create the directory structure and populate the necessary configuration files.

## Prerequisites

- **Docker & Docker Compose:**  
  Ensure Docker and Docker Compose are installed and running on your system.

- **PowerShell:**  
  This setup script is designed for Windows using PowerShell.

- **TLS Certificates:**  
  Ensure you have your TLS certificate (`vault.crt`) and key (`vault.key`) placed in the `vault/config` directory.

- **Basic Vault Knowledge:**  
  Familiarity with Vault's initialization and unsealing processes is recommended.

## Setup Instructions

1. **Clone or Download the Repository**  
   Ensure that the project files are available locally on your machine.

2. **Run the Setup Script**  
   Open PowerShell and navigate to the base directory:
   ```powershell
   cd C:\Users\cap10bill\dev\logbooking\cap10.tech\content\infrastructure\phase0
   .\Create-SecureInfrastructure.ps1
   ```
This script will create the required directories (`vault/config`, `vault/logs`) and files (`docker-compose.yml`, `config.hcl`, and `Caddyfile`).

3. **Review and Customize Configurations**
  - **TLS Certificates:**  
    Place your TLS certificate and key as `vault.crt` and `vault.key` in the `vault/config` directory.
  - **Caddyfile:**  
    Update the domain and email settings in the `Caddyfile` with your actual values.
  - **Additional Configurations:**  
    Adjust settings in `docker-compose.yml` and `vault/config/config.hcl` if needed to match your production requirements.

## Running the Environment

Once the setup is complete:

1. **Start the Containers:**  
   In PowerShell, run:
   ```powershell
   docker-compose up -d
   ```
   This starts Vault and Caddy in detached mode.

2. **Vault Initialization & Unsealing:**
  - **Initialize Vault:**  
    Use Vault’s initialization procedure to generate unseal keys and the root token.
  - **Distribute Keys:**  
    Securely distribute unseal keys using Shamir’s Secret Sharing.
  - **Unseal Vault:**  
    Unseal Vault by providing the required number of keys.

## Audit Logging

Vault is configured to log all operations to `vault/logs/audit.log`. Monitor these logs regularly to ensure all activities are recorded and to help detect any anomalies.

## Final Notes

This secure environment setup follows Vault’s best practices. Ensure you review and adjust configurations to comply with your organizational security policies and operational requirements. For any production deployment, additional security hardening may be required.

Enjoy your secure Vault deployment!
