provider "vault" {
  address = var.vault-address
  token   = var.vault-token
}

resource "vault_pki_secret_backend_cert" "f5-cert" {
  backend     = "pki"
  name        = "F5-LB"
  common_name = "f5-demo.hashicorp.example"
}

# resource "local_file" "as3" {
#   content = templatefile("nginx.tpl", {
#     certificate = jsonencode(vault_pki_secret_backend_cert.f5-cert.certificate),
#     privatekey  = jsonencode(vault_pki_secret_backend_cert.f5-cert.private_key)
#   })
#   filename = "nginx.json"
# }