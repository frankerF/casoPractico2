terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.10.0"
    }
  }
  required_version = ">= 1.1.0"
}

# Configura el proveedor de Microsoft Azure
provider "azurerm" {
    features {} 
}   