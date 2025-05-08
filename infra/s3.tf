resource "aws_s3_bucket" "s3_sinnapse" {
  bucket = "files-lambda-acesso"

  tags = {
    Name        = "bucket_sinnapse"
    Environment = "projeto_sinnapse"
  }
}


resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.s3_sinnapse.id
  policy = data.aws_iam_policy_document.allow_access_policy.json
}

data "aws_iam_policy_document" "allow_access_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["940482430035"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.s3_sinnapse.arn,
      "${aws_s3_bucket.s3_sinnapse.arn}/*",
    ]
  }
}