###version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.5.0, <4.0.0"
    }
    restapi = {
      source = "fmontezuma/restapi"
    }
  }
  required_version = ">= 0.14"
}
###provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

###main
data "azurerm_service_plan" "service_plan" {
  name                = "ASP-rge1npapppspdev-9a46"
  resource_group_name = "rg-e1-np-app-psp-dev"
}

resource "azurerm_windows_web_app" "app_service" {
  name                = "testappservjuge"
  resource_group_name = "rg-e1-np-app-psp-dev"
  location            = "francecentral"
  service_plan_id     = "/subscriptions/9783655a-7251-425b-997b-aa9bddf14084/resourceGroups/rg-e1-np-app-psp-dev/providers/Microsoft.Web/serverfarms/ASP-rge1npapppspdev-9a46"

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
    }
    #autoheal
    auto_heal_enabled = true
    auto_heal_setting {
      trigger {
        private_memory_kb = "102401" 
        requests {
          count    = "10"
          interval = "00:10:00"
        }
        slow_request {
          count      = "10"
          interval   = "00:10:00"
          time_taken = "00:00:10"
        }
        status_code {
          count             = "10"
          interval          = "00:10:00"
          status_code_range = "500-503" 
        }
      }
      action {
        action_type                    = "Recycle" #Recycle, LogEvent or CustomAction
        minimum_process_execution_time = "00:10:00"
      }
    }
  }
}
