output "ip_address" {
    value = azurerm_public_ip.pip.ip_address
}

output "acr_admin_password" {
    value = azurerm_container_registry.acr.admin_password
    sensitive = true
}

output "conex_ssh" {
    value = "ssh -i ${var.public_key} ${var.ssh_user}@${azurerm_public_ip.pip.ip_address}"
}