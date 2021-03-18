# lookup SSH public keys by name
data "ibm_is_ssh_key" "ssh_pub_key" {
  name = var.ssh_key_name
}

# lookup compute profile by name
data "ibm_is_instance_profile" "instance_profile" {
  name = var.instance_profile
}

# lookup image name for a custom image in region if we need it
data "ibm_is_image" "ubuntu" {
  name = "ibm-ubuntu-20-04-minimal-amd64-2"
}

data "template_file" "user_data_server_01" {
  template = file("${path.module}/user_data_server_01.yaml")
  vars = {
    ca_cert_chain       = indent(4, var.ca_cert_chain)
    server_01_cert      = indent(4, var.server_01_cert)
    server_01_key       = indent(4, var.server_01_key)
    client_cert         = indent(4, var.client_cert)
    client_key          = indent(4, var.client_key)
    cluster_encrypt_key = var.cluster_encrypt_key
  }
}

# create server 01
resource "ibm_is_instance" "server_01_instance" {
  name           = "f5-consul-server-01-${random_uuid.namer.result}"
  resource_group = data.ibm_resource_group.group.id
  image          = data.ibm_is_image.ubuntu.id
  profile        = data.ibm_is_instance_profile.instance_profile.id
  primary_network_interface {
    name            = "internal"
    subnet          = data.ibm_is_subnet.internal_subnet.id
    security_groups = [ibm_is_security_group.consul_open_sg.id]
  }
  vpc        = data.ibm_is_subnet.internal_subnet.vpc
  zone       = data.ibm_is_subnet.internal_subnet.zone
  keys       = [data.ibm_is_ssh_key.ssh_pub_key.id]
  user_data  = data.template_file.user_data_server_01.rendered
  depends_on = [ibm_is_security_group_rule.consul_allow_outbound]
  timeouts {
    create = "60m"
    delete = "120m"
  }
}

resource "ibm_is_floating_ip" "server_01_floating_ip" {
  name           = "fip-f5-consul-server-01-${random_uuid.namer.result}"
  resource_group = data.ibm_resource_group.group.id
  target         = ibm_is_instance.server_01_instance.primary_network_interface.0.id
}


data "template_file" "user_data_server_02" {
  template = file("${path.module}/user_data_server_02.yaml")
  vars = {
    ca_cert_chain       = indent(4, var.ca_cert_chain)
    server_02_cert      = indent(4, var.server_02_cert)
    server_02_key       = indent(4, var.server_02_key)
    client_cert         = indent(4, var.client_cert)
    client_key          = indent(4, var.client_key)
    cluster_encrypt_key = var.cluster_encrypt_key
    server_1_ip_address = ibm_is_instance.server_01_instance.primary_network_interface.0.primary_ipv4_address
  }
}

# create server 02
resource "ibm_is_instance" "server_02_instance" {
  name           = "f5-consul-server-02-${random_uuid.namer.result}"
  resource_group = data.ibm_resource_group.group.id
  image          = data.ibm_is_image.ubuntu.id
  profile        = data.ibm_is_instance_profile.instance_profile.id
  primary_network_interface {
    name            = "internal"
    subnet          = data.ibm_is_subnet.internal_subnet.id
    security_groups = [ibm_is_security_group.consul_open_sg.id]
  }
  vpc        = data.ibm_is_subnet.internal_subnet.vpc
  zone       = data.ibm_is_subnet.internal_subnet.zone
  keys       = [data.ibm_is_ssh_key.ssh_pub_key.id]
  user_data  = data.template_file.user_data_server_02.rendered
  depends_on = [ibm_is_security_group_rule.consul_allow_outbound]
  timeouts {
    create = "60m"
    delete = "120m"
  }
}

data "template_file" "user_data_server_03" {
  template = file("${path.module}/user_data_server_03.yaml")
  vars = {
    ca_cert_chain       = indent(4, var.ca_cert_chain)
    server_03_cert      = indent(4, var.server_03_cert)
    server_03_key       = indent(4, var.server_03_key)
    client_cert         = indent(4, var.client_cert)
    client_key          = indent(4, var.client_key)
    cluster_encrypt_key = var.cluster_encrypt_key
    server_1_ip_address = ibm_is_instance.server_01_instance.primary_network_interface.0.primary_ipv4_address
    server_2_ip_address = ibm_is_instance.server_02_instance.primary_network_interface.0.primary_ipv4_address
  }
}

# create server 03
resource "ibm_is_instance" "server_03_instance" {
  name           = "f5-consul-server-03-${random_uuid.namer.result}"
  resource_group = data.ibm_resource_group.group.id
  image          = data.ibm_is_image.ubuntu.id
  profile        = data.ibm_is_instance_profile.instance_profile.id
  primary_network_interface {
    name            = "internal"
    subnet          = data.ibm_is_subnet.internal_subnet.id
    security_groups = [ibm_is_security_group.consul_open_sg.id]
  }
  vpc        = data.ibm_is_subnet.internal_subnet.vpc
  zone       = data.ibm_is_subnet.internal_subnet.zone
  keys       = [data.ibm_is_ssh_key.ssh_pub_key.id]
  user_data  = data.template_file.user_data_server_03.rendered
  depends_on = [ibm_is_security_group_rule.consul_allow_outbound]
  timeouts {
    create = "60m"
    delete = "120m"
  }
}
