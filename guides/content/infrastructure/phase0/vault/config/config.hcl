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
