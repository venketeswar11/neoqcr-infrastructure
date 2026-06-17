# 1. WAF Policy with Custom Rules
resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "neoqcr-waf-policy-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  custom_rules {
    name      = "RestrictToTrustedIPs"
    priority  = 10
    rule_type = "Match"
    action    = "Block"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "IPMatch"
      negation_condition = true
      match_values       = var.trusted_ips
    }
  }
}

# 2. Dummy Public IP (Required by App Gw V2 SKU)
resource "azurerm_public_ip" "dummy" {
  name                = "appgw-dummy-pip-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 3. Application Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "api-qcrpredict-gateway-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                          = "private-frontend"
    subnet_id                     = var.app_gateway_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_frontend_ip
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.dummy.id
  }

  backend_address_pool {
    name         = "Backend-REST-Pool"
    ip_addresses = [var.backend_ip_address]
  }

  backend_http_settings {
    name                  = "Test-settings"
    cookie_based_affinity = "Disabled"
    port                  = 4030
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "api-health-probe"
  }

  probe {
    name                                      = "api-health-probe"
    protocol                                  = "Http"
    path                                      = "/neo-qcr/health"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  http_listener {
    name                           = "private-https-listener"
    frontend_ip_configuration_name = "private-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    # In enterprise TF, SSL certs are usually pulled from Azure Key Vault data sources. 
    # Placeholder for Key Vault Secret ID:
    # ssl_certificate_name = "qcrpredict-cert" 
    # key_vault_secret_id  = data.azurerm_key_vault_secret.cert.id
  }

  request_routing_rule {
    name                       = "route-to-api"
    rule_type                  = "Basic"
    http_listener_name         = "private-https-listener"
    backend_address_pool_name  = "Backend-REST-Pool"
    backend_http_settings_name = "Test-settings"
    priority                   = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf.id
}