output "storage_account_name" {
  description = "Navnet på storage account-en til denne tjenesten."
  value       = module.storage.name
}

output "key_vault_name" {
  description = "Navnet på Key Vault-et til denne tjenesten."
  value       = module.keyvault.name
}
