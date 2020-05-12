# terraform-module-azurerm-firewall

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |
| azurerm | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_rule\_actions | The list of action of the rules which will be aplied to matching traffic. Possible values are `Allow` and `Deny`. | `list(string)` | <pre>[<br>  "Deny"<br>]</pre> | no |
| application\_rule\_enabled | Boolean flag which describes whether or not to enable the firewall application rule. | `bool` | `false` | no |
| application\_rule\_names | Specifies the list of names of application rules collection which must be unique within the Firewall. Changing this forces a new resource to be created. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| application\_rule\_priorities | Specifies the list of priorities of the application rule collection. Possible values are between `100-65000`. | `list(number)` | <pre>[<br>  100<br>]</pre> | no |
| application\_rules | A list of list of map of options to apply. Map must support the following structure:<br>  * name(required, string): The Name of the rule (e.g. TFTEST)<br>  * description(Optional, string): Specifies a description for the rule.<br>  * source\_addresses(required, list of string): A list of source IP addresses and/or IP range (e.g. ["10.23.72.178"])<br>  * fqdn\_tags(Optional, list of string): A list of FQDN tags. Possible values are `AppServiceEnvironment`, `AzureBackup`, `MicrosoftActiveProtectiveService`, `WindowsDiagnostics` and `WindowsUpdate`<br>  * target\_fqdns(Optional, list of string): A list of FQDNs (e.g. ["\*.google.com"])<br>  * protocol(Optional, list of map): A list of map of protocol to apply:<br>      * port(Optional, number): A port for the connection.<br>      * protocol(required, string): The type of the connection. Possible values are `Http`,`Https` and `Mssql`.<br>For example, see folder examples/default | `any` | `[]` | no |
| enabled | Enable or disable module | `bool` | `true` | no |
| firewall\_exist | Boolean flag which describes whether the Azure firewall is already existing ot not. | `bool` | `false` | no |
| firewall\_tags | Tags which will be associated to the firewall resource only. | `map` | `{}` | no |
| ip\_configurations | One or more ip configuration blocks. `NOTE`: The subnet used for the firewall must have the name `AzureFirewallSubnet` and subnet mask must be at least /26. And at least one and only one `ip_configuration` block may contain a `subnet_id`. | `list(object({ name = string, subnet_id = string, public_ip_address_id = string }))` | <pre>[<br>  null<br>]</pre> | no |
| name | Specifies the names of the firewall. Changing this forces a new resource to be created. | `string` | `""` | no |
| nat\_rule\_actions | The List of actions of the rule which will be applied to matching traffic. Possible values are `Dnat` and `Snat`. | `list(string)` | <pre>[<br>  "Dnat"<br>]</pre> | no |
| nat\_rule\_enabled | Boolean flag which describes whether or not enable firewall nat rules. | `bool` | `false` | no |
| nat\_rule\_names | Specifies the list of names of the NAT rule collection which must be unique within the firewall. Changing this forces a new resource to be created. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_rule\_priorities | The list which specifies the priorities of the rule collection. Possible values are between `100-6500`. | `list(number)` | <pre>[<br>  101<br>]</pre> | no |
| nat\_rules | A list of list of map of options to apply. Map must support folowing structure:<br>  * name(required, string): Specifies the name of the rule.<br>  * description(Optional, string): Specifies a description for the rule.<br>  * destination\_addresses(required, list of string): A list of destination IP addesses and/or IP ranges.<br>  * destination\_ports(required, list of string): A list of destination ports.<br>  * protocols(required, list of numbers): A list of protocols. Posible values are `Any`, `ICMP`, `TCP` and `UDP`. If `action` is `Dnat`, protocols can only be `TCp` and `UDp`.<br>  * source\_addresses(required, list of string): A list of source IP addresses and/or IP ranges.<br>  * translated\_address(required, string): The address of the service behind the firewall.<br>  * translated\_port(required, number): The port of the service behind the firewall.<br>For example, see folder examples/default | `any` | `[]` | no |
| network\_rule\_actions | The List of actions of the rule which will be applied to matching traffic. Possible values are `Deny` and `Allow`. | `list(string)` | <pre>[<br>  "Deny"<br>]</pre> | no |
| network\_rule\_enabled | Boolean flag which describes whether or not enable firewall network rules. | `bool` | `false` | no |
| network\_rule\_names | Specifies the list of names of the network rule collection which must be unique within the firewall. Changing this forces a new resource to be created. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| network\_rule\_priorities | The list which specifies the priority of the rule collection. Possible values are between `100-6500`. | `list(number)` | <pre>[<br>  101<br>]</pre> | no |
| network\_rules | A list of list of map of options to apply. Map must support folowing structure:<br>  * name(required, string): Specifies the name of the rule.<br>  * description(Optional, string): Specifies a description for the rule.<br>  * source\_addresses(required, list of string): A list of source IP addresses and/or IP ranges.<br>  * destination\_addresses(required, list of string): A list of destination IP addesses and/or IP ranges.<br>  * destination\_ports(required, list of numbers): A list of destination ports.<br>  * protocols(required, list of string): A list of protocols. Posible values are `Any`, `ICMP`, `TCP` and `UDP`.<br>For example, see folder examples/default | `any` | `[]` | no |
| resource\_group\_location | Specifies the supported Azure location where the resources exist. Changing this forces a new resource to be created. | `string` | `"eastus"` | no |
| resource\_group\_name | The name of the resource group in which to create the resources in this module. Changing this forces a new resource to be created. | `string` | `""` | no |
| tags | Tags shared by all resources of this module. Will be merged with any other specific tags by resource | `map` | `{}` | no |
| zones | Specifies the availabilty zones in which the Azure firewall should be created. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Resource ID of the Azure firewall |
| ip\_configuration | The Ip configuration of the Azure firewall. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
