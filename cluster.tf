provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "existing" {
  name = "CST8918-IAC"
}

resource "azurerm_kubernetes_cluster" "block1" {
  name                = "meetcluster"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  dns_prefix          = "canadacentral-cluster"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B2s"
    orchestrator_version = "latest"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.block1.kube_config_raw
  sensitive = true
}
