# see https://stackoverflow.com/questions/59756386/terraform-list-of-string-required-cidr-blocks-in-aws

availability_zones = ["eu-central-1a", "eu-central-1b"]
public_subnets = [ "10.10.100.0/24", "10.10.110.0/24" ]
private_subnets = [ "10.10.0.0/24", "10.10.10.0/24" ]
