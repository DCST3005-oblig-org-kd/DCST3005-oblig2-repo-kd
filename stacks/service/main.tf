# Service-stacken: én definisjon, rullet ut som én instans per tjeneste
# (ordre, meny) -- se config/<miljo>/service-ordre.tfvars og service-meny.tfvars.
#
# Bygges opp i flere PR-er under migreringen:
#   PR 1 (denne): storage account + Key Vault, flyttet fra data-stacken
#   PR 2:          kjøremiljø (VM eller web app), flyttet fra app-stacken
#   PR 4:          subnett + NSG, flyttet fra network-stacken, og bytte til
#                  å lese ressursgruppe/VNet fra shared-network i stedet for
#                  det lokale navnemønsteret under.

data "azurerm_client_config" "current" {}

locals {
  # Samme navnemønster som network-stacken bruker i dag. Byttes til å lese
  # fra shared-network sine outputs i PR 4, når RG+VNet har flyttet dit.
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"

  tags = {
    eier     = var.kortnavn
    miljo    = var.miljo
    kurs     = "dcst3005-oblig2"
    tjeneste = var.tjeneste
  }
}

module "storage" {
  source = "../../modules/storage"

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}
