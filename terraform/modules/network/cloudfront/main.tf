# Edge delivery pattern — CloudFront distribution (origin + optional OAC).

resource "aws_cloudfront_origin_access_control" "this" {
  count = var.create_oac ? 1 : 0

  name                              = "${var.name}-oac"
  description                       = "OAC for ${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases
  web_acl_id          = var.web_acl_id
  is_ipv6_enabled     = var.is_ipv6_enabled
  tags                = merge(var.tags, { Name = var.name })

  origin {
    domain_name              = var.origin_domain_name
    origin_id                = var.origin_id
    origin_access_control_id = var.create_oac ? aws_cloudfront_origin_access_control.this[0].id : var.origin_access_control_id

    dynamic "custom_origin_config" {
      for_each = var.origin_type == "custom" ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = var.origin_protocol_policy
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
  }
}
