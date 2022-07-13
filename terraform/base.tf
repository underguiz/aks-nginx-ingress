provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ingress-controller-demo" {
    name = var.ingress-controller-demo-rg
}