resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "tftest${random_string.this.result}"
  location = "West Europe"

  tags = {
    Owner   = "Terraform"
    EndDate = "2020-05-15"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "tftest${random_string.this.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "tftest${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_route_table" "example" {
  name                          = "tftest${random_string.this.result}"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "vnetlocal"
  }
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
}

resource "azurerm_public_ip" "example" {
  name                = "tftest${random_string.this.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "example" {
  name                = "tftest${random_string.this.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "tftest${random_string.this.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

module "example" {
  source = "../.."

  name                    = "tftest${random_string.this.result}"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  ip_configurations = [
    {
      name                 = "tftest${random_string.this.result}"
      subnet_id            = azurerm_subnet.firewall.id
      public_ip_address_id = azurerm_public_ip.example.id
    }
  ]

  application_rule_enabled    = true
  application_rule_names      = ["tftest${random_string.this.result}", "tftest${random_string.this.result}1"]
  application_rule_priorities = [100, 101]
  application_rule_actions    = ["Allow"]

  application_rules = [
    [
      {
        name             = "tftest${random_string.this.result}"
        source_addresses = ["10.0.0.0/16"]
        target_fqdns     = ["*.google.com", "*.microsoft.com"]

        protocol = [
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ],
    [
      {
        name             = "tftest${random_string.this.result}1"
        source_addresses = ["10.0.0.0/16"]
        target_fqdns     = ["*.google.com", "*.fxinnovation.com"]

        protocol = [
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ]
  ]

  nat_rule_enabled    = true
  nat_rule_names      = ["tftest${random_string.this.result}2"]
  nat_rule_priorities = [200]
  nat_rule_actions    = ["Dnat"]

  nat_rules = [
    [
      {
        name                  = "tftest${random_string.this.result}"
        source_addresses      = ["*"]
        destination_addresses = ["${azurerm_public_ip.example.ip_address}"]
        destination_ports     = [3389]
        protocols             = ["TCP", "UDP"]
        translated_address    = "${azurerm_windows_virtual_machine.example.private_ip_address}"
        translated_port       = 3389
      }
    ]
  ]

  network_rule_enabled    = true
  network_rule_names      = ["tftest${random_string.this.result}3"]
  network_rule_priorities = [300]
  network_rule_actions    = ["Allow"]

  network_rules = [
    [
      {
        name                  = "tftest${random_string.this.result}3"
        source_addresses      = ["10.0.0.0/16"]
        destination_addresses = ["8.8.8.8", "8.8.4.4"]
        destination_ports     = [53]
        protocols             = ["TCP", "UDP"]
      }
    ]
  ]
}
