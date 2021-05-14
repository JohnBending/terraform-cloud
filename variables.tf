variable "instance_type" {
  description = "Enter instance type"
  type        = string //можно не указывать
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List to ports open for server"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}

variable "common_tags" {
  description = "Command tags to all resources"
  type        = map(any)
  default = {
    Owner       = "Ivan Andreev"
    Project     = "Jenkins-master"
    CostCenter  = "CostCenter"
    Environment = "development"
  }
}
