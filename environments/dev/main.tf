# 1. Reference the EXISTING Resource Group
data "azurerm_resource_group" "rg" {
  name = var.existing_resource_group_name
}

# 2. Reference the EXISTING Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = var.existing_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# 3. CREATE the AppGatewaySubnet
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# 4. Call the Application Gateway Module
module "application_gateway" {
  source = "../../modules/application_gateway"

  environment         = var.environment
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  # Pass the ID of the newly created subnet!
  app_gateway_subnet_id = azurerm_subnet.appgw_subnet.id

  private_frontend_ip = var.private_frontend_ip
  backend_ip_address  = var.backend_ip_address
  trusted_ips         = var.trusted_ips
}