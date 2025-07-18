provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = "East US"
}

resource "azurerm_postgresql_flexible_server" "db" {
  name                   = var.pg_name
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = var.pg_admin
  administrator_password = var.pg_password
  version                = "13"
  storage_mb             = 32768
  sku_name               = "B1ms"
}

resource "azurerm_redis_cache" "redis" {
  name                = var.redis_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_app_service_plan" "plan" {
  name                = "quoteapp-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "quoteapp-web"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/quoteapp:latest"
    always_on        = true
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    NODE_ENV                        = "production"
    DATABASE_URL                    = "postgres://${var.pg_admin}:${var.pg_password}@${azurerm_postgresql_flexible_server.db.fqdn}:5432/postgres"
    REDIS_URL                       = azurerm_redis_cache.redis.hostname
  }

  identity {
    type = "SystemAssigned"
  }
}
