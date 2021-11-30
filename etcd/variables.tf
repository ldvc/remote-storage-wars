variable "etcd_instance_flavor" {
  description = "The name of the instance to use for the etcd servers."
  type        = string
  default     = "s1-2"
}

variable "etcd_count" {
  description = "The number of etcd instance."
  type        = number
  default     = 0
}
