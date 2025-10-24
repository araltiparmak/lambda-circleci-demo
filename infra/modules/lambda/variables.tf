variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "filename" {
  type        = string
  description = "Absolute or relative path to zipped Lambda artifact"
}

variable "runtime" {
  type = string
}

variable "handler" {
  type        = string
  description = "Handler entrypoint"
  default     = "index.handler"
}

variable "timeout" {
  type    = number
  default = 5
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "arch" {
  type        = string
  description = "CPU architecture (x86_64 or arm64)"
  default     = "x86_64"
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "attach_basic_exec_policy" {
  type    = bool
  default = true
}

variable "inline_policy_json" {
  type        = string
  description = "Optional additional inline IAM policy JSON attached to the Lambda role"
  default     = null
}

variable "create_api_gateway" {
  description = "Whether to create API Gateway"
  type        = bool
  default     = false
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "artifact_path" {
  type        = string
  description = "Optional path to a real Lambda zip (relative or absolute). Leave empty to use Terraform-generated dummy zip."
  default     = ""
}