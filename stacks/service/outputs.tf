output "storage_account_name" {
  description = "Navnet på storage account-en til denne tjenesten."
  value       = module.storage.name
}

output "key_vault_name" {
  description = "Navnet på Key Vault-et til denne tjenesten."
  value       = module.keyvault.name
}

output "vm_public_ip" {
  description = "Offentlig IP, kun satt når runtime er vm."
  value       = var.runtime == "vm" ? module.vm[0].public_ip : null
}

output "webapp_hostname" {
  description = "Adresse til appen, kun satt når runtime er webapp."
  value       = var.runtime == "webapp" ? module.webapp[0].hostname : null
}
