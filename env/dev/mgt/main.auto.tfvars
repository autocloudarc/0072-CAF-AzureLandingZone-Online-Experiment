resource_number = 10
series_suffix   = "01"
storage_infix   = "sta"
region          = "eastus2"
tags = {
  "environment" = "dev"
}
kvt_retention_days = 7
kvt_sku            = "standard"
# CONFIG-ITEM: Replace <tenantid> below with your actual tenant id
tenant_id          = "<tenantid>"
rsv_sku            = "Standard"
vnt = {
  addr_space_prefix    = "10.20"
  addr_space_suffix    = "0/26"
  web_sub_name_prefix  = "web-snt"
  web_sub_range_suffix = "0/29"
  sql_sub_name_prefix  = "sql-snt"
  sql_sub_range_suffix = "8/29"
  dev_sub_name_prefix  = "dev-snt"
  dev_sub_range_suffix = "16/29"
  bas_sub_name         = "AzureBastionSubnet"
  bas_sub_range_suffix = "32/27"
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
}

sta = {
  tier        = "Standard"
  replication = "LRS"
}

vm_image_dev = {
  pub  = "MicrosoftWindowsServer"
  ofr  = "WindowsServer"
  sku  = "2022-Datacenter"
  ver  = "latest"
  size = "Standard_B1ms"
}

vm_image_sql = {
  pub  = "MicrosoftsqlServer"
  ofr  = "sql2019-ws2019"
  sku  = "sqldev"
  ver  = "latest"
  size = "Standard_B1ms"
}

vm_image_web = {
  pub  = "MicrosoftWindowsServer"
  ofr  = "WindowsServer"
  sku  = "2022-Datacenter"
  ver  = "latest"
  size = "Standard_DS1_v2"
}

vm_cred = {
  username = "adminuser"
}

os_dsk = {
  cache = "ReadWrite"
  sta_type = "Standard_LRS"
}

kvt_res_id = "<kvt_res_id>"

kvt_sec_name = "adminuser"

app = {
  name = "app01"
  id = "0001"
}


