
resource "azurerm_network_security_group" "outils" {
  name                = "security-jenkins"
  location            = "${azurerm_resource_group.azure.location}"
  resource_group_name = "${azurerm_resource_group.azure.name}"
}

// resource "azurerm_network_security_group" "nexus" {
//   name                = "security-nexus"
//   location            = "${data.azurerm_resource_group.azure.location}"
//   resource_group_name = "${data.azurerm_resource_group.azure.name}"
// }


// resource "azurerm_network_security_group" "slave" {
//   name                = "security-slave"
//   location            = "${data.azurerm_resource_group.azure.location}"
//   resource_group_name = "${data.azurerm_resource_group.azure.name}"
// }

resource "azurerm_network_security_group" "apache" {
  name                = "security-apache"
  location            = "${azurerm_resource_group.azure.location}"
  resource_group_name = "${azurerm_resource_group.azure.name}"
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
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.outils.name}"
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
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.outils.name}"
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
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.outils.name}"
}


// resource "azurerm_network_security_rule" "nexus-ssh" {
//   name                        = "ssh-nexus"
//   priority                    = 100
//   direction                   = "inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "22"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = "${data.azurerm_resource_group.azure.name}"
//   network_security_group_name = "${azurerm_network_security_group.nexus.name}"
// }

resource "azurerm_network_security_rule" "nexus-in" {
  name                        = "port-nexus-in"
  priority                    = 103
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8081"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.outils.name}"
}

resource "azurerm_network_security_rule" "nexus-out" {
  name                        = "port-nexus-out"
  priority                    = 104
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8081"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.outils.name}"
}

// resource "azurerm_network_security_rule" "slave-ssh" {
//   name                        = "ssh-slave"
//   priority                    = 100
//   direction                   = "inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "22"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = "${data.azurerm_resource_group.azure.name}"
//   network_security_group_name = "${azurerm_network_security_group.slave.name}"
// }


resource "azurerm_network_security_rule" "apache-ssh" {
  name                        = "ssh-apache"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.apache.name}"
}

resource "azurerm_network_security_rule" "apache-in" {
  name                        = "port-apache-in"
  priority                    = 101
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.apache.name}"
}

resource "azurerm_network_security_rule" "apache-ssh-out" {
  name                        = "ssh-apache-out"
  priority                    = 102
  direction                   = "outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.azure.name}"
  network_security_group_name = "${azurerm_network_security_group.apache.name}"
}