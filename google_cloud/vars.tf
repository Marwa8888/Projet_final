variable "credentials" {
  default = "/home/adminl/terraformegoogle2/ProjetFinale-f908b6f5cb89.json"
}

variable "project" {
  default = "projetfinale-242610"
}


// ---------------------------------

variable "namegroupe" {
  default = "prod"
}

variable "descriptiongroupe" {
  default = "groupe test"
}

variable "zonegroupe" {
  default = "europe-west1-b"
}

// ------------------------------------


variable "namenetwork" {
  default = "networkprod"
}

variable "subnet1" {
  default = "subnet1"
}

variable "subnet2" {
  default = "subnet2"
}

variable "subnet3" {
  default = "subnet3"
}


variable "regionsubnet1" {
  default = "europe-west1"
}

variable "regionsubnet2" {
  default = "europe-west1"
}

variable "regionsubnet3" {
  default = "europe-west1"
}


// ----------------------------------------

variable "namevm1" {
  default = "mogodbtest"
}

variable "namevm2" {
  default = "mogodbprod"
}

variable "namevm3" {
  default = "client"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "zonevm" {
  default = "europe-west1-b"
}

variable "imagevm" {
  default = "centos-7"
}

variable "ssh_user" {
  default = "user02"
}

variable "ssh_pub_key_file" {
  default = "/home/adminl/.ssh/id_rsa.pub"
}

variable "clustername1" {
  default = "prod"
}

variable "clustername2" {
  default = "test"
}

variable "lactcluster" {
  default = "europe-west1-b"
}

variable "myNodePool" {
  default = "mynode"
}

variable "lactnode" {
  default = "europe-west1-b"
}





