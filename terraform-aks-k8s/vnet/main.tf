resource "azurerm_virtual_network" "main" {
    name                = "${var.project_name}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = var.group_name
}

resource "azurerm_subnet" "main" {
    name                 = "internal"
    resource_group_name  = var.group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "internal_subnet"
  location            = var.location
  resource_group_name = var.group_name

  security_rule {
    name                       = "publicSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}



resource "azurerm_network_interface" "main" {
    name                = "${var.project_name}-nic"
    location            = var.location
    resource_group_name = var.group_name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.main.id
        private_ip_address_allocation = "Dynamic"
    }
}