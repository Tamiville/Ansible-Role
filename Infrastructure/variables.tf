variable "elite_general_network" {
  type    = string
  default = "elitegeneralnetwork"
}

variable "location" {
  type    = string
  default = "CENTRALUS"
}

variable "elite_devnsg" {
  type    = string
  default = "elite_devnsg"
}

variable "elitedev_vnet" {
  type    = string
  default = "elitedev_vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "elite_rtb" {
  type    = string
  default = "elite_rtb"
}

variable "application_subnet" {
  type    = string
  default = "application_subnet"
}


variable "address_prefixes_application" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "source_address_prefix" {
  type    = string
  default = "84.232.140.99/32"
}

variable "destination_address_prefix" {
  type    = string
  default = "VirtualNetwork"
}

variable "path_privatekey" {
  type    = string
  default = "/home/devopslab/.ssh/ansiblekey3"
}

variable "user" {
  type    = string
  default = "adminuser"
}