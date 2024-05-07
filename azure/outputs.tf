output "aks_credentials" {
  value = "AKS CREDENTIALS: az aks get-credentials --resource-group ${azurerm_resource_group.default.name} --name ${azurerm_kubernetes_cluster.this.name} --admin"
}

output "aks_host" {
  value = azurerm_kubernetes_cluster.this.kube_admin_config.0.host
  sensitive = true
}

output "aks_username" {
  value = azurerm_kubernetes_cluster.this.kube_admin_config.0.username
  sensitive = true
}

output "aks_password" {
  value = azurerm_kubernetes_cluster.this.kube_admin_config.0.password
  sensitive = true
}

output "aks_client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate)
  sensitive = true
}

output "aks_client_key" {
  value = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key)
  sensitive = true
}

output "aks_cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate)
  sensitive = true
}

output "ingress_application_gateway" {
  value = azurerm_kubernetes_cluster.this.ingress_application_gateway
}