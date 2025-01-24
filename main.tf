terraform {
  backend "http" {}
}

module "playground" {
  source = "github.com/nicholasdille/terraform-module-playground?ref=0.3.0"

  name         = "playground"
  domain       = "inmylab.de"
  location     = "fsn1"
  type         = "cpx31"
  image_filter = "type=docker"

  cloud_init_user_data = file("./cloud_init_user_data.txt")

  hcloud_token     = var.hcloud_token
  hetznerdns_token = var.hetznerdns_token

  include_certificate        = false
  use_letsencrypt_staging_ca = true

  include_sshfp = false
}