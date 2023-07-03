variable "location_name" {
    type = string
    description = "Región de azure donde se va a crear la infraestructura."
    default = "uksouth"  
}

variable "public_key" {
    type = string
    description = "Ruta donde estará la clave públic de acceso a las instancias."
    default = "~/.ssh/cp2.pub"  
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

