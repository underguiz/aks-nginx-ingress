resource "azurerm_virtual_network" "ingress-controller-demo" {
  name                = "ingress-controller-demo"
  resource_group_name = data.azurerm_resource_group.ingress-controller-demo.name 
  location            = data.azurerm_resource_group.ingress-controller-demo.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "app" {
  name                 = "app"
  resource_group_name  = data.azurerm_resource_group.ingress-controller-demo.name 
  virtual_network_name = azurerm_virtual_network.ingress-controller-demo.name
  address_prefixes     = ["10.254.0.0/22"]
}