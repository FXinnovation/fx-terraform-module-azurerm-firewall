###
# General
###

variable "enabled" {
  description = "Enable or disable module"
  default     = true
}

variable "resource_group_location" {
  description = "Specifies the supported Azure location where the resources exist. Changing this forces a new resource to be created."
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources in this module. Changing this forces a new resource to be created."
  default     = ""
}

variable "tags" {
  description = "Tags shared by all resources of this module. Will be merged with any other specific tags by resource"
  default     = {}
}

###
# Firewall
###

variable "name" {
  description = "Specifies the names of the firewall.Changing this forces a new resource to be created."
  default     = ""
}

variable "zones" {
  description = "Specifies the availabilty zones in which the Azure firewall should be created."
}

variable "firewall_tags" {
  description = "Tags which will be associated to the firewall resource only."
  type        = map
  default     = {}
}

variable "ip_configurations" {
  description = "One or more ip configuration blocks. `NOTE`: The subnet used for the firewall must have the name `AzureFirewallSubnet` and subnet mask must be at least /26. And at least one and only one `ip_configuration` block may contain a `subnet_id`."
  type        = list(object({ name = string, subnet_id = string, public_ip_address_id = string }))
  default     = [null]
}

###
# Firewall application rule
###


###
# Firewall NAT rule
###

###
# Firewall network rule
###
