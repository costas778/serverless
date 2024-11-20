variable "environment" {
  description = "Environment name"
  type        = string
  default     = "poc"
}

variable "email_endpoint" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}