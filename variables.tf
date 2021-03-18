##################################################################################
# version - Terraform version required
##################################################################################
variable "TF_VERSION" {
  default     = "0.13"
  description = "terraform version required for schematics"
}

##################################################################################
# region - The VPC region to instatiate the F5 BIG-IP instance
##################################################################################
variable "region" {
  type        = string
  default     = "us-south"
  description = "The VPC region to instatiate the F5 BIG-IP instance"
}

##################################################################################
# resource_group - The IBM Cloud resource group to create the F5 BIG-IP instance
##################################################################################
variable "resource_group" {
  type        = string
  default     = "default"
  description = "The IBM Cloud resource group to create the F5 BIG-IP instance"
}

##################################################################################
# instance_profile - The name of the VPC profile to use for the Consul instnace
##################################################################################
variable "instance_profile" {
  type        = string
  default     = "cx2-4x8"
  description = "The resource profile to be used when provisioning the Consul instance"
}

##################################################################################
# ssh_key_name - The name of the public SSH key (VPC Gen 2 SSH Key) to be used for the ubuntu account
##################################################################################
variable "ssh_key_name" {
  type        = string
  default     = ""
  description = "The name of the public SSH key (VPC Gen 2 SSH Key) to be used for the ubuntu account"
}

##################################################################################
# internal_subnet_id - VPC Gen2 subnet ID for internal resources
##################################################################################
variable "internal_subnet_id" {
  type        = string
  default     = ""
  description = "VPC Gen2 subnet ID for internal resources"
}

##################################################################################
# cluster_encrypt_key - Consul encrypt key
##################################################################################
variable "cluster_encrypt_key" {
  type        = string
  default     = ""
  description = "Consul encrypt key"
}

##################################################################################
# ca_cert_chain - PEM format ca certificate
##################################################################################
variable "ca_cert_chain" {
  type        = string
  default     = ""
  description = "PEM format ca certificate"
}

##################################################################################
# server_01_cert - server-01 certificate
##################################################################################
variable "server_01_cert" {
  type        = string
  default     = ""
  description = "PEM format server-01 certificate"
}

##################################################################################
# server_01_key - server-01 private key
##################################################################################
variable "server_01_key" {
  type        = string
  default     = ""
  description = "server-01 private key"
}

##################################################################################
# server_02_cert - server-02 certificate
##################################################################################
variable "server_02_cert" {
  type        = string
  default     = ""
  description = "PEM format server-01 certificate"
}

##################################################################################
# server_02_key - server-02 private key
##################################################################################
variable "server_02_key" {
  type        = string
  default     = ""
  description = "server-02 private key"
}

##################################################################################
# server_03_cert - server-03 certificate
##################################################################################
variable "server_03_cert" {
  type        = string
  default     = ""
  description = "PEM format server-03 certificate"
}

##################################################################################
# server_03_key - server-03 private key
##################################################################################
variable "server_03_key" {
  type        = string
  default     = ""
  description = "server-03 private key"
}

##################################################################################
# client_cert - client certificate
##################################################################################
variable "client_cert" {
  type        = string
  default     = ""
  description = "PEM format client certificate"
}

##################################################################################
# client_key - client private key
##################################################################################
variable "client_key" {
  type        = string
  default     = ""
  description = "client private key"
}