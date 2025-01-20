# Terraform module for playground VM

XXX

## Arguments

XXX

```hcl
module "foo" {
    source = "./foo"

    name = "playground"
    domain = "inmylab.de"
    location = "fsn1"
    type = "cpx32"

    hcloud_token = var.hcloud_token
    hetznerdns_token = var.hetznerdns_token

    include_certificate = true
    include_sshfp = false
}
```

XXX

| Argument            | Type   | Default | Description             |
| ------------------- | ------ | ------- | ----------------------- |
| name                | string |         | Name of the VM          |
| domain              | string |         | Domain name             |
| location            | string |         | Location of the VM      |
| type                | string |         | Type of the VM          |
| hcloud_token        | string |         | Hetzner Cloud API token |
| hetznerdns_token    | string |         | Hetzner DNS API token   |
| include_certificate | bool   | false   | Include certificate     |
| include_sshfp       | bool   | false   | Include SSHFP record    |
