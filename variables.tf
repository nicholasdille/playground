variable "name" {
  type = string
}

variable "domain" {
  type    = string
  default = "inmylab.de"
}

variable "location" {
  type    = string
  default = "hel1"
}

variable "type" {
  type    = string
  default = "cpx32"
}

variable "hcloud_token" {
  sensitive = true
}

variable "hetznerdns_token" {
  sensitive = true
}