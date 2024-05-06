module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.base_cidr_block
  networks = [
    {
      name     = var.aks_subnet_name
      new_bits = 4 // 10.0.0.0/20
    },
    {
      name     = var.apg_subnet_name
      new_bits = 4 //"10.0.16.0/20"
    }
  ]
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.1.0"
  use_for_each        = true
  vnet_name           = "${terraform.workspace}_vnet"
  vnet_location       = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = [module.subnets.base_cidr_block]
  subnet_prefixes     = module.subnets.networks[*].cidr_block
  subnet_names        = module.subnets.networks[*].name

  # route_tables_ids = {
  #   "${var.aks_subnet_name}"    = azurerm_route_table.aks.id
  # }

  # nsg_ids = {
  #   "${var.aks_subnet_name}"  = azurerm_network_security_group.aks.id
  # }

  tags = local.tags

  depends_on = [azurerm_resource_group.default]
}

# resource "azurerm_network_security_group" "aks" {
#   name                = "${terraform.workspace}_aks_nsg"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.default.name

#   tags = local.tags
# }

# resource "azurerm_route_table" "aks" {
#   name                          = "${terraform.workspace}_aks_rt"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.default.name

#   tags = local.tags
# }