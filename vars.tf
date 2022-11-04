variable "identifier" {
  type        = string
  description = "Cluster identifier"
}

variable "secret-identifier" {
  type        = string
  description = "Secret identifier"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "writer_instance_type" {
  type        = string
  description = "Instance type of writers"
  default     = "db.r5.large"
}

variable "mysql_version" {
  type        = string
  description = "The mysql version to use"
  default     = "5.7.mysql_aurora.2.10.2"
}

variable "zones" {
  type        = list(string)
  description = "Availability zones"
}

variable "master_username" {
  type        = string
  description = "Username for master user"
}

variable "master_password" {
  description = "Password for the master DB user. Note - when specifying a value here, 'create_random_password' should be set to `false`"
  type        = string
  default     = null
}

variable "random_password_length" {
  description = "Length of random password to create. Defaults to `10`"
  type        = number
  default     = 10
}

variable "create_random_password" {
  description = "Determines whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}


variable "vpc" {
  type        = object({ id : string, cidr_block : string })
  description = "The VPC to create the cluster in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids where cluster should be located"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Store final snapshot or not when destroying database"
}

variable "cluster_parameters" {
  type        = map(string)
  default     = {}
  description = "cluster parameter group overrides"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "KMS key to use for encryption"
}

variable "enhanced_monitoring" {
  type        = bool
  default     = false
  description = "Enable enhanced monitor on the instance"
}

variable "reader_instance_type" {
  type        = string
  description = "Instance type of writers"
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql`"
  type        = list(string)
  default     = []
}

variable "cost_center" {
  type        = string
  description = "Cost Center"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "project" {
  type        = string
  description = "Project"
}