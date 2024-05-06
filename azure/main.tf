terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.102.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }

  cloud {
    organization = "pakalucki"

    workspaces {
      name = "mendio_azure"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "default" {
  name     = "${terraform.workspace}_rg"
  location = var.location

  tags = local.tags
}