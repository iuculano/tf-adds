variable "ami_id" {
  type        = string
  default     = ""
  description = "The AMI to use."  
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "Type of instance to launch."
}

variable "cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR blocks to allow access from."
}

variable "launch_subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of subnets to launch instances in."
}

variable "launch_instance_type" {
  type        = string
  default     = "t3a.medium"
  description = "Type of instance to launch."
}

variable "public_key" {
  type        = string
  default     = ""
  description = "The public key that the instances will use. This will create a key-pair."  
}
