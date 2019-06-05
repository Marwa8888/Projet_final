resource "azurerm_resource_group" "azure" {
  name     = "projetg"
  location = "${var.location}"
}


resource "azurerm_public_ip" "azureip" {
  name                = "ipapache"
  location            = "${azurerm_resource_group.azure.location}"
  resource_group_name = "${azurerm_resource_group.azure.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "vmapache"
}

resource "azurerm_virtual_network" "azurevn" {
  name                           = "vnet"
  address_space                  = ["10.0.0.0/16"]
  location                       = "${azurerm_resource_group.azure.location}"
  resource_group_name            = "${azurerm_resource_group.azure.name}"
}

resource "azurerm_subnet" "outilsubnet" {
  count                = 3
  name                 = "subnetoutils-${count.index}"
  resource_group_name  = "${azurerm_resource_group.azure.name}"
  virtual_network_name = "${azurerm_virtual_network.azurevn.name}"
  address_prefix       = "10.0.${count.index}.0/24"

}

resource "azurerm_subnet" "apachesubnet" {
  name                 = "subnet-apache"
  resource_group_name  = "${azurerm_resource_group.azure.name}"
  virtual_network_name = "${azurerm_virtual_network.azurevn.name}"
  address_prefix       = "10.0.4.0/24"
  network_security_group_id    = "${azurerm_network_security_group.apache.id}"
}

resource "azurerm_network_interface" "netinterface1" {
  count               = 3
  name                = "interface-${count.index}"
  location            = "${azurerm_resource_group.azure.location}"
  resource_group_name = "${azurerm_resource_group.azure.name}"
  network_security_group_id     = "${azurerm_network_security_group.outils.id}"

  ip_configuration {
    name                          = "techconfiguration"
    subnet_id                     = "${element(azurerm_subnet.outilsubnet.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "netinterface2" {
  name                = "interface-apache"
  location            = "${azurerm_resource_group.azure.location}"
  resource_group_name = "${azurerm_resource_group.azure.name}"
  // network_security_group_id     = "${azurerm_network_security_group.appssg.id}"

  ip_configuration {
    name                          = "techconfiguration"
    public_ip_address_id          = "${azurerm_public_ip.azureip.id}"
    subnet_id                     = "${azurerm_subnet.apachesubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vmoutils" {

  count                 = 3
  name                  = "vm-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.azure.name}"
  network_interface_ids = ["${element(azurerm_network_interface.netinterface1.*.id, count.index)}"]
  vm_size               = "${var.taille_machine}"
  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisktech-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.nom_machine}"
    admin_username = "${var.username}"

  }
  os_profile_linux_config {
    disable_password_authentication = true

     ssh_keys {
     path     = "/home/${var.username}/.ssh/authorized_keys"
     key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
     }
  }
}


resource "azurerm_virtual_machine" "vmapache" {

  name                  = "apache"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.azure.name}"
  network_interface_ids = ["${azurerm_network_interface.netinterface2.id}"]
  vm_size               = "${var.taille_machine}"
  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "apache_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.nom_machine}"
    admin_username = "${var.username}"

  }
  os_profile_linux_config {
    disable_password_authentication = true

     ssh_keys {
     path     = "/home/${var.username}/.ssh/authorized_keys"
     key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
     }
  }
}







// # Create a resource group
// resource "azurerm_resource_group" "rg" {
// 	name = "${var.nom_group}"
// 	location = "${var.location}"
// }

// # Create virtual network
// resource "azurerm_virtual_network" "vnet" {
//   name                = "vnet"
//   address_space       = ["10.0.0.0/16"]
//   location            = "${var.location}"
//   resource_group_name = "${azurerm_resource_group.rg.name}"
// }

// // # Create subnet
// // resource "azurerm_subnet" "vms" {
// //   count                = 2
// //   name                 = "${var.nom_sousreseau}${count.index}"
// //   resource_group_name  = "${azurerm_resource_group.rg.name}"
// //   virtual_network_name = "${azurerm_virtual_network.vnet.name}"
// //   address_prefix       = "10.${count.index}.0.0/24"
// // }

// # Create subnet
// resource "azurerm_subnet" "vms" {
//   name                 = "subnet-appach"
//   resource_group_name  = "${azurerm_resource_group.rg.name}"
//   virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//   address_prefix       = "10.1.0.0/24"
// }

// resource "azurerm_subnet" "vms1" {
//   name                 = "subnet-outils"
//   resource_group_name  = "${azurerm_resource_group.rg.name}"
//   virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//   address_prefix       = "10.2.0.0/24"
// }


// resource "azurerm_network_interface" "main1" {

//   name                = "interface1"
//   location            = "${var.location}"
//   resource_group_name = "${azurerm_resource_group.rg.name}"

//   ip_configuration {
//     name                          = "${var.nom_configuration}"
//     subnet_id                     = "${azurerm_subnet.vms1.id}"
//     private_ip_address_allocation = "dynamic"
//   }
// }

// resource "azurerm_network_interface" "main2" {

//   name                = "interface2"
//   location            = "${var.location}"
//   resource_group_name = "${azurerm_resource_group.rg.name}"

//   ip_configuration {
//     name                          = "${var.nom_configuration}"
//     subnet_id                     = "${azurerm_subnet.vms.id}"
//     private_ip_address_allocation = "dynamic"
//     public_ip_address_id = "${azurerm_public_ip.ip_public.id}"
//   }
// }

// // resource "azurerm_network_interface" "main" {

// //   name                = "interface1"
// //   location            = "${var.location}"
// //   resource_group_name = "${azurerm_resource_group.rg.name}"

// //   ip_configuration {
// //     name                          = "${var.nom_configuration}"
// //     subnet_id                     = "${element(azurerm_subnet.vms.*.id, 1)}"
// //     private_ip_address_allocation = "dynamic"
// //   }
// // }

// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }

// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }
// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }

// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }
// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }
// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }

// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }




// # Create public IPs
// resource "azurerm_public_ip" "ip_public" {

//   name                         = "myPublicIP"
//   location                     = "${var.location}"
//   resource_group_name          = "${azurerm_resource_group.rg.name}"
//   allocation_method            = "Dynamic"
//   domain_name_label            = "vmapache"
// }




// resource "azurerm_network_security_rule" "apache-ssh" {
//   name                        = "ssh-apache"
//   priority                    = 100
//   direction                   = "inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "22"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = "${azurerm_resource_group.rg.name}"
//   network_security_group_name = "${azurerm_network_security_group.apache.name}"
// }

// resource "azurerm_network_security_rule" "apache-in" {
//   name                        = "port-apache-in"
//   priority                    = 101
//   direction                   = "inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "80"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = "${azurerm_resource_group.rg.name}"
//   network_security_group_name = "${azurerm_network_security_group.apache.name}"
// }

// resource "azurerm_virtual_machine" "vm1" {

//   name                  = "jenkins"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main1.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }

// resource "azurerm_virtual_machine" "vm2" {

//   name                  = "apache"
//   location              = "${var.location}"
//   resource_group_name   = "${azurerm_resource_group.rg.name}"
//   network_interface_ids = ["${azurerm_network_interface.main2.id}"]
//   vm_size               = "${var.taille_machine}"
//   storage_image_reference {
//     publisher = "OpenLogic"
//     offer     = "CentOS"
//     sku       = "7.5"
//     version   = "latest"
//   }

//   storage_os_disk {
//     name              = "apache_disk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Standard_LRS"
//   }
//   os_profile {
//     computer_name  = "${var.nom_machine}"
//     admin_username = "${var.username}"

//   }
//   os_profile_linux_config {
//     disable_password_authentication = true

//      ssh_keys {
//      path     = "/home/${var.username}/.ssh/authorized_keys"
//      key_data = "${file("/home/user01/.ssh/id_rsa.pub")}"
//      }
//   }
// }
