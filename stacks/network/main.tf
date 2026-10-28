# Nettverkslaget for ALLE tjenestene. Ressursgruppa og VNet-et er flyttet til
# shared-network, og subnett+NSG+regel+assosiasjon er flyttet til
# service-stacken (migrerings-PR 3). Disse removed-blokkene slipper dem ut av
# denne staten uten å røre dem i Azure.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.

removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.vnet

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.subnet

  lifecycle {
    destroy = false
  }
}
