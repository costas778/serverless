variable "environment" {
  description = "Environment name"
  type        = string
  default     = "poc"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}