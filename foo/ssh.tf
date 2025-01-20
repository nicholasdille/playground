resource "tls_private_key" "ssh_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ssh_public_key" {
  name       = var.name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
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
  content = templatefile("${path.module}/ssh_config.tpl", {
    node = hcloud_server.playground.name,
    node_ip = hcloud_server.playground.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/${var.name}")
  file_permission = "0644"
}