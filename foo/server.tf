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