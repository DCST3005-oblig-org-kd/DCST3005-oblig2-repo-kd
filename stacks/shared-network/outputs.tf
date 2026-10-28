output "resource_group_name" {
  description = "Ressursgruppa alle stackene bruker."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Regionen alt står i."
  value       = azurerm_resource_group.this.location
}

output "vnet_name" {
  description = "Navnet på VNet-et."
  value       = module.vnet.name
}
