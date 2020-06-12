provider "vault" {
  address = var.vault-address
  token   = var.vault-token
}

resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "PKI for F5 certs"
}

resource "vault_pki_secret_backend_root_cert" "F5" {
  backend = vault_mount.pki.path
  type               = "internal"
  common_name        = "Root CA"
  ttl                = "315360000"
  format             = "pem"
  private_key_format = "der"
  key_type           = "rsa"
  key_bits           = 4096
  ou                 = "F5 Demo"
  organization       = "HashiCorp-F5"
}

resource "vault_pki_secret_backend_role" "role" {
  backend          = vault_mount.pki.path
  name             = "F5-LB"
  ttl              = "7200"
  max_ttl          = "14400"
  allowed_domains  = ["hashicorp.example"]
  allow_subdomains = true
}