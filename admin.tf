resource "openstack_compute_instance_v2" "admin" {
  name            = "admin"
  image_name      = var.instance_image
  flavor_name     = var.instance_flavor
  key_pair        = var.ssh_key_name
  user_data       = file("userdata.yml")
  security_groups = ["default"]

  metadata = {
    role = "admin"
  }

  network {
    name = var.public_network
  }

  network {
    name        = openstack_networking_network_v2.private_network.name
    fixed_ip_v4 = cidrhost(openstack_networking_subnet_v2.admin.cidr, 10)
  }

  connection {
    # No need to define a password of private key. It will default to
    # default local ssh-key
    type = "ssh"
    user = var.ssh_remote_user
    host = self.access_ip_v4
  }
  provisioner "remote-exec" {
    inline = [
      # Sending stdout to /dev/null otherwise it will flood output
      "cloud-init status --wait > /dev/null"
    ]
  }
}

output "admin" {
  value = openstack_compute_instance_v2.admin.network[0].fixed_ip_v4
}
