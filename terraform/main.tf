provider "aws" {
  version = "~> 2.0"

  region  = var.region
}

variable "region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

// CREATE SNS TOPIC
resource "aws_sns_topic" "requests" {
    name = "requests-topic"
    provisioner "local-exec" {
    command = "sh sns_subscription.sh"
    environment = {
      sns_arn = self.arn
      sns_emails = "rm340169@fiap.com.br"
    }
  }
}

// CREATE EMAIL TOPIC SUBSCRIPTION (IT DID NOT WORK)
# resource "aws_sns_topic_subscription" "requests_email_target" {
#   topic_arn = "${aws_sns_topic.requests.arn}"
#   protocol  = "email"
#   endpoint  = "rm340169@fiap.com.br"
# }

// CREATE SQS QUEUE AND CONNECT WITH DLQ
resource "aws_sqs_queue" "requests_queue" {
    name = "requests-queue"
    redrive_policy  = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.requests_dl_queue.arn}\",\"maxReceiveCount\":2}"
    visibility_timeout_seconds = 120

    tags = {
        Environment = "production"
    }
}

// CREATE DLQ 
resource "aws_sqs_queue" "requests_dl_queue" {
    name = "requests-dl-queue"
}

// CREATE SNS -> SQS TOPIC SUBSCRIPTION
resource "aws_sns_topic_subscription" "requests_sqs_target" {
    topic_arn = "${aws_sns_topic.requests.arn}"
    protocol  = "sqs"
    endpoint  = "${aws_sqs_queue.requests_queue.arn}"
}

// SQS POLICY
resource "aws_sqs_queue_policy" "requests_queue_policy" {
  queue_url = "${aws_sqs_queue.requests_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.requests_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.requests.arn}"
        }
      }
    }
  ]
}
POLICY
}

// BUCKET FOR STATE AND FILES
resource "aws_s3_bucket" "b" {
  bucket = "final-challenge-bucket"
  acl    = "private"

  tags = {
    Name        = "final-challenge-bucket"
    Environment = "admin"
  }
}
