#variable "availability_zones" {
#description = "Availability zones"
#type = set(string)
#default = ["eu-west-1a", "eu-west-1b"]
#}

variable "az_1" {
  type    = string
  default = "eu-west-1a"
}

variable "az_2" {
  type    = string
  default = "eu-west-1b"
}

#variable "subnets" {
#type = list(string)
#default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24",
#"10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
#}

variable "public_subnet_1" {
  type    = string
  default = "10.10.1.0/24"
}

variable "public_subnet_2" {
  type    = string
  default = "10.10.2.0/24"
}

variable "private_subnet_1" {
  type    = string
  default = "10.10.3.0/24"
}

variable "private_subnet_2" {
  type    = string
  default = "10.10.4.0/24"
}

variable "private_subnet_3" {
  type    = string
  default = "10.10.5.0/24"
}

variable "private_subnet_4" {
  type    = string
  default = "10.10.6.0/24"
}