# =============================================================================
# import-fra-network.tf – tar inn ressursgruppa og VNet-et fra den gamle
# network-stacken. Hører sammen med removed-blokkene i stacks/network/main.tf.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.
# =============================================================================

import {
  to = azurerm_resource_group.this
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/rg-${var.kortnavn}-oblig2-${var.miljo}"
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/rg-${var.kortnavn}-oblig2-${var.miljo}/providers/Microsoft.Network/virtualNetworks/vnet-${var.kortnavn}-${var.miljo}"
}

data "azurerm_client_config" "current" {}
