terraform {
  required_version = ">= 1.11.0"

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
