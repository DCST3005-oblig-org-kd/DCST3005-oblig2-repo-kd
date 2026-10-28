# =============================================================================
# import-fra-network.tf – tar inn ressursgruppa og VNet-et fra den gamle
# network-stacken. Hører sammen med removed-blokkene i stacks/network/main.tf.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.
# =============================================================================

data "azurerm_resource_group" "existing" {
  name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
}

import {
  to = azurerm_resource_group.this
  id = data.azurerm_resource_group.existing.id
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = "${data.azurerm_resource_group.existing.id}/providers/Microsoft.Network/virtualNetworks/vnet-${var.kortnavn}-${var.miljo}"
}
