

# Create network interface



resource "azurerm_network_interface" "main1" {
  count               = 3
  name                = "interface1${count.index}"
  location            = "${var.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
 
  ip_configuration {
    name                          = "${var.nom_configuration}"
    subnet_id                     = "${azurerm_subnet.vms1.id}"
    private_ip_address_allocation = "Dynamic"

    }
  tags {
    environment = "tech"
  }
}




resource "azurerm_network_security_rule" "jenkins-ssh" {
  name                        = "ssh-jenkins"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.jenkins.name}"
}

resource "azurerm_network_security_rule" "jenkins-in" {
  name                        = "port-jenkins-in"
  priority                    = 101
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.jenkins.name}"
}

resource "azurerm_network_security_rule" "jenkins-out" {
  name                        = "port-jenkins-out"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.jenkins.name}"
}


resource "azurerm_network_security_rule" "nexus-ssh" {
  name                        = "ssh-nexus"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nexus.name}"
}

resource "azurerm_network_security_rule" "nexus-in" {
  name                        = "port-nexus-in"
  priority                    = 101
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8081"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nexus.name}"
}

resource "azurerm_network_security_rule" "nexus-out" {
  name                        = "port-nexus-out"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8081"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nexus.name}"
}

resource "azurerm_network_security_rule" "slave-ssh" {
  name                        = "ssh-slave"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.slave.name}"
}




