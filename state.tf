terraform {
  backend "s3" {
    bucket = "udemy01-course"
    key    = "path/to/my/key"
    region = "eu-west-1"
  }
}
