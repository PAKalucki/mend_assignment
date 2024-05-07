terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }
    tfe = {
      version = "0.54.0"
    }
  }

  cloud {
    organization = "pakalucki"

    workspaces {
      name = "mendio_k8s"
    }
  }
}

provider "tfe" {
  organization = "pakalucki"
}

provider "helm" {
  alias = "aws"

  kubernetes {
    host                   = data.tfe_outputs.aws.values.cluster_endpoint
    cluster_ca_certificate = base64decode(data.tfe_outputs.aws.values.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.aws.values.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  alias = "aws"
  
  host                   = data.tfe_outputs.aws.values.cluster_endpoint
  cluster_ca_certificate = base64decode(data.tfe_outputs.aws.values.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.aws.values.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  alias = "azure"

  kubernetes {
    host                   = data.tfe_outputs.azure.values.aks_host
    username               = data.tfe_outputs.azure.values.aks_username
    password               = data.tfe_outputs.azure.values.aks_password
    client_certificate     = data.tfe_outputs.azure.values.aks_client_certificate
    client_key             = data.tfe_outputs.azure.values.aks_client_key
    cluster_ca_certificate = data.tfe_outputs.azure.values.aks_cluster_ca_certificate
  }
}

provider "kubernetes" {
  alias = "azure"

  host                   = data.tfe_outputs.azure.values.aks_host
  username               = data.tfe_outputs.azure.values.aks_username
  password               = data.tfe_outputs.azure.values.aks_password
  client_certificate     = data.tfe_outputs.azure.values.aks_client_certificate
  client_key             = data.tfe_outputs.azure.values.aks_client_key
  cluster_ca_certificate = data.tfe_outputs.azure.values.aks_cluster_ca_certificate
}


data "tfe_outputs" "aws" {
  workspace = "mendio_aws"
}

data "tfe_outputs" "azure" {
  workspace = "mendio_azure"
}