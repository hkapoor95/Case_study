postgres_db_name        = "balckrock-rds"
engine_version          = "12.5"
instance_type           = "t2.large"
storage_size            = 40
storage_size            = "gp2"
master_username         = "balckrock_user"
master_password         = "balckrock_password" #To pass it as vault we can declare as- vault("secret/backrock_rds/password")
subnet_group_name       = "subnet-cb1234ac"
security_group_ids      = ["sg-0dad2f3124b311427"]
retention_policy_backup = 10

tags = {
    Name        = "backrock-rds"
    Terraform   = true
    Environment = "dev"
}