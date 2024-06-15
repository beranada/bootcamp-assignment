resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_link" {
  name                  = "key-vault-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_link" {
  name                  = "postgresql-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_private_dns_a_record" "keyvault_dns_record" {
  name                = azurerm_key_vault.vault1.name
  zone_name           = azurerm_private_dns_zone.key_vault.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.keyvault_private_endpoint.private_service_connection[0].private_ip_address]
}