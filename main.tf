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
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this[0].name : azurerm_firewall.this[0].name
  priority            = element(var.application_rule_priorities, count.index)
  action              = element(var.application_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.application_rules[count.index]

    content {
      name             = rule.value.name
      description      = lookup(rule.value, "description", null)
      source_addresses = lookup(rule.value, "source_addresses", null)
      target_fqdns     = lookup(rule.value, "target_fqdns", null)
      fqdn_tags        = lookup(rule.value, "fqdn_tags", null)

      dynamic "protocol" {
        for_each = rule.value.protocol

        content {
          port = protocol.value.port
          type = protocol.value.type
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
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this[0].name : azurerm_firewall.this[0].name
  priority            = element(var.nat_rule_priorities, count.index)
  action              = element(var.nat_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.nat_rules[count.index]

    content {
      name                  = rule.value.name
      description           = lookup(rule.value, "description", null)
      destination_addresses = lookup(rule.value, "destination_addresses", null)
      destination_ports     = lookup(rule.value, "destination_ports", null)
      protocols             = lookup(rule.value, "protocols", null)
      source_addresses      = lookup(rule.value, "source_addresses", null)
      translated_address    = lookup(rule.value, "translated_address", null)
      translated_port       = lookup(rule.value, "translated_port", null)
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
  azure_firewall_name = var.firewall_exist ? data.azurerm_firewall.this[0].name : azurerm_firewall.this[0].name
  priority            = element(var.network_rule_priorities, count.index)
  action              = element(var.network_rule_actions, count.index)

  dynamic "rule" {
    for_each = var.network_rules[count.index]

    content {
      name                  = rule.value.name
      description           = lookup(rule.value, "description", null)
      source_addresses      = lookup(rule.value, "source_addresses", null)
      destination_addresses = lookup(rule.value, "destination_addresses", null)
      destination_ports     = lookup(rule.value, "destination_ports", null)
      protocols             = lookup(rule.value, "protocols", null)
    }
  }
}
