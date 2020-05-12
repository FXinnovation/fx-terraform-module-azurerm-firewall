###
# Firewall
###

output "id" {
  description = "The Resource ID of the Azure firewall"
  value       = element(concat(azurerm_firewall.this.*.id, [""]), 0)
}

output "ip_configuration" {
  description = "The Ip configuration of the Azure firewall."
  value       = azurerm_firewall.this.*.ip_configuration
}
