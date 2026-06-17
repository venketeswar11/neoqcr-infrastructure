variable "environment" {
  type        = string
  description = "The environment name (e.g., dev, prod)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "app_gateway_subnet_id" {
  type        = string
  description = "The ID of the AppGatewaySubnet"
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