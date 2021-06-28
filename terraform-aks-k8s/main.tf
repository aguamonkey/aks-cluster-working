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

resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.cluster_location
}

resource "azurerm_resource_group" "vnet" {
    name     = var.resource_group_name
    location = var.location
}

module "vnet" {
    source       = "./vnet"
    project_name = var.project_name
    group_name   = azurerm_resource_group.vnet.name
    location     = var.location
}

module "vm" {
    source        = "./vm"
    project_name  = var.project_name
    group_name    = azurerm_resource_group.vnet.name
    location      = var.location
    interface_ids = [module.vnet.interface_id]
}

module "aks-cluster" {
  source = "./k8s"
  project_name  = var.project_name
  group_name    = azurerm_resource_group.k8s.name
  cluster_location = var.cluster_location
  client_id = var.client_id
  client_secret = var.client_secret

}