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

variable "firewall_exist" {
  description = "Boolean flag which describes whether the Azure firewall is already existing ot not."
  default     = false
}

variable "name" {
  description = "Specifies the names of the firewall. Changing this forces a new resource to be created."
  default     = ""
}

variable "zones" {
  description = "Specifies the availabilty zones in which the Azure firewall should be created."
  default     = null
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

variable "application_rule_enabled" {
  description = "Boolean flag which describes whether or not to enable the firewall application rule."
  default     = false
}

variable "application_rule_count" {
  description = "Number of firewall application rules collection to create. Setting this value to 0 will not deploy any application rule collection related to the firewall."
  default     = 1
}

variable "application_rule_names" {
  description = "Specifies the list of names of application rules collection which must be unique within the Firewall. Changing this forces a new resource to be created."
  type        = list(string)
  default     = [""]
}

variable "application_rule_priorities" {
  description = "Specifies the list of priorities of the application rule collection. Possible values are between `100-65000`."
  type        = list(number)
  default     = [100]
}

variable "application_rule_actions" {
  description = "The list of action of the rules which will be aplied to matching traffic. Possible values are `Allow` and `Deny`."
  type        = list(string)
  default     = ["Deny"]
}

variable "application_rules" {
  description = <<-DOCUMENTATION
  A list of list of map of options to apply. Map must support the following structure:
    * name(required, string): The Name of the rule.
    * description(Optional, string): Specifies a description for the rule.
    * source_addresses(required, list of string): A list of source IP addresses and/or IP range (e.g. ["10.23.72.178"])
    * fqdn_tags(Optional, list of string): A list of FQDN tags. Possible values are `AppServiceEnvironment`, `AzureBackup`, `MicrosoftActiveProtectiveService`, `WindowsDiagnostics` and `WindowsUpdate`
    * target_fqdns(Optional, list of string): A list of FQDNs (e.g. ["*.google.com"])
    * protocol(Optional, list of map): A list of map of protocol to apply:
        * port(Optional, number): A port for the connection.
        * protocol(required, string): The type of the connection. Possible values are `Http`,`Https` and `Mssql`.
  For example, see folder examples/default
  DOCUMENTATION
  type        = list
  default     = []
}

###
# Firewall NAT rule
###

variable "nat_rule_enabled" {
  description = "Boolean flag which describes whether or not enable firewall nat rules."
  default     = false
}

variable "nat_rule_count" {
  description = "Number of firewall NAT rules collection to create. Setting this value to 0 will not deploy any NAT rule collection related to the firewall."
  default     = 1
}

variable "nat_rule_names" {
  description = "Specifies the list of names of the NAT rule collection which must be unique within the firewall. Changing this forces a new resource to be created."
  type        = list(string)
  default     = [""]
}

variable "nat_rule_priorities" {
  description = "The list which specifies the priorities of the rule collection. Possible values are between `100-6500`."
  type        = list(number)
  default     = [101]
}

variable "nat_rule_actions" {
  description = "The List of actions of the rule which will be applied to matching traffic. Possible values are `Dnat` and `Snat`."
  type        = list(string)
  default     = ["Dnat"]
}

variable "nat_rules" {
  description = <<-DOCUMENTATION
  A list of list of map of options to apply. Map must support following structure:
    * name(required, string): Specifies the name of the rule.
    * description(Optional, string): Specifies a description for the rule.
    * destination_addresses(required, list of string): A list of destination IP addesses and/or IP ranges.
    * destination_ports(required, list of string): A list of destination ports.
    * protocols(required, list of numbers): A list of protocols. Possible values are `Any`, `ICMP`, `TCP`,`UDP`. If `action` is `Dnat`, protocols can only be `TCp` ,`UDp`.
    * source_addresses(required, list of string): A list of source IP addresses and/or IP ranges.
    * translated_address(required, string): The address of the service behind the firewall.
    * translated_port(required, number): The port of the service behind the firewall.
  For example, see folder examples/default
  DOCUMENTATION
  type        = list
  default     = []
}

###
# Firewall network rule
###

variable "network_rule_enabled" {
  description = "Boolean flag which describes whether or not enable firewall network rules."
  default     = false
}

variable "network_rule_count" {
  description = "Number of network rule collection to create. Setting this value to 0 will not deploy any network rule collection related to the firewall."
  default     = 1
}

variable "network_rule_names" {
  description = "Specifies the list of names of the network rule collection which must be unique within the firewall. Changing this forces a new resource to be created."
  type        = list(string)
  default     = [""]
}

variable "network_rule_priorities" {
  description = "The list which specifies the priority of the rule collection. Possible values are between `100-6500`."
  type        = list(number)
  default     = [101]
}

variable "network_rule_actions" {
  description = "The List of actions of the rule which will be applied to matching traffic. Possible values are `Deny` and `Allow`."
  type        = list(string)
  default     = ["Deny"]
}

variable "network_rules" {
  description = <<-DOCUMENTATION
  A list of list of map of options to apply. Map must support following structure:
    * name(required, string): Specifies the name of the rule.
    * description(Optional, string): Specifies a description for the rule.
    * source_addresses(required, list of string): A list of source IP addresses and/or IP ranges.
    * destination_addresses(required, list of string): A list of destination IP addesses and/or IP ranges.
    * destination_ports(required, list of numbers): A list of destination ports.
    * protocols(required, list of string): A list of protocols. Possible values are `Any`, `ICMP`, `TCP`, `UDP`.
  For example, see folder examples/default
  DOCUMENTATION
  type        = list
  default     = []
}
