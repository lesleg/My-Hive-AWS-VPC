region                     = "eu-west-2"
certificate_arn            = "arn:aws:acm:eu-west-2:183989794756:certificate/5f850bce-90c2-4c49-8236-ac1713848e6f"
route53_hosted_zone_name   = "lesleg.click"


rds_instance_identifier    = "terraform-mysql"
database_name              = "DBlesleg"
database_user              = "terraform"

s3_bucket_name             = "springboot-s3-example"

amis = {
  "eu-west-2"              = "ami-0648ea225c13e0729"
}

instance_type              = "t2.micro"

autoscaling_group_min_size = 3
autoscaling_group_max_size = 5