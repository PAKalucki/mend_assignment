variable "location" {
  default = "westeurope"
}

variable "base_cidr_block" {
  default = "10.30.0.0/16"
}

variable "aks_subnet_name" {
  default     = "aks_system_subnet"
  description = "Subnet Name for AKS System pool"
}

variable "apg_subnet_name" {
  default     = "apg_subnet"
  description = "Subnet Name for Application Gateway"
}

variable "kubernetes_version" {
  default = "1.28.5"
}