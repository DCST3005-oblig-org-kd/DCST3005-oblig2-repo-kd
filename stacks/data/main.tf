# Datalaget for ALLE tjenestene. Storage account og Key Vault er flyttet til
# service-stacken (migrerings-PR 1). Disse removed-blokkene slipper dem ut av
# denne staten uten å røre dem i Azure -- se import-fra-data.tf i
# stacks/service/.
#
# FJERNES når K8-opprydding er gjort i begge miljøer.

removed {
  from = module.storage

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.keyvault

  lifecycle {
    destroy = false
  }
}
