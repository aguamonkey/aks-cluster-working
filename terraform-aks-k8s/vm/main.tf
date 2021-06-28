resource "azurerm_public_ip" "firstIP" {
  name                = "DemoIP"
  resource_group_name = var.group_name
  location            = var.location
  allocation_method   = "Dynamic"
}



resource "azurerm_linux_virtual_machine" "main" {
    name                  = "${var.project_name}-vm"
    resource_group_name   = var.group_name
    location              = var.location
    size                  = var.vm_size
    network_interface_ids = var.interface_ids

    admin_username = "adminuser"
    admin_password = "LetMeIn!"

    disable_password_authentication = false

    admin_ssh_key {
        username   = "adminuser"
        public_key = file(var.ssh_public_key)
    }
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = var.storage_size
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }    
}


