resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "SITE-SCAN"
  billing_mode   = "PAY_PER_REQUEST"
  # read_capacity  = 20
  # write_capacity = 20
  # chaves primarias
  hash_key       = "Email"
  range_key      = "HashMd5"

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "HashMd5"
    type = "S"
  }

#   attribute {
#     name = "Client"
#     type = "S"
#   }

#   attribute {
#     name = "Mobile"
#     type = "S"
#   }

#   attribute {
#     name = "QueryResult"
#     type = "S"
#   }

#   attribute {
#     name = "QueryType"
#     type = "S"
#   }

#   attribute {
#     name = "Timestamp"
#     type = "N"
#   }

#   attribute {
#     name = "QueryId"
#     type = "S"
#   }


  tags = {
    Name        = "dynamodb-SITE-SCAN"
    Environment = "production"
  }
}