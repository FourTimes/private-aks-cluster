resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "${var.project}-kubernetes-cluster"
  location                = azurerm_resource_group.groupname.location
  resource_group_name     = azurerm_resource_group.groupname.name
  dns_prefix              = "${var.project}-kubernetes-cluster"
  private_cluster_enabled = true
  node_resource_group     = "${var.project}-node-resource-group"

  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    type                = "VirtualMachineScaleSets"
    min_count           = 1
    max_count           = 1
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 30
    max_pods            = 250
    vnet_subnet_id      = azurerm_subnet.subnet.id
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "demouser"
    ssh_key {
      key_data = var.ssh_key

    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "11.0.0.0/24"
    dns_service_ip     = "11.0.0.10"
  }

  role_based_access_control {
    enabled = false
    # azure_active_directory {
    #   admin_group_object_ids = ["50d62477-8d33-4d29-be61-b5a0ff380f5f"]
    #   azure_rbac_enabled     = true
    #   managed                = true
    # }
  }

  tags     =  var.additional_tags
}

