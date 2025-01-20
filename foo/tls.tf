provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "certificate" {
  count = var.include_certificate ? 1 : 0

  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  count = var.include_certificate ? 1 : 0

  account_key_pem = tls_private_key.certificate[0].private_key_pem
  email_address   = "webmaster@${var.domain}"
}

resource "acme_certificate" "playground" {
  count = var.include_certificate ? 1 : 0

  account_key_pem           = acme_registration.reg[0].account_key_pem
  common_name               = "playground.${var.domain}"
  subject_alternative_names = [
    "*.${var.name}.${var.domain}"
  ]

  dns_challenge {
    provider = "hetzner"

    config = {
      HETZNER_API_KEY = var.hetznerdns_token
    }
  }
}

resource "null_resource" "wait_for_ssh" {
  count = var.include_certificate ? 1 : 0

  provisioner "remote-exec" {
    connection {
      host = hcloud_server.playground.ipv4_address
      user = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}

resource "remote_file" "tls_key" {
  count = var.include_certificate ? 1 : 0

  conn {
    host        = hcloud_server.playground.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.key"
  content     = acme_certificate.playground[0].private_key_pem
  permissions = "0600"
}

resource "remote_file" "tls_crt" {
  count = var.include_certificate ? 1 : 0

  conn {
    host        = hcloud_server.playground.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.crt"
  content     = acme_certificate.playground[0].certificate_pem
  permissions = "0644"
}

resource "remote_file" "tls_chain" {
  count = var.include_certificate ? 1 : 0

  conn {
    host        = hcloud_server.playground.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.chain"
  content     = acme_certificate.playground[0].issuer_pem
  permissions = "0644"
}