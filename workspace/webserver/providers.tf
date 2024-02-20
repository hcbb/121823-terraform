terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

#provider "acme" {
#  server_url = "https://acme-v02.api.letsencrypt.org/directory"
#}