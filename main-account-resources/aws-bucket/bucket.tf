resource "aws_s3_bucket" "example" {
  bucket = "bucket-gleidonfersnp"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
