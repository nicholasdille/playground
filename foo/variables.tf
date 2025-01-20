variable "name" {
  type = string
}

variable "domain" {
  type    = string
}

variable "location" {
  type    = string
}

variable "type" {
  type    = string
}

variable "include_certificate" {
  type = bool
  default = false
}

variable "include_sshfp" {
  type = bool
  default = false
}

variable "hcloud_token" {
  sensitive = true
}

variable "hetznerdns_token" {
  sensitive = true
}