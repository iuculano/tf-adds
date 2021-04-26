variable "domain_name" {
  type        = string
  default     = "ad.greatdomain.net"
  description = "The name of the domain to create."
}

# This will be written to the state file and should probably be changed...
variable "dsrm_password" {
  type        = string
  default     = "ThisIsAReallyStrongPasssword6940"
  description = "The DSRM password to set."
}

variable "instance_ids" {
  type        = list(string)
  default     = []
  description = "List of instance ids to use when creating the domain."
}