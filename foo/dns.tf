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