resource "random_string" "ingress-controller-keyvault" {
  length           = 5
  special          = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "ingress-controller-keyvault" {
  name                = "ingress-controller-${random_string.ingress-controller-keyvault.result}"
  resource_group_name = data.azurerm_resource_group.ingress-controller-demo.name
  location            = data.azurerm_resource_group.ingress-controller-demo.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Get",
      "Create",
      "Import",
      "List",
      "Delete",
      "Purge"
    ]

  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_kubernetes_cluster.ingress-controller-demo.key_vault_secrets_provider.0.secret_identity.0.object_id

    certificate_permissions = [
      "Get",
      "Create",
      "Import",
      "List",
      "Delete"
    ]

    secret_permissions = [ 
      "Get",
      "List"
    ]

  }

}