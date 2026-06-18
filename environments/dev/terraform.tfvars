# This file is safe to push to GitHub. It contains your specific DEV architecture values.

environment                  = "dev"
existing_resource_group_name = "NeoQCR" # Replace if your RG name is different
existing_vnet_name           = "NeoQCR-Jio-A100-vnet"
subnet_address_prefix        = "10.1.3.0/24" # The new subnet to create

private_frontend_ip = "10.1.2.10"
backend_ip_address  = "10.1.0.4"
trusted_ips         = ["192.168.10.0/24", "10.21.68.165", "10.21.68.166", "10.66.22.129"]