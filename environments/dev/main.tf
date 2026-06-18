data "azurerm_resource_group" "rg" {
  name = var.existing_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.existing_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "AppGwSubnet-Dev"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

module "application_gateway" {
  source = "../../modules/application_gateway"

  environment           = var.environment
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  app_gateway_subnet_id = azurerm_subnet.appgw_subnet.id
  private_frontend_ip   = var.private_frontend_ip
  backend_ip_address    = var.backend_ip_address
  trusted_ips           = var.trusted_ips
}