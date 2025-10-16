variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources"
  type        = string
  default     = "rg-CloudCourseProject"
}

variable "location" {
    description = "The Azure region in which to create the resources"
    type        = string
    default     = "northeurope"
}

variable "db_server" {
    description = "The name of the MySQL server"
    type        = string
    default     = "mysql-server-cloudcourse"
}
variable "db_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "vegtableFoxScrew"
}

variable "db_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
    default     = "EdgePenicillin8#Fly"
}