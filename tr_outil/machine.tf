
# data a resource group
data  "azurerm_resource_group" "rg" {
	name = "${var.nom_group}"

}
data "azurerm_virtual_network" "vnet" {
  name                = "${var.nom_reseau}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}


resource "azurerm_subnet" "vms1" {

  name                 = "${var.nom_sousreseau}-1"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}

#security groupe
resource "azurerm_network_security_group" "jenkins" {
  name                = "security-jenkins"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_group" "nexus" {
  name                = "security-nexus"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}


resource "azurerm_network_security_group" "slave" {
  name                = "security-slave"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}







# Create virtual machine
resource "azurerm_virtual_machine" "jenkins" {

  name                  = "Jenkins_master"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.main1.*.id, 1)}"]
  vm_size               = "${var.taille_machine}"
  storage_image_reference {

    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jenkins_disk"
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
      key_data = "${file("/home/user01/sshApache/id_rsa.pub")}"
    }
  }
}

resource "azurerm_virtual_machine" "nexus" {
  
  name                  = "nexus"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.main1.*.id, 2)}"]
  vm_size               = "${var.taille_machine}"
  storage_image_reference {

    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "nexus_disk"
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
     key_data = "${file("/home/user01/sshApache/id_rsa.pub")}"
     }
    
    }
  }

  resource "azurerm_virtual_machine" "slave" {
  
  name                  = "slave"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.main1.*.id, 3)}"]
  vm_size               = "${var.taille_machine}"
  storage_image_reference {

    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "slave_disk"
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
     key_data = "${file("/home/user01/sshApache/id_rsa.pub")}"
     }
    }
  }




