terraform {
  backend "azurerm" {
    resource_group_name  = "Myapprg"
    storage_account_name = "mystorageazacc"
    container_name       = "prodconfig"
    key                  = "terraform.prodconfig"
    access_key           = "fC9DSinvsfQJIAfo4r+4XMw3/GYnyYTCFAZA3RBIyiayxC7X2K6v/MSnqCZznIh52mRI82j9/HC9+ASt/y++pw=="
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.36.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

locals {
  setup_name = "amazon-hyd"
}

resource "azurerm_resource_group" "azapprg101" {
  name     = "my-app-rg"
  location = "Canada Central"

  tags = {
    Name = "${local.setup_name}-rsg"
  }
}

# ✅ Corrected service plan using os_type and sku_name
resource "azurerm_service_plan" "azappplan7895" {
  name                = "devazappplan"
  location            = azurerm_resource_group.azapprg101.location
  resource_group_name = azurerm_resource_group.azapprg101.name
  os_type             = "Windows"        # ✅ correct field
  sku_name            = "B1"             # ✅ correct field

  tags = {
    Name = "${local.setup_name}-appplan"
  }
}

# ✅ Web App using the correct service plan ID
resource "azurerm_app_service" "azwebapp101" {
  name                = "mywebapp7895"
  location            = azurerm_resource_group.azapprg101.location
  resource_group_name = azurerm_resource_group.azapprg101.name
  app_service_plan_id = azurerm_service_plan.azappplan7895.id

  site_config {
    always_on = false
  }

  tags = {
    Name = "${local.setup_name}-webapp"
  }
}
