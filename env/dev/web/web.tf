# https://linuxconfig.org/how-to-setup-the-nginx-web-server-on-ubuntu-18-04-bionic-beaver-linux
resource "azurerm_linux_virtual_machine_scale_set" "lvmss" {
  name = var.lvmss.core.name 
  resource_group_name = var.rgp_name 
  location = var.rgp_location
  sku = var.lvmss.core.sku 
  instances = var.lvmss.core.instances 
  admin_username = var.vmss_cred
  platform_fault_domain_count = 3
  scale_in_policy = "OldestVM"
  rolling_upgrade_policy {
    max_batch_instance_percent = 50
    pause_time_between_batches = "PT5M"
    max_unhealthy_instance_percent = 50
    max_unhealthy_upgraded_instance_percent = 50
  }
  lifecycle {
    create_before_destroy = true
  }
  boot_diagnostics {
    storage_account_uri = var.sta_pri_ep
  }
  automatic_instance_repair {
    enabled = true 
    grace_period = "PT30M"
  }
  extensions_time_budget = "PT15M"
  
  health_probe_id = var.lbp_id
  upgrade_mode = "Automatic"
  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback = true
  }
  
  # Create NGNIX web site
  # custom_data = filebase64("new-nginx-web.sh")
  terminate_notification {
    enabled = true 
    timeout = "PT5M"
  }

  admin_ssh_key {
    username = var.vmss_cred 
    public_key = var.lvmss.ssh.pub_ssh_key
  }

  source_image_reference {
    publisher = var.lvmss.vm_image_web.pub
    offer = var.lvmss.vm_image_web.ofr 
    sku = var.lvmss.vm_image_web.sku 
    version = var.lvmss.vm_image_web.ver 
  }

  os_disk {
    storage_account_type = var.lvmss.os_dsk.sta_type 
    caching = var.lvmss.os_dsk.cache
  }

  network_interface {
    name = var.lvmss.core.name
    primary = true

    ip_configuration {
      name = var.lvmss.core.name
      primary = true 
      subnet_id = var.lvmss.nic.subnet_id
      load_balancer_backend_address_pool_ids = [
        data.azurerm_lb_backend_address_pool.bep.id
      ]
    }
  }
}