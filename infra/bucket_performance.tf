resource "aws_s3_bucket" "s3_performance" {
  bucket = var.bucket_site

  tags = {
    Name = "site-peformance"dynamodb
    Projeto = "Sinnapse"	
  }
}

# indicar o endereco do bucket para o cloudfront
locals {
  s3_origin_id = "peformance-sinnapse.s3.us-east-1.amazonaws.com"
}

# Gerencia um AWS CloudFront Origin Access Control(OAC), que é usado pelas distribuições do CloudFront com um bucket do Amazon S3 como origem.
resource "aws_cloudfront_origin_access_control" "s3_origin" {
  name                              = var.bucket_site
  description                       = "Origin bucket site-sinnapse"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3_performance.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Site "
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = ["performance.sinnapse.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = "arn:aws:acm:us-east-1:940482430035:certificate/2eaeb4ff-931e-443a-8b8c-0b68ab446e55"
    ssl_support_method = "sni-only"	
  }
}

# bucket policy that allows read-only access to a CloudFront OAC
# resource "aws_s3_bucket_policy" "my_bucket_policy" {
#   bucket = aws_s3_bucket.s3_performance.id # Reference the bucket ID
#   policy = jsonencode({
#     Version = "2008-10-17"
#     Statement = [
#       {
#         Sid    = "PolicyForCloudFrontPrivateConten"
#         Effect = "Allow"
#         Principal = {
#           Service = "cloudfront.amazonaws.com" # Or specify specific AWS accounts or IAM users
#         }
#         Action = [
#           "s3:GetObject",
#         ]
#         Resource = [
#           "arn:aws:s3:::arn:aws:s3:::peformance-sinnapse/*" # Bucket ARN with wildcard
#         ]
#         condition = {
#             StringEquals = {
#               "AWS:SourceArn" = "arn:aws:cloudfront::940482430035:distribution/E5M2H6QNU3FEJ"
#             }
#         }
#       }
#     ]
#   })
# }
