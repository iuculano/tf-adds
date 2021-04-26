variable "environment" {
  type        = string
  default     = "YOU-SHOULD-OVERRIDE-THIS"
  description = "Environment name of the VPC."
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The IPv4 CIDR block to associate with the VPC."
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "A list of availability zones within the region."
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "A list of public subnets inside the VPC."
}

variable "application_subnets" {
  type        = list(string)
  default     = []
  description = "A list of private application subnets inside the VPC."
}

variable "database_subnets" {
  type        = list(string)
  default     = []
  description = "A list of private database subnets inside the VPC."
}

variable "serverless_subnets" {
  type        = list(string)
  default     = []
  description = "A list of private serverless subnets inside the VPC."
}
