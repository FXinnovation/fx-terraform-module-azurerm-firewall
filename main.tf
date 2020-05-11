###
# Firewall
###

resource "azurerm_firewall" "this" {
  count = var.enabled && var.firewall_exist == false ? 1 : 0

  name                = var.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  zones               = var.zones

  dynamic "ip_configuration" {
    for_each = var.ip_configurations

    content {
      name                 = ip_configuration.value.name
      subnet_id            = ip_configuration.value.subnet_id
      public_ip_address_id = ip_configuration.value.public_ip_address_id
    }
  }

  tags = merge(
    var.tags,
    var.firewall_tags,
    {
      Terraform = "true"
    },
  )


}


###
# Firewall application rule
###

resource "azurerm_firewall_application_rule_collection" "this" {
  count = var.enabled && var.application_rule_enabled ? length(var.application_rule_names) : 0

  name                = var.application_rule_names[count.index]
  resource_group_name = var.resource_group_name
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this.name : azurerm_firewall.this.name
  priority            = element(var.application_rule_priorities, count.index)
  action              = element(var.application_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.application_rules[count.index]

    content {
      name             = rule.value.name
      description      = rule.value.description
      source_addresses = rule.vaule.source_addresses
      target_fqdns     = rule.value.target_fqdns
      fqdn_tags        = rule.value.fqdn_tags

      dynamic "protocol" {
        for_each = var.protocol_types[count.index] != "" ? [1] : []

        content {
          port = var.protocol_ports[count.index]
          type = var.protocol_types[count.index]
        }
      }
    }
  }

}

###
# Firewall NAT rule
###

resource "azurerm_firewall_nat_rule_collection" "this" {
  count = var.enabled && var.nat_rule_enabled ? length(var.nat_rule_names) : 0

  name                = var.nat_rule_names[count.index]
  resource_group_name = var.resource_group_name
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this.name : azurerm_firewall.this.name
  priority            = element(var.nat_rule_priorities, count.index)
  action              = element(var.nat_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.nat_rules[count.index]

    content {
      name                  = rule.value.name
      description           = rule.value.description
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.destination_ports
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}

###
# Firewall network rule
###

resource "azurerm_firewall_network_rule_collection" "this" {
  count = var.enabled && var.network_rule_enabled ? length(var.nat_rule_names) : 0

  name                = var.network_rule_names[count.index]
  resource_group_name = var.resource_group_name
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this.name : azurerm_firewall.this.name
  priority            = element(var.network_rule_priorities, count.index)
  action              = element(var.network_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.network_rules[count.index]

    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.destination_ports
      protocols             = rule.value.protocols

    }
  }
}
