# 1️⃣ Resource Group
resource "azurerm_resource_group" "rg_CloudCourseProject" {
  name     = var.resource_group_name
  location = var.location
}

# 3️⃣ MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "db_server" {
  name                   = "database-for-cloud-course-${random_string.suffix.result}"
  version                = "8.0.21"
  resource_group_name    = azurerm_resource_group.rg_CloudCourseProject.name
  location               = azurerm_resource_group.rg_CloudCourseProject.location
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  backup_retention_days  = 7    # Retain backups for 7 days, can be 7-35
    sku_name               = "B_Standard_B1ms"
}

# 4️⃣ Firewall Rule (to allow your IP or your VM to connect)
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_all_ips" {
  name                = "allow-all-ips"
  resource_group_name = azurerm_resource_group.rg_CloudCourseProject.name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

# Random suffix to make the server name globally unique
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


resource "azurerm_container_registry" "name" {
    name                = "acrcloudcourse${random_string.suffix.result}"
    resource_group_name = azurerm_resource_group.rg_CloudCourseProject.name
    location            = azurerm_resource_group.rg_CloudCourseProject.location
    sku                 = "Basic"
    admin_enabled       = true
    admin_username      = var.acr_admin_username
    admin_password      = var.acr_admin_password
}

# 5️⃣ Container Instance for Apache James mail server
resource "azurerm_container_group" "apache-james-container" {
  name                = "apache-james-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg_CloudCourseProject.location
  resource_group_name = azurerm_resource_group.rg_CloudCourseProject.name
  ip_address_type     = "Public"
  dns_name_label      = "apache-james-dns-name-label"
  os_type             = "Linux"

  container {
    name   = "james"
    image  = "https://hub.docker.com/r/apache/james:jpa-3.9.0"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
