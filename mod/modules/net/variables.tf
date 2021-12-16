variable "resource_number" {
  type = number 
  description = "Two digit resource number between 10-16 to prevent resource name conflicts for multiple deployments."
  validation {
    condition = alltrue([
        var.resource_number >= 10,
        var.resource_number <= 16
    ])
    error_message = "This value must have be between 10 to 16."
  }
}

/*
variable "series_suffix" {
  type = string
  description = "Series suffix for Azure resources."
  default = "01"
}
*/

variable "rgp_location" {
  type = string
  description = "Location of resource group."
}

variable "rgp_name" {
  type = string
  description = "Resource group name."
}

variable "vnt" {
  type = map(string)
  description = "Virtual network object."
}

variable "resource_codes" {
  type = map(string)
  description = "Azure resource codes."
}

variable "tags" {
  type = map(string)
  description = "Resource tags."
}

variable "nsg_name_list" {
  type = list(string)
  description = "List of NSGs to provision."
}

variable "nsg_rules" {
  type = list(map(string))
}