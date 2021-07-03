// BUCKET FOR STATE AND FILES
resource "aws_s3_bucket" "b" {
  bucket = "final-challenge-bucket"
  acl    = "private"

  tags = {
    Name        = "final-challenge-bucket"
    Environment = "admin"
  }
}
