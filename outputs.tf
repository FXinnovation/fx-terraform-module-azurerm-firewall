###
# Firewall
###

output "id" {
  description = "The Resource ID of the Azure firewall"
  value       = element(concat(azurem_firewall.this.*.id, [""]), 0)
}

output "ip_configuration" {
  description = "The Ip configuration of the Azure firewall."
  value       = azurem_firewall.this.*.ip_configuration
}
