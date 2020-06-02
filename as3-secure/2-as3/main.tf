terraform {
  required_providers {
    bigip = "= 1.1.2"
  }
}

provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = "${var.username}"
  password = "${var.password}"
}

# download rpm
resource "null_resource" "download_as3" {
  provisioner "local-exec" {
    command = "wget ${var.as3_rpm_url}"
  }
}

# install rpm to BIG-IP
resource "null_resource" "install_as3" {
  provisioner "local-exec" {
    command = "./install_as3.sh ${var.address}:${var.port} admin:${var.password} ${var.as3_rpm}"
  }
  depends_on = [null_resource.download_as3]
}

# deploy application using as3
resource "bigip_as3" "nginx" {
  # as3_json    = "${file("nginx.json")}"
  as3_json = templatefile("nginx.tpl", {
    certificate = jsonencode(vault_pki_secret_backend_cert.f5-cert.certificate),
    privatekey  = jsonencode(vault_pki_secret_backend_cert.f5-cert.private_key)
  })
  tenant_name = "consul_sd"
  depends_on  = [null_resource.install_as3]
}
