resource "azurerm_resource_group" "elite_general_network" {
  name     = var.elite_general_network
  location = var.location
}

resource "azurerm_network_security_group" "elite_devnsg" {
  name                = var.elite_devnsg
  location            = azurerm_resource_group.elite_general_network.location
  resource_group_name = azurerm_resource_group.elite_general_network.name
}

resource "azurerm_virtual_network" "elitedev_vnet" {
  name                = var.elitedev_vnet
  location            = azurerm_resource_group.elite_general_network.location
  resource_group_name = azurerm_resource_group.elite_general_network.name
  address_space       = var.address_space

  tags = local.common_tags
}

resource "azurerm_route" "route" {
  name                = "route1"
  resource_group_name = azurerm_resource_group.elite_general_network.name
  route_table_name    = azurerm_route_table.elite_rtb.name
  address_prefix      = "10.0.0.0/16"
  next_hop_type       = "VnetLocal"
}

resource "azurerm_route_table" "elite_rtb" {
  name                = var.elite_rtb
  location            = azurerm_resource_group.elite_general_network.location
  resource_group_name = azurerm_resource_group.elite_general_network.name
}

resource "azurerm_subnet" "application_subnet" {
  name                 = var.application_subnet
  resource_group_name  = azurerm_resource_group.elite_general_network.name
  virtual_network_name = azurerm_virtual_network.elitedev_vnet.name
  address_prefixes     = var.address_prefixes_application
}

resource "azurerm_subnet_route_table_association" "elitedev_rtb_assoc_application" {
  subnet_id      = azurerm_subnet.application_subnet.id
  route_table_id = azurerm_route_table.elite_rtb.id
}

resource "azurerm_subnet_network_security_group_association" "elite_devnsg_assoc_application_subnet" {
  subnet_id                 = azurerm_subnet.application_subnet.id
  network_security_group_id = azurerm_network_security_group.elite_devnsg.id
}