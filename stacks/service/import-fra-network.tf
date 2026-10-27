# =============================================================================
# import-fra-network.tf – tar inn subnett, NSG, NSG-regel og
# subnett-NSG-assosiasjonen fra den gamle network-stacken. Hører sammen med
# removed-blokkene i stacks/network/main.tf. Bruker
# data.azurerm_resource_group.this fra import-fra-data.tf.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.
# =============================================================================

import {
  to = module.subnet.azurerm_subnet.this
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/virtualNetworks/vnet-${var.kortnavn}-${var.miljo}/subnets/snet-${var.tjeneste}"
}

import {
  to = module.subnet.azurerm_network_security_group.this
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/networkSecurityGroups/nsg-${var.tjeneste}"
}

import {
  to = module.subnet.azurerm_network_security_rule.http
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/networkSecurityGroups/nsg-${var.tjeneste}/securityRules/allow-http"
}

# Assosiasjonen har IKKE sin egen ID -- den er identisk med subnett-ID-en.
import {
  to = module.subnet.azurerm_subnet_network_security_group_association.this
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/virtualNetworks/vnet-${var.kortnavn}-${var.miljo}/subnets/snet-${var.tjeneste}"
}
