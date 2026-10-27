# Ressursgruppa og VNet-et: det tjenestene faktisk deler. Flyttet fra
# network-stacken (migrerings-PR 3). Subnettene flytter til hver sin
# service-instans samtidig -- se stacks/service/main.tf.

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  location = var.location
  tags     = local.tags
}

module "vnet" {
  source = "../../modules/vnet"

  name                = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  tags                = local.tags
}
