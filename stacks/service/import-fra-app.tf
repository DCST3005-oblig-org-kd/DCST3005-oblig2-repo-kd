# =============================================================================
# import-fra-app.tf – tar inn VM/NIC/IP eller App Service-plan/web app fra
# den gamle app-stacken. Hører sammen med removed-blokkene i
# stacks/app/main.tf. Bruker data.azurerm_resource_group.this fra
# import-fra-data.tf.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.
# =============================================================================

import {
  for_each = var.runtime == "vm" ? toset(["vm"]) : toset([])
  to       = module.vm[0].azurerm_linux_virtual_machine.this
  id       = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Compute/virtualMachines/vm-${var.tjeneste}"
}

import {
  for_each = var.runtime == "vm" ? toset(["vm"]) : toset([])
  to       = module.vm[0].azurerm_network_interface.this
  id       = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/networkInterfaces/nic-${var.tjeneste}"
}

import {
  for_each = var.runtime == "vm" ? toset(["vm"]) : toset([])
  to       = module.vm[0].azurerm_public_ip.this
  id       = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Network/publicIPAddresses/pip-${var.tjeneste}"
}

import {
  for_each = var.runtime == "webapp" ? toset(["webapp"]) : toset([])
  to       = module.webapp[0].azurerm_service_plan.this
  id       = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Web/serverFarms/asp-${var.tjeneste}"
}

import {
  for_each = var.runtime == "webapp" ? toset(["webapp"]) : toset([])
  to       = module.webapp[0].azurerm_linux_web_app.this
  id       = "${data.azurerm_resource_group.this.id}/providers/Microsoft.Web/sites/app-${var.kortnavn}-${var.tjeneste}-${var.miljo}"
}
