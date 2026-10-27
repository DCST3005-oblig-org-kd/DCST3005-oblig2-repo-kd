# Service-stacken: én definisjon, rullet ut som én instans per tjeneste
# (ordre, meny) -- se config/<miljo>/service-ordre.tfvars og service-meny.tfvars.
#
# Bygd opp gjennom migreringen:
#   PR 1: storage account + Key Vault, flyttet fra data-stacken
#   PR 2: kjøremiljø (VM eller web app), flyttet fra app-stacken
#   PR 3 (denne): subnett + NSG, flyttet fra network-stacken. Ressursgruppe
#         og VNet bygges nå etter samme navnemønster som shared-network
#         bruker, i stedet for det lokale network-mønsteret.

data "azurerm_client_config" "current" {}

locals {
  # Samme navnemønster som shared-network-stacken bruker.
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"

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

module "subnet" {
  source = "../../modules/subnet"

  service             = var.tjeneste
  resource_group_name = local.resource_group_name
  location            = var.location
  vnet_name           = local.vnet_name
  prefix              = var.subnet_prefix
  delegate_web        = var.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}

module "vm" {
  source = "../../modules/vm"
  count  = var.runtime == "vm" ? 1 : 0

  service             = var.tjeneste
  resource_group_name = local.resource_group_name
  location            = var.location
  subnet_id           = module.subnet.subnet_id
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
  subnet_id           = module.subnet.subnet_id
  sku                 = var.webapp_sku
  tags                = local.tags
}
