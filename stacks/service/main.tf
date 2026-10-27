# Service-stacken: én definisjon, rullet ut som én instans per tjeneste
# (ordre, meny) -- se config/<miljo>/service-ordre.tfvars og service-meny.tfvars.
#
# Bygges opp i flere PR-er under migreringen:
#   PR 1: storage account + Key Vault, flyttet fra data-stacken
#   PR 2 (denne): kjøremiljø (VM eller web app), flyttet fra app-stacken
#   PR 4: subnett + NSG, flyttet fra network-stacken, og bytte til å lese
#         ressursgruppe/VNet fra shared-network i stedet for network.

data "azurerm_client_config" "current" {}

# Subnettet ligger fortsatt i network-stacken til PR 4.
data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = "oblig2/${var.miljo}/network.tfstate"
    use_azuread_auth     = true
  }
}

locals {
  # Samme navnemønster som network-stacken bruker i dag. Byttes til å lese
  # fra shared-network sine outputs i PR 4, når RG+VNet har flyttet dit.
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  subnet_id           = data.terraform_remote_state.network.outputs.subnet_ids[var.tjeneste]

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

module "vm" {
  source = "../../modules/vm"
  count  = var.runtime == "vm" ? 1 : 0

  service             = var.tjeneste
  resource_group_name = local.resource_group_name
  location            = var.location
  subnet_id           = local.subnet_id
  size                = var.vm_size
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "webapp" {
  source = "../../modules/webapp"
  count  = var.runtime == "webapp" ? 1 : 0

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  subnet_id           = local.subnet_id
  sku                 = var.webapp_sku
  tags                = local.tags
}
