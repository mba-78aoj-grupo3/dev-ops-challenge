terraform {
  backend "s3" {
    bucket = "final-challenge-bucket"
    key    = "state"
    region = "us-east-1"
  }
}
