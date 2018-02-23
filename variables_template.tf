
variable "management_vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "prod_workload_vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "20.0.0.0/16"
}
variable "non_prod_workload_vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "30.0.0.0/16"
}
variable "public_subnets_mngmt" {
  description = "A list of public subnets cidr inside the VPC."
  default     = "10.0.1.0/24"
 } 
variable "private_subnets_mngmt" {
  description = "A list of public subnets cidr inside the VPC."
  default     = "10.0.2.0/24"
 } 
variable "public_subnets_prod" {
  description = "A list of public subnets cidr inside the VPC."
  default     =  [ "20.0.1.0/24" , "20.0.2.0/24" ] 
 } 
variable "private_subnets_prod" {
  description = "A list of private subnets cidr inside the VPC."
  default     =  [ "20.0.3.0/24" ] 
 } 
variable "public_subnets_non_prod" {
  description = "A list of public subnets cidr inside the VPC."
  default     =  [ "30.0.1.0/24" , "30.0.2.0/24" ] 
 } 
variable "private_subnets_non_prod" {
  description = "A list of private subnets cidr inside the VPC."
  default     =  [ "30.0.3.0/24" ] 
 } 
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = "false"
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = "true"
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = "aws1223"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {
"awstest" = "awstest"
          "Project" = "Agility SPARK GIGA"
  }
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {
        "CreatedBy" = "Aman"
       }
  
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  default     = {
        "CreatedBy" = "Aman"
        "Project" = "Agility SPARK GIGA"
  }
}

variable "access_key" {
  description = "AWS access key"
  default     = "aws_access_key"
}
variable "secret_key" {
  description = "AWS secret access key"
  default     = "aws_secret_key"
}
variable "region"     {
  description = "AWS region to host your network"
  default     = "aws_region"
}  
variable "masternodehostname"     {
  description = "Hostname for master node"
  default     = "hostname1_server1"
}
variable "workernode1hostname"     {
  description = "Hostname for workernode1" 
  default     = "hostname_server2"
}
variable "workernode2hostname"     {
  description = "Hostname for workernode2"
  default         = "hostname_server3"
}
variable "plugin_install" {
    description = "Choose to Install Cloud Plugin"
    default = "yes"

}
