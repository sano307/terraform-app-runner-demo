resource "aws_apprunner_service" "demo_python" {
  service_name = "demo-python"

  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.demo_python.arn
    }

    code_repository {
      code_configuration {
        code_configuration_values {
          runtime       = "PYTHON_3"
          build_command = "pipenv install"
          start_command = "pipenv run uvicorn main:app"
          port          = "8000"
          runtime_environment_variables = {
            GREETINGS = "Hello, App Runner!"
          }
        }
        configuration_source = "API"
      }
      repository_url = "https://github.com/sano307/terraform-app-runner-demo/src"
      source_code_version {
        type  = "BRANCH"
        value = "main"
      }
    }
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.demo_python.arn

  health_check_configuration {
    healthy_threshold = "3"
    interval = "3"
    path = "/hc"
    protocol = "TCP"
    timeout = "2"
    unhealthy_threshold = "3"
  }
}

resource "aws_apprunner_connection" "demo_python" {
  connection_name = "demo-python"
  provider_type   = "GITHUB"
}

resource "aws_apprunner_auto_scaling_configuration_version" "demo_python" {
  auto_scaling_configuration_name = "demo-python"
  max_concurrency                 = 10
  max_size                        = 3
  min_size                        = 1
}
