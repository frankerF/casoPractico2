resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location_name  
}

resource "azurerm_virtual_network" "vnet" {
    name = var.network_name
    resource_group_name = var.resource_group_name
    location = var.location_name
    address_space = ["10.0.0.0/16"]      
}

