module "vpc" {
  source              = "./modules/vpc"
  environment         = "Test"
  cidr_block          = "10.0.0.0/16"
  public_subnets      = ["10.0.0.0/22" ]
  application_subnets = ["10.0.4.0/22" ]
  database_subnets    = ["10.0.8.0/22" ]
  serverless_subnets  = ["10.0.12.0/22"]
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  cidr_blocks         = [module.vpc.cidr_block]
  launch_subnet_ids   = module.vpc.application_subnet_ids
  public_key          = "ssh-rsa PUT_YOUR_KEY_HERE"
}

module "ad-forest" {
  source              = "./modules/ad-forest"
  instance_ids        = module.ec2.instance_ids
}
