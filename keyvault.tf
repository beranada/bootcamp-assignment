data "azurerm_client_config" "bootcamp" {}

resource "azurerm_key_vault" "vault1" {
  name                       = "ab-keyvault185"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  sku_name                   = "premium"
  tenant_id                  = data.azurerm_client_config.bootcamp.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  #enable_rbac_authorization  = true


  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# Role assigmnment might not be neccessary due to enable_rbac_authorization  = true

resource "azurerm_role_assignment" "key_vault_admin" {
  scope                = azurerm_key_vault.vault1.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "9ff1a86b-180b-40fd-bb20-f35916113f0e"
}

resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = azurerm_key_vault.vault1.id
  role_definition_name = "Key Vault Reader"
  principal_id         = "9ff1a86b-180b-40fd-bb20-f35916113f0e"
}

resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  name                = "ab-keyvault-pe-bootcamp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet01.id

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.vault1.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

