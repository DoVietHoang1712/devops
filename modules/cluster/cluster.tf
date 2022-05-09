resource "azurerm_resource_group" "aks-getting-started" {
  name = "aks-getting-started"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-getting-started" {
  name                  = "aks-getting-started"
  location              = azurerm_resource_group.aks-getting-started.location
  resource_group_name   = azurerm_resource_group.aks-getting-started.name
  dns_prefix            = "aks-getting-started"            
  kubernetes_version    =  var.kubernetes_version
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_e4bds_v5"
    type       = "VirtualMachineScaleSets"
    os_disk_size_gb = 250
  }

  service_principal  {
    client_id = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
    network_policy = "calico"
  }

  azure_policy_enabled = false

  http_application_routing_enabled = false

}
