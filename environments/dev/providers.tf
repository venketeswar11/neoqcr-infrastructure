terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "Sentinel-Inference-server"

    # PUT YOUR AZURE STORAGE ACCOUNT NAME HERE
    storage_account_name = "sentinelv1"

    container_name = "tfstate"
    key            = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}