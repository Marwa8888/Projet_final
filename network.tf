# Create virtual network
resource "azurerm_virtual_network" "vnet" {
 count               = 3
 name                = "${var.nom_reseau}${count.index}"
 address_space       = ["10.${count.index}.0.0/16"]
 location            = "${var.location}"
 resource_group_name = "${azurerm_resource_group.rg.name}"
  tags{
	    environment = "outils"
	}
}


# Create subnet
resource "azurerm_subnet" "vms" {
 count                =  2
 name                 = "${var.nom_sousreseau}${count.index}"
 resource_group_name  = "${azurerm_resource_group.rg.name}"
 virtual_network_name = "${element(azurerm_virtual_network.vnet.*.name, count.index)}"
 address_prefix       = "10.${count.index}.0.0/24"
}
