variable "resource_number" {
  type        = number
  description = "Two digit resource number between 10-16 to prevent resource name conflicts for multiple deployments."
  validation {
    condition = alltrue([
      var.resource_number >= 10,
      var.resource_number <= 16
    ])
    error_message = "This value must have be between 10 to 16."
  }
}
variable "series_suffix" {
  type        = string
  description = "Series suffix for Azure resources."
  default     = "01"
}
variable "storage_infix" {
  type        = string
  description = "Infix for storage accounts."
}

variable "region" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
}

variable "kvt_retention_days" {
  type        = number
  description = "Key Vault soft delete retention days."
}

variable "kvt_sku" {
  type        = string
  description = "Key vault sku name."
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID."
  sensitive   = true
}

variable "rsv_sku" {
  type        = string
  description = "SKU for recovery services vault."
}
variable "vnt" {
  type        = map(string)
  description = "Virtual network object."
}

variable "resource_codes" {
  type        = map(string)
  description = "Azure resource codes."
}

variable "sta" {
  type        = map(string)
  description = "Azure storage resource attributes."
}

variable "vm_image_dev" {
  type = map(string)
  description = "Dev VM attributes."
}

variable "vm_image_sql" {
  type = map(string)
  description = "SQL VM attributes."
}
variable "vm_image_web" {
  type = map(string)
  description = "Web VM attributes."
}

variable "vm_cred" {
  type = map(string)
  description = "VM credentials."
  sensitive = true
}

variable "os_dsk" {
  type = map(string)
  description = "VM OS disk properties."
}

variable "kvt" {
  type = map(string)
  description = "Key Vault resource properties"
}

variable "app" {
  type = map(string)
  description = "Application name and id."
}