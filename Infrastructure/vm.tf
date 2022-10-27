resource "azurerm_resource_group" "elite_general_resources" {
  name     = local.elite_general_resources
  location = var.location
}

resource "azurerm_network_interface" "labnic" {
  name                = join("-", [local.server, "lab", "nic"])
  location            = local.buildregion
  resource_group_name = azurerm_resource_group.elite_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.labpip.id
  }
}

resource "azurerm_public_ip" "labpip" {
  name                = join("-", [local.server, "lab", "pip"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  allocation_method   = "Static"

  tags = local.common_tags
}


resource "azurerm_linux_virtual_machine" "Linuxvm" {
  name                = join("-", [local.server, "linux", "vm"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.labnic.id,
  ]

  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.path_privatekey)
    host        = self.public_ip_address
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCo9MerUNlZYOphSzo+foXab5KDVh3Z2L/uZGYUYDfCKne37Y/xBjO/cCAOzvmw96mLw+vvKjdvE5FUg38bIB8Vy6Ioo4n1P4QCBV2RZbF4A60BAsUxrYoWpKROtEAPgbhTB6hBQ8j5Et9ZZoUraQCqB5Doif+jbJ+caP3LORWNn2y+QC6qzIw36LqjwXhj2+WFEpsf5lDz+fhMKHmVSocPp1R0x0gQFTCrwr2tqwcrDm+fgT3hRPTDwn59cMi9ZiTlI9KxbPId+QINYB48uh0pATlMWOShHZSArqc+a0qaXSZSVBxDCZZFof4gZABh2sD6TyWaMi+7fs5uRPU6lDePofh9AUWv/Fkmu3aMPT37fhPJl8sy/nLcTRKMnFse/gEnPhMmyEIbU0atCUUfH9GMrfDTLtE8QwEqVnmLRbVcmTAkznK/FHWygKVmj5OuHxXYJODw4mdWvSp96RYoLRraCa+RAZ4wrrqahj/rAKzespzl+ECYL8ojUXCrW7OUGKc= apple@Tamie-Emmanuel"
  }
  # provisioner "file" {
  #   source      = "./scripts/keyrevive.sh"
  #   destination = "/tmp/keyrevive.sh"
  # }
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.user} -i '${self.public_ip_address},' --private-key ${var.path_privatekey} ansibleplaybooks/nginx.yml -vv"
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}