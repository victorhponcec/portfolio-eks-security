resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "codebuild_logs" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_codebuild_project" "build_image" {
  name          = "build-image"
  service_role  = aws_iam_role.codebuild_role.arn
  source {
    type      = "GITHUB"
    location  = "https://github.com/victorhponcec/container-app-sec.git"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true  # Required for Docker
    environment_variable {
      name = "ECR_REPO"
      value = aws_ecr_repository.app.repository_url
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}
#to-do
#integrate aws codebuild start-build --project-name build-image in terraform workflow, so it executes before the k8s deployment

#aws codebuild start-build --project-name build-image
#aws codebuild batch-get-builds --ids build-image:a53d82fb-6fae-43c5-b11a-c0a4e9a79ce3