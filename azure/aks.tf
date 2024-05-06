resource "azurerm_kubernetes_cluster" "this" {
  name                          = "${terraform.workspace}_cluster"
  kubernetes_version            = var.kubernetes_version
  location                      = azurerm_resource_group.default.location
  resource_group_name           = azurerm_resource_group.default.name
  sku_tier                      = "Free"
  dns_prefix                    = "pakalucki"
  private_cluster_enabled       = false
  public_network_access_enabled = true

  api_server_access_profile {
    authorized_ip_ranges = ["178.183.197.252/32"]
  }

  default_node_pool {
    orchestrator_version = var.kubernetes_version
    name                 = "systempool"
    vm_size              = "Standard_DS1_v2"
    os_disk_type         = "Ephemeral"
    vnet_subnet_id       = lookup(module.vnet.vnet_subnets_name_id, var.aks_subnet_name)
    enable_auto_scaling  = true
    max_count            = 1
    min_count            = 1
    tags                 = local.tags
  }

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_name = "${terraform.workspace}_aks_apg"
    subnet_id    = lookup(module.vnet.vnet_subnets_name_id, var.apg_subnet_name)
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [data.azuread_client_config.current.object_id]
    azure_rbac_enabled     = true
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    outbound_type  = "managedNATGateway"
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "network_contributor" {
  principal_id                     = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].client_id
  role_definition_name             = "Network Contributor"
  scope                            = lookup(module.vnet.vnet_subnets_name_id, var.apg_subnet_name)
  skip_service_principal_aad_check = true
}