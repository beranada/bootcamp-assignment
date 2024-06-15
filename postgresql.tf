
data "azurerm_client_config" "current" {}

resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                          = "ab-postgresql"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku_name                      = "B_Standard_B1ms"
  administrator_login           = "adminTerraform"
  administrator_password        = random_password.password.result
  storage_mb                    = 32768
  version                       = "12"
  auto_grow_enabled             = false # Disabling auto-grow
  public_network_access_enabled = false # Disabling public access
  zone                          = "2"

  #Subnet and DNS
  delegated_subnet_id = azurerm_subnet.subnet02.id
  private_dns_zone_id = azurerm_private_dns_zone.postgresql.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql_link]

  # authentication {
  #   active_directory_auth_enabled = true
  #   tenant_id                     = data.azurerm_client_config.current.tenant_id
  # }


  #   # Enable Azure AD authentication
  #   identity {
  #     type = "SystemAssigned"
  #   }

  #   tags = {
  #     environment = "bootcamp"
  #   }
}

# resource "azurerm_postgresql_flexible_server_active_directory_administrator" "example2" {
#   server_name         = azurerm_postgresql_flexible_server.postgresql.name
#   resource_group_name = azurerm_resource_group.rg.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   object_id           = "9ff1a86b-180b-40fd-bb20-f35916113f0e"
#   principal_name      = "adam.beranek_tietoevry.com#EXT#@tietoevryedu.onmicrosoft.com"
#   principal_type      = "ServicePrincipal"
# }
