resource "massdriver_artifact" "azure_storage_account_blob" {
  field                = "azure_storage_account_blob"
  provider_resource_id = module.azure_storage_account.account_id
  name                 = "Azure Blob Storage Account ${var.md_metadata.name_prefix} (${module.azure_storage_account.account_id})"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          ari      = module.azure_storage_account.account_id
          endpoint = module.azure_storage_account.primary_blob_endpoint
        }
        security = {
          iam = {
            "read" = {
              role  = "Storage Blob Data Reader"
              scope = module.azure_storage_account.account_id
            },
            "read_write" = {
              role  = "Storage Blob Data Contributor"
              scope = module.azure_storage_account.account_id
            }
          }
        }
      }
      specs = {
        azure = {
          region = azurerm_resource_group.main.location
        }
      }
    }
  )
}


#data "azurerm_storage_account_sas" "sas" {
#  connection_string = module.azure_storage_account.primary_connection_string
#  https_only        = true
#  start             = timestamp()
#  expiry            = timeadd(timestamp(), "2160h") # 90 days
#  resource_types {
#    service   = true
#    container = true
#    object    = true
#  }
#  services {
#    blob  = true
#    queue = false
#    table = false
#    file  = false
#  }
#  permissions {
#    read    = true
#    write   = true
#    delete  = true
#    list    = true
#    add     = true
#    create  = true
#    update  = true
#    process = true
#    tag     = false
#    filter  = false
#  }
#
#}

#resource "massdriver_artifact" "azure_storage_account_blob_sas" {
#  field                = "azure_storage_account_blob_sas"
#  provider_resource_id = module.azure_storage_account.account_id
#  name                 = "Azure Blob Storage Account ${var.md_metadata.name_prefix} (${module.azure_storage_account.account_id}) SAS"
#  artifact = jsonencode(
#    {
#      data = {
#        infrastructure = {
#          ari      = module.azure_storage_account.account_id
#          endpoint = module.azure_storage_account.primary_blob_endpoint
#        }
#      }
#      specs = {
#        azure = {
#          sas = data.azurerm_storage_account_sas.sas.sas
#        }
#      }
#    }
#  )
#}