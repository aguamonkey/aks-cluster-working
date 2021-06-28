terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "aks-cluster" {
  source = "./k8s"
  client_id = var.client_id
  client_secret = var.client_secret

}