resource "random_string" "k_l_ran" {
  length           = 6
  special          = false
  override_special = "/@£$"
}

resource "azurerm_resource_group" "example" {
  name     = "k_l-${random_string.k_l_ran.result}"
  location = var.k_l_loc
  depends_on = [ random_string.k_l_ran ]
}

resource "azurerm_kubernetes_cluster" "k_l_aks" {
  name                = "aks-${random_string.k_l_ran.result}"
  location            = var.k_l_loc
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "dns-${random_string.k_l_ran.result}"
  kubernetes_version  = "1.30.9"

  default_node_pool {
    name            = "testnodepool"
    node_count      = 2
    vm_size         = "Standard_D2as_v5"
    os_disk_size_gb = 30
  }
 identity {
    type = "SystemAssigned"
  }
  role_based_access_control_enabled = true

  tags = {
    environment = "test"
  }
}