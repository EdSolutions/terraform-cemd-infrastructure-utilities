output "certificate_arn" {
  value = aws_acm_certificate.cloudfront_cert.arn
  description = "ARN of the ACM certificate for CloudFront"
}