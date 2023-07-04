variable "location_name" {
    type = string
    description = "Región de azure donde se va a crear la infraestructura."
    default = "uksouth"  
}

variable "public_key" {
    type = string
    description = "Ruta donde estará la clave públic de acceso a las instancias."
    default = "~/.ssh/id_rsa.pub"  
}

variable "ssh_user" {
    type = string
    description = "Usuario para hacer ssh"
    default = "frankerFcp2"  
}

variable "resource_group_name" {
    type = string
    description = "Grupo de recursos asociados al caso práctico 2 creados con terraform."
    default = "fran-cp2-tf-rg"
}

variable "network_security_group_name" {
    type = string
    description = "Nombre del grupo de seguridad de la red"  
    default = "fran-cp2-tf-nsg"
}

variable "network_name" {
    type = string 
    description = "Nombre de la red virtual asociado a la máquina virtual"
    default = "fran-cp2-tf-vnet1"  
}

variable "subnet_name" {
    type = string
    description = "Nombre de la subred."
    default = "fran-cp2-tf-subnet1"      
}

variable "nic_name" {
    type = string
    description = "Nombre de la interfaz de red"
    default = "fran-cop2-tf-vnic"
}

variable "pip_name" {
    type = string
    description = "Nombre de la ip pública"  
    default = "fran-cp2-tf-pip"
}

variable "acr_name" {
    type = string
    description = "Nombre del container registry"
    default = "francp2tfacr"
}

# Especificaciones de la máquina virtual Standard_B1s
variable "espec_vm" {
    type = object({
        count = number
        basename = string
        size = string  
    })

    sensitive = true

    default = {
        count = 1
        basename = "fran-cp2-tf-vm"
        size = "Standard_B1s"        
    }  
}

# Especificaciones del sistema operativo de la máquina virtual.
variable "espec_osvm" {
    type = object({
        name = string
        product = string
        publisher = string
        offer = string
        sku = string
        version = string
    })

    default = {
        name = "8_5"
        product = "almalinux"
        publisher = "almalinux"
        offer = "almalinux"
        sku = "8_5"
        version = "8.5.20220311"
    }
}