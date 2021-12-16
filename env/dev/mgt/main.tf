# references
# 1. https://stackoverflow.com/questions/67012478/locals-tf-file-parsing-jsonencode-body

# glb

resource "random_string" "rnd" {
  length  = 8
  special = false
  number  = true
  lower   = false
  upper   = false
}

# mgt
# 01. resource group 
resource "azurerm_resource_group" "rgp" {
  name     = "${var.resource_codes.prefix}-${var.resource_codes.resource_group}-${local.res_num}"
  location = var.region
  tags     = var.tags
}

# 02. storage account
resource "azurerm_storage_account" "sta" {
  name                     = "1${var.resource_codes.storage}${local.rnd_string}"
  resource_group_name      = azurerm_resource_group.rgp.name
  location                 = azurerm_resource_group.rgp.location
  account_tier             = var.sta.tier
  account_replication_type = var.sta.replication
  tags                     = var.tags
}

# 03. key vault
resource "azurerm_key_vault" "kvt" {
  name                        = "${var.resource_codes.prefix}-${local.rnd_string}-${var.resource_codes.key_vault}-${local.res_num}"
  location                    = azurerm_resource_group.rgp.location
  resource_group_name         = azurerm_resource_group.rgp.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = var.kvt_retention_days
  purge_protection_enabled    = false
  sku_name                    = var.kvt_sku
  tags                        = var.tags
}

# 04. recovery services vault
resource "azurerm_recovery_services_vault" "rsv" {
  name                = "${var.resource_codes.prefix}-${local.rnd_string}-${var.resource_codes.recovery_vault}-${local.res_num}"
  location            = azurerm_resource_group.rgp.location
  resource_group_name = azurerm_resource_group.rgp.name
  sku                 = var.rsv_sku
  soft_delete_enabled = true
  tags                = var.tags
}

# net
module "net" {
  source          = "../net"
  resource_number = var.resource_number
  rgp_location    = azurerm_resource_group.rgp.location
  rgp_name        = azurerm_resource_group.rgp.name
  #  series_suffix = "01"
  vnt = {
    addr_space_prefix    = "10.20"
    addr_space_suffix    = "0/23"
    web_sub_name_prefix  = "web-snt"
    web_sub_range_suffix = "0/28"
    sql_sub_name_prefix  = "sql-snt"
    sql_sub_range_suffix = "16/28"
    dev_sub_name_prefix  = "dev-snt"
    dev_sub_range_suffix = "32/28"
    bas_sub_name         = "AzureBastionSubnet"
    bas_sub_range_suffix = "0/27"
  }
  resource_codes = {
    prefix            = "azr"
    resource_group    = "rgp"
    key_vault         = "kvt"
    recovery_vault    = "rsv"
    storage           = "sta"
    ext_load_balancer = "elb"
    web               = "web"
    development       = "dev"
    subnet            = "snt"
    sql               = "sql"
    vnet              = "vnt"
    net_sec_grp       = "nsg"
    public_ip         = "pip"
    bastion           = "bas"
    availaiblity_set  = "avs"
    bep               = "bep"
  }
  tags = {
    "environment" = "dev"
  }

  nsg_rules = [
    {
      name                       = "http"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = module.net.web_snt_prefix[0]
    },
    {
      name                       = "sql"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1443"
      source_address_prefix      = module.net.web_snt_prefix[0]
      destination_address_prefix = module.net.sql_snt_prefix[0]
    },
    {
      name                       = "dev"
      priority                   = "120"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = module.net.sql_snt_prefix[0]
      destination_address_prefix = module.net.sql_snt_prefix[0]
    }
  ]

  nsg_name_list = [
    "web-nsg-${var.resource_number}",
    "sql-nsg-${var.resource_number}",
    "dev-nsg-${var.resource_number}"
  ]

  nics = [
    {
      vm = "dev01"
      ipconfig = {
        name         = "${var.resource_codes.prefix}${var.resource_codes.development}${tostring(var.resource_number)}-nic-${var.series_suffix}"
        sub_id       = module.net.dev_snt_id
        prv_ip_alloc = "Dynamic"
      }
    },
    {
      vm = "sql01"
      ipconfig = {
        name         = "${var.resource_codes.prefix}${var.resource_codes.sql}${tostring(var.resource_number)}-nic-${var.series_suffix}"
        sub_id       = module.net.dev_snt_id
        prv_ip_alloc = "Dynamic"
      }
    }
  ]

  net_rnd_str = "a${local.rnd_string}"
  bas_rnd_str = "${local.rnd_string}"

  public_dns_suffix = "${var.region}.cloudapp.azure.com"

  pips = [
    {
      name = "${var.resource_codes.prefix}-${var.resource_codes.web}-${var.resource_codes.public_ip}-${var.resource_number}"
      alloc = "Static"
      sku = "Standard"
    },
    {
      name = "${var.resource_codes.prefix}-${var.resource_codes.bastion}-${var.resource_codes.public_ip}-${var.resource_number}"
      alloc = "Static"
      sku = "Standard"
    }
  ]

  alb = {
    name = "${var.resource_codes.prefix}-${var.resource_codes.ext_load_balancer}-${local.rnd_string}-${var.resource_number}"
    sku = "Standard"
    fe_ip_name = "${var.resource_codes.prefix}-${var.resource_codes.web}-${var.resource_codes.public_ip}-${var.resource_number}"
    bep_name = "${var.resource_codes.prefix}-${var.resource_codes.ext_load_balancer}-bep-${var.resource_number}"
    bep_ip = "${var.vnt.addr_space_prefix}.${var.resource_number}.1"
    outbound_rule_name = "lb-outbound-rule"
    outbound_rule_protocol = "Tcp"
    probe_name = "http-probe"
    probe_port = "80"
    lb_rule_name = "lb-rule"
    lb_rule_protocol = "Tcp"
    lb_rule_fep = "80"
    lb_rule_bep = "80"
  }
}

# 05. mgt vm

resource "azurerm_windows_virtual_machine" "dev" {
  name = "${var.resource_codes.prefix}${var.resource_codes.development}${var.resource_number}${var.series_suffix}"
  resource_group_name = azurerm_resource_group.rgp.name 
  location = azurerm_resource_group.rgp.location
  size = var.vm_image_dev.size 
  admin_username = var.vm_cred.username 
  admin_password = "${data.azurerm_key_vault_secret.vm_pw.value}"
  network_interface_ids = [ 
    module.net.dev_nic_id
  ]

  os_disk {
    caching = var.os_dsk.cache 
    storage_account_type = var.os_dsk.sta_type
  }

  source_image_reference {
    publisher = var.vm_image_dev.pub 
    offer = var.vm_image_dev.ofr 
    sku = var.vm_image_dev.sku
    version = var.vm_image_dev.ver
  }
}

resource "azurerm_windows_virtual_machine" "sql" {
  name = "${var.resource_codes.prefix}${var.resource_codes.sql}${var.resource_number}${var.series_suffix}"
  resource_group_name = azurerm_resource_group.rgp.name 
  location = azurerm_resource_group.rgp.location
  size = var.vm_image_dev.size 
  admin_username = var.vm_cred.username 
  admin_password = "${data.azurerm_key_vault_secret.vm_pw.value}"
  network_interface_ids = [ 
    module.net.sql_nic_id
  ]

  os_disk {
    caching = var.os_dsk.cache 
    storage_account_type = var.os_dsk.sta_type
  }

  source_image_reference {
    publisher = var.vm_image_sql.pub 
    offer = var.vm_image_sql.ofr 
    sku = var.vm_image_sql.sku
    version = var.vm_image_sql.ver
  }
}

# web
module "web" {
  source = "../web"
  lvmss = {
    core = {
      name = "${var.resource_codes.prefix}${var.resource_codes.web}${var.resource_number}"
      sku = "Standard_F2"
      instances = 2
    }
    ssh = {
      pub_ssh_key = file("~/.ssh/id_rsa.pub")
    }
    
    vm_image_web = {
      pub = "Canonical"
      ofr = "UbuntuServer"
      sku = "18.04-LTS"
      ver = "latest"
    }
    os_dsk = {
      sta_type = "Standard_LRS"
      cache = "ReadWrite"
    }
    nic = {
      name = "${var.resource_codes.prefix}${var.resource_codes.web}${var.resource_number}"
      subnet_id = module.net.web_snt_id
    }
  }
  vmss_cred = "adminuser"
  rgp_name = azurerm_resource_group.rgp.name 
  rgp_location = azurerm_resource_group.rgp.location
  sta_pri_ep = data.azurerm_storage_account.sta.primary_blob_endpoint
  lbp_id = module.net.lbp_id
  lb_pip = module.net.pip_web
  pip_name = "${var.resource_codes.prefix}-${var.resource_codes.web}-${var.resource_codes.public_ip}-${var.resource_number}"
  web_dnl = "${var.resource_codes.prefix}-${var.resource_codes.web}-${var.app.name}"
  alb_bep_name = "${var.resource_codes.prefix}-${var.resource_codes.ext_load_balancer}-${local.rnd_string}-${var.resource_number}"
  lb_id = module.net.load_bal_id
  depends_on = [
    module.net
  ]
}
# 11. avset
# 12. scale set
# 13. alb

# data
# 14. sql server
