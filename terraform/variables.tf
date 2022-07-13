variable "ingress-controller-demo-rg" {
  type    = string
  default = "ingress-controller-demo"
}

output "keyvault_name" {
  value       = azurerm_key_vault.ingress-controller-keyvault.name
  description = "Key Vault Name"
}