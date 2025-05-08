# resource "aws_api_gateway_rest_api" "api_sinnapse" {
#   body = jsonencode({
#     openapi = "3.0.1"
#     info = {
#       title   = "sinnapse"
#       version = "1.0"
#     }
#     paths = {
#       "/path1" = {
#         get = {
#           x-amazon-apigateway-integration = {
#             httpMethod           = "GET"
#             payloadFormatVersion = "1.0"
#             type                 = "HTTP_PROXY"
#             uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
#           }
#         }
#       }
#     }
#   })

#   name = "api-sinnapse"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_deployment" "api_deploy" {
#   rest_api_id = aws_api_gateway_rest_api.api_sinnapse.id

#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_sinnapse.body))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "api_stage" {
#   deployment_id = aws_api_gateway_deployment.api_deploy.id
#   rest_api_id   = aws_api_gateway_rest_api.api_sinnapse.id
#   stage_name    = "api-sinnapse_stage"
# }