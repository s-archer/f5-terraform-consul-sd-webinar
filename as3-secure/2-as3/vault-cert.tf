provider "vault" {
  address = var.vault-address
  token   = var.vault-token
}

resource "vault_pki_secret_backend_cert" "f5-cert" {
  backend     = "pki"
  name        = "F5-LB"
  common_name = "f5-demo.hashicorp.example"
}