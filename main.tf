provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my_rg" {
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-vnet"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "my_nsg" {
  name                = "my-nsg"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_rg.name
  network_security_group_name = azurerm_network_security_group.my_nsg.name
}

resource "azurerm_public_ip" "my_public_ip" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "my_nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "my-nic-config"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "my_vm" {
  name                  = "my-vm"
  location              = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.my_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjk0vrPUQ+v0kBbp2455HiSH2Hq6/3oLlInYBpYzfogu7Owncck333o8b28XIp4kM0KWHd1/y8E7jp0M7pukCSYAnq6/xeKN/qmKvSoAidq11jaZVZbrB2w/qUM+MbCL6lT+j6VK+nc0uGtp+5xuZPNlzZggmnfcrzG53BfrgcubsFMxB4q8ARWPDaTXZ0w0V2NWaw9GTkhzxi7nF1CQN343gl33n+uZwfD0qRds1A6XJSFfvIFWJqKyPd0oxBOl0KUGt8D9AvK5BddmNTQEqCt6zYymyxSh+C6WZkNCNhuEs9iRERp51WYRL5XyPR127wdJPRWG6VACZsCLs3MYpp/a1wFzEhb/cwcl1cPDQF4UqtLPH+TE//6rUR/bnE4uXu39cPTHmCF7sXnVSNv/rOMupp4m/j6i0V0o8qlCKSDbJUVwsxSHgDmA+LEHsxG8qulU+BO09fHjOOmaCCMILglzy0tFM31ZsTqLrubho6yl6kDrXQwZ7tSW1ntTfdKkVC4X6dpBjegiy5q3oI092DafukF5Q2davkctk2Tq/wgiAvbFHk+7MSd+6JUczBU0e/3p6AUC3xW0hcomBIPqLs+URaKnE3XQOf0L+wxta+nqWF9PPljig0wfReMBpJyrhs5Dj8GHnHyV2BvF4gZN9WvnPutxKdZFSz9y5rlJlIYQ== umesh@DESKTOP-MSD6398"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(file("${path.module}/install-docker.sh"))
}

output "public_ip" {
  value = azurerm_public_ip.ip_address
}
