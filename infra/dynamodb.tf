resource "aws_dynamodb_table" "sandbox_table" {
  name         = "sandbox-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

}