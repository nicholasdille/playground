module "playground" {
    source = "github.com/nicholasdille/terraform-module-playground?ref=0.1.0"

    name = "playground"
    domain = "inmylab.de"
    location = "fsn1"
    type = "cpx32"

    hcloud_token = var.hcloud_token
    hetznerdns_token = var.hetznerdns_token

    include_certificate = true
    include_sshfp = false
}