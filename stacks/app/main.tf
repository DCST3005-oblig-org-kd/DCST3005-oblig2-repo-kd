# Applaget for ALLE tjenestene. VM/NIC/IP og App Service-plan/web app er
# flyttet til service-stacken (migrerings-PR 2). Disse removed-blokkene
# slipper dem ut av denne staten uten å røre dem i Azure -- se
# import-fra-app.tf i stacks/service/.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.

removed {
  from = module.vm

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.webapp

  lifecycle {
    destroy = false
  }
}
