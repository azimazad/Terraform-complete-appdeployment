terraform {
  backend "s3" {
    bucket = "terra-demoapp"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
