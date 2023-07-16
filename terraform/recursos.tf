# Establecemos el grupo de recursos del que estará colgado todo
resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location_name  
}

# Establecemos un container registry sobre el grupo de recursos
resource "azurerm_container_registry" "acr" {
    name = var.acr_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = "Standard"
    admin_enabled = true      
}

# Establecemos la red virtual para la sección de red 10.0
resource "azurerm_virtual_network" "vnet" {
    name = var.network_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]      
}

# Establecemos una subred virtual para la sección de red 10.0.2
resource "azurerm_subnet" "subnet" {
    name = var.subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.2.0/24" ]
}

# Definimos que tenga una IP pública estática
resource "azurerm_public_ip" "pip" {
    name = var.pip_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

# Definimos un grupo de seguridad para crear una regla de acceso a la máquina por ssh
resource "azurerm_network_security_group" "netsg" {
    name = var.network_security_group_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "https"
        priority = 1011
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "8080"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
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
        public_ip_address_id = azurerm_public_ip.pip.id
    }  
}

# Relaccionamos la interface de red con el grupo de seguridad
resource "azurerm_network_interface_security_group_association" "nisga" {
    network_interface_id = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.netsg.id  
}

# Definimos la máquina virtual de linux
resource "azurerm_linux_virtual_machine" "lvm" {
    name = var.espec_vm.basename
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = var.espec_vm.size
    admin_username = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.nic.id ]

    admin_ssh_key {
        username = var.ssh_user
        public_key = file("${var.public_key}")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    
    plan {
        name = var.espec_osvm.name
        product = var.espec_osvm.product
        publisher = var.espec_osvm.publisher
    }

    source_image_reference {
        publisher = var.espec_osvm.publisher
        offer = var.espec_osvm.offer
        sku = var.espec_osvm.sku
        version = var.espec_osvm.version
    }
}


# Definimos un cluster de kubernetes:
resource "azurerm_kubernetes_cluster" "k8s" {
    name = var.k8s_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix = "francp2"

    default_node_pool {
        name = "francp2defnp"
        node_count = 1
        vm_size = "Standard_D2_v2"
    }   

    identity {
        type = "SystemAssigned"
    }

    tags = {
        Environment = "CasoPractico2k8s"
    }
}

/*resource "azurerm_role_assignment" "roleas" {
    principal_id =  azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
    role_definition_name = "francp2tfrdn"
    scope = azurerm_container_registry.acr.id
    skip_service_principal_aad_check = true
}

*/