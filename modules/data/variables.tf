# ----------------------------------------------------------------------------
# variables.tf (module: data)
# ----------------------------------------------------------------------------

variable "name" {
  description = "Name prefix, for example us-staffing-dev."
  type        = string
}

variable "vpc_id" {
  description = "The VPC the database lives in."
  type        = string
}

variable "subnet_ids" {
  description = "The private database subnets (one per zone)."
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "The EKS cluster security group. The only source allowed to reach port 5432."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key that encrypts the database and its password."
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL major version. AWS picks the latest minor version."
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Database size. db.t4g.micro is the smallest, for dev."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Storage in GB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the first database created inside the instance."
  type        = string
  default     = "staffing"
}

variable "master_username" {
  description = "Master user name. The password is generated and stored in Secrets Manager."
  type        = string
  default     = "dbadmin"
}

variable "multi_az" {
  description = "false for dev (one zone, cheaper). true for prod (standby in a second zone)."
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "How many days of automatic backups to keep."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "false for dev, so destroy works. true for prod."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "true for dev (no final backup on destroy). false for prod."
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
