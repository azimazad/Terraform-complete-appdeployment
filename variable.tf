#Access Variables
variable "access_key" {}
variable "secret_key" {}

variable "REGION" {
  default = "us-east-1"
}

variable "ZONE" {
  default = "us-east-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0c02fb55956c7d316"

  }
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "demokey.pub"

}

variable "PRIV_KEY" {
  default = "demokey"
}

