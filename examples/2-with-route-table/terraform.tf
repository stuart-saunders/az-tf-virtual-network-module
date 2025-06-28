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
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  features {}
}

provider "azapi" {
  subscription_id = var.subscription_id
  use_msi         = false
}
