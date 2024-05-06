output "aks_credentials" {
  value = "AKS CREDENTIALS: az aks get-credentials --resource-group ${azurerm_resource_group.default.name} --name ${azurerm_kubernetes_cluster.this.name} --admin"
}