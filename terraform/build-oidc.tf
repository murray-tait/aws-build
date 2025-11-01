resource "aws_iam_role" "build" {
  name = "Github-Actions-OIDC-build"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Federated : "arn:aws:iam::973963482762:oidc-provider/token.actions.githubusercontent.com"
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:murray-tait/aws-build:*:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "build" {
  name = "Terraform_Backend-build"
  role = aws_iam_role.build.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::org.murraytait.experiment.build.terraform"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::org.murraytait.experiment.build.terraform/env/aws-build/terraform.tfstate",
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::org.murraytait.experiment.build.terraform/env/aws-build/terraform.tfstate.tflock",
        ]
      },
    ]
  })
}
