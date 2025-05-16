output "domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}