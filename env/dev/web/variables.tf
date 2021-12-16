variable "lvmss" {
  type = object({
      core = map(string)
      ssh = map(string)
      vm_image_web = map(string)
      os_dsk = map(string)
      nic = map(string)
  })
}

variable "rgp_location" {
  type = string
  description = "Location of resource group."
}

variable "rgp_name" {
  type = string
  description = "Resource group name."
}

variable "vmss_cred" {
  type = string
  description = "Username for VM scale set."
}

variable "sta_pri_ep" {
  type = string
  description = "Storage account primary blob endpoint."
}

variable "lbp_id" {
    type = string
    description = "Load balancer probe id."
}

variable "lb_pip" {
  type = string 
  description = "Load balancer public IP address."
}

variable "web_dnl" {
  type = string 
  description = "Domain name label prefix."
}

variable "pip_name" {
  type = string 
  description = "Public IP address configuration name."
}

variable "alb_bep_name" {
  type = string
  description = "Azure load balancer properties."
}

variable "lb_id" {
  type = string 
  description = "Load balancer ID."
}