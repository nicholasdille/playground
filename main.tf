provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "ssh_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ssh_public_key" {
  name       = var.name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

data "hcloud_image" "packer" {
  with_selector = "type=docker"
  most_recent = true
}

resource "hcloud_server" "playground" {
  name        = var.name
  location    = var.location
  server_type = var.type
  image       = data.hcloud_image.packer.id
  ssh_keys    = [
    hcloud_ssh_key.ssh_public_key.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.name
  }
}

data "hetznerdns_zone" "main" {
  name = var.domain
}

resource "hetznerdns_record" "hosta" {
  zone_id = data.hetznerdns_zone.main.id
  name    = var.name
  value   = hcloud_server.playground.ipv4_address
  type    = "A"
  ttl     = 120
}

resource "hetznerdns_record" "hostaaaa" {
  zone_id = data.hetznerdns_zone.main.id
  name    = var.name
  value   = hcloud_server.playground.ipv6_address
  type    = "AAAA"
  ttl     = 120
}

resource "hetznerdns_record" "wildcard" {
  zone_id = data.hetznerdns_zone.main.id
  name    = "*.${var.name}"
  value   = hetznerdns_record.hosta.name
  type    = "CNAME"
  ttl     = 120
}

resource "local_file" "ssh" {
  content = tls_private_key.ssh_private_key.private_key_openssh
  filename = pathexpand("~/.ssh/${var.name}_ssh")
  file_permission = "0600"
}

resource "local_file" "ssh_pub" {
  content = tls_private_key.ssh_private_key.public_key_openssh
  filename = pathexpand("~/.ssh/${var.name}_ssh.pub")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file" {
  content = templatefile("ssh_config.tpl", {
    node = hcloud_server.playground.name,
    node_ip = hcloud_server.playground.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/${var.name}")
  file_permission = "0644"
}
