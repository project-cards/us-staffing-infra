# ----------------------------------------------------------------------------
# variables.tf (module: eks)
# ----------------------------------------------------------------------------

variable "name" {
  description = "Cluster name, for example us-staffing-dev."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version. Check it is in standard support in the AWS console before applying."
  type        = string
}

variable "subnet_ids" {
  description = "App subnets: the control plane and the worker nodes both use them. At least two zones."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS key that encrypts Kubernetes secrets (the same key as the state)."
  type        = string
}

variable "public_access_cidrs" {
  description = "Addresses allowed to reach the public API endpoint. IAM still checks every request."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "admin_principal_arns" {
  description = "IAM roles or users given cluster-admin through access entries."
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 sizes for the worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "tags" {
  type    = map(string)
  default = {}
}
