# Establecemos el grupo de recursos
resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location_name  
}

# Establecemos la red virtual para la 10.0
resource "azurerm_virtual_network" "vnet" {
    name = var.network_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]      
}

# Establecemos una subred virtual para la 10.0.2
resource "azurerm_subnet" "subnet" {
    name = var.subnet_name
    resouresource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.2.0/24" ]
}

# Definimos un interface de red
resource "azurerm_network_interface" "nic" {
    name = var.nic_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }  
}