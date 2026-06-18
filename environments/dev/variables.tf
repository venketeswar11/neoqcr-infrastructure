variable "environment" {
  type        = string
  description = "The environment name (e.g., dev, prod)"
}

variable "existing_resource_group_name" {
  type        = string
  description = "Name of the existing resource group holding the VNet"
}

variable "existing_vnet_name" {
  type        = string
  description = "Name of the existing Virtual Network"
}

variable "subnet_address_prefix" {
  type        = string
  description = "The IP range to create for the AppGatewaySubnet"
}

variable "private_frontend_ip" {
  type        = string
  description = "The static private IP for the App Gateway"
}

variable "backend_ip_address" {
  type        = string
  description = "The private IP of the backend REST server"
}

variable "trusted_ips" {
  type        = list(string)
  description = "List of trusted IP addresses or CIDR blocks for the WAF custom rule"
}
