variable "vpc_name" {
  type    = string
  default = "vpc-01"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = {
    "sb-app-01" = 0
    "sb-app-02" = 1
  }
}