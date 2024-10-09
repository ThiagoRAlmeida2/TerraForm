terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Grupo de recursos
resource "azurerm_resource_group" "k1ng45" {
  name     = "k1ng45"
  location = "Brazil South"
}

# Rede virtual
resource "azurerm_virtual_network" "k1ng45-vnet" {
  name                = "k1ng45-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.k1ng45.location
  resource_group_name = azurerm_resource_group.k1ng45.name
}

# Sub-rede
resource "azurerm_subnet" "k1ng45-subnet" {
  name                 = "k1ng45-subnet"
  resource_group_name  = azurerm_resource_group.k1ng45.name
  virtual_network_name = azurerm_virtual_network.k1ng45-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Interface de rede
resource "azurerm_network_interface" "interface-de-rede" {
  name                = "interface-de-rede"
  location            = azurerm_resource_group.k1ng45.location
  resource_group_name = azurerm_resource_group.k1ng45.name

  ip_configuration {
    name                          = "ip-config-k1ng45"
    subnet_id                     = azurerm_subnet.k1ng45-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Máquina Virtual Debian 12 "Bookworm" - Gen2
resource "azurerm_linux_virtual_machine" "k1ng45" {
  name                = "K1ng45"
  resource_group_name = azurerm_resource_group.k1ng45.name
  location            = azurerm_resource_group.k1ng45.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.interface-de-rede.id]

  disable_password_authentication = true  # Desabilitar autenticação por senha

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/thiago/.ssh/id_rsa.pub")  # Caminho da chave SSH pública
  }

  os_disk {
    name                 = "k1ng45-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }
}

# Saída com o IP da máquina
output "public_ip" {
  value = azurerm_network_interface.interface-de-rede.private_ip_address
} 
