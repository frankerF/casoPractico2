output "ip_address" {
    value = "all:\n  hosts:\n    ${azurerm_public_ip.pip.ip_address}:"
}

output "acr_admin_password" {
    value = azurerm_container_registry.acr.admin_password
    sensitive = true
}

output "acr_podman_login" {
    value = "podman login ${azurerm_container_registry.acr.login_server} -u ${azurerm_container_registry.acr.admin_username} -p ${azurerm_container_registry.acr.admin_password}"
    sensitive = true
}

output "conex_ssh" {
    value = "ssh -i ${var.public_key} ${var.ssh_user}@${azurerm_public_ip.pip.ip_address}"
}
/*
output "aks_clicer" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
    sensitive = true  
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.k8s.kube_config_raw
    sensitive = true
}

output "kubeDir" {
    value = "all:\n\thosts:\n\t\t${azurerm_kubernetes_cluster.k8s.fqdn}:"
}
*/
output "ipaks" {
    value = azurerm_kubernetes_cluster.k8s.node_resource_group
}