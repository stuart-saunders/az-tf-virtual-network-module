terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.21.1"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">=2.2.0"
    }
  }
}

provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  features {}
}

provider "azapi" {
  subscription_id = var.subscription_id
  use_msi         = false
}
