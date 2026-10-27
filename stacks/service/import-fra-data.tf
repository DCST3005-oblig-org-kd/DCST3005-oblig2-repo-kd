# =============================================================================
# import-fra-data.tf – tar inn storage account og Key Vault fra den gamle
# data-stacken. Hører sammen med removed-blokken i stacks/data/main.tf.
#
# FJERNES når K8-opprydding er gjort i begge miljøer (etter at migrerings-PR 1
# er promotert til prod).
# =============================================================================

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

import {
  to = module.storage.azurerm_storage_account.this
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Storage/storageAccounts/st${var.kortnavn}${var.tjeneste}${var.miljo}"
}

import {
  to = module.keyvault.azurerm_key_vault.this
  id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.KeyVault/vaults/kv-${var.kortnavn}-${var.tjeneste}-${var.miljo}"
}
