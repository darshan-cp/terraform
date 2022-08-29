variable "cidr_vpc_block" {
  type        = string
  default     = ""
  description = "Main VPC name"
}

variable "cidr_vpc_block_tag" {
  type        = string
  default     = ""
  description = "Main VPC Tag name"
}

variable "cidr_zone" {
  type        = list(any)
  default     = []
  description = "Subnet Zone name"
}

variable "subname_cidr_block" {
  type        = map(any)
  default     = {}
  description = "Subnet Zone name"
}


variable "cidr_router" {
  type        = string
  default     = ""
  description = "Router Tables"
}

variable "cidr_internet_getway" {
  type        = string
  default     = ""
  description = "Internet Getway block"
}