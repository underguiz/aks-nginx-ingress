resource "azurerm_kubernetes_cluster" "ingress-controller-demo" {
  name                = "ingress-controller-demo"
  dns_prefix          = "ingress-controller-demo"
  resource_group_name = data.azurerm_resource_group.ingress-controller-demo.name 
  location            = data.azurerm_resource_group.ingress-controller-demo.location

  role_based_access_control_enabled = true

  default_node_pool {
    name                = "app"
    vm_size             = "Standard_D4as_v4"
    enable_auto_scaling = false
    node_count          = 3
    vnet_subnet_id      = azurerm_subnet.app.id
  }

  network_profile {
    network_plugin     = "kubenet"
    pod_cidr           = "172.16.0.0/16"
    service_cidr       = "172.29.100.0/24"
    dns_service_ip     = "172.29.100.10"
    docker_bridge_cidr = "172.29.101.0/24"  
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "ingress-node-pool" {
  name                  = "ingress"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.ingress-controller-demo.id
  vm_size               = "Standard_D4as_v4"
  node_taints           = [ "workload-type=ingress:NoSchedule" ]
  vnet_subnet_id        = azurerm_subnet.app.id
  node_count            = 3
  enable_auto_scaling   = false
}

resource "azurerm_role_assignment" "aks-subnet" {
  scope                = azurerm_virtual_network.ingress-controller-demo.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.ingress-controller-demo.identity.0.principal_id
}