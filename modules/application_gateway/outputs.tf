output "application_gateway_id" {
  value       = azurerm_application_gateway.appgw.id
  description = "The ID of the Application Gateway"
}

output "waf_policy_id" {
  value       = azurerm_web_application_firewall_policy.waf.id
  description = "The ID of the WAF Policy"
}