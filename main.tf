module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.repository_name
  environment     = var.environment
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  environment       = var.environment
  app_port          = var.app_port
  health_check_path = var.health_check_path
}

module "ec2_asg" {
  source = "./modules/ec2_asg"

  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  environment           = var.environment
  repository_url        = module.ecr.repository_url
  app_port              = var.app_port
  target_group_arn      = module.loadbalancer.target_group_arn
  alb_security_group_id = module.loadbalancer.alb_security_group_id
  instance_type         = var.instance_type
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  aws_region            = var.aws_region
}

module "rds" {
  source = "./modules/rds"

  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.vpc.private_subnet_ids
  environment              = var.environment
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  db_instance_class        = var.db_instance_class
  db_allocated_storage     = var.db_allocated_storage
  db_max_allocated_storage = var.db_max_allocated_storage
  db_engine                = var.db_engine
  db_engine_version        = var.db_engine_version
  db_family                = var.db_family
  db_major_engine_version  = var.db_major_engine_version
  db_port                  = var.db_port
  ecs_security_group_id    = module.ec2_asg.ec2_security_group_id
}
