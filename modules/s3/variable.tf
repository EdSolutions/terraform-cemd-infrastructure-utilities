variable "bucket_name" {
  type = string
}

variable "public_access_block_config" {
  type = map(bool)
  default = {
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  }
}

variable "enable_website_redirect" {
  type    = bool
  default = false
}


variable "enable_website_index" {
  type    = bool
  default = false
}


variable "index_document_suffix" {
  type    = string
  default = "index.html"
}

variable "bucket_policy_json" {
  type        = string
  default     = ""
  description = "Optional bucket policy JSON. If empty, no policy is applied."
}

variable "redirect_target" {
  type = string
  default = ""
}


variable "enable_redirect" {
  type    = bool
  default = true
}