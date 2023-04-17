provider "aws"{
    region = "us-east-1"
}

resource "aws_vpc" "cidr" {
    cidr_block = "10.0.0.0/24"

    tags = {
        Name = "blackrock-vpc"
    }
}

resource "aws_subnet" "blackrock_subnet" {
    count       = 3
    vpc_id      = aws_vpc.cidr.vpc_id
    cidr_block  = "10.0.${count.index.index + 1}.0/24"

    tags = {
        Name = "blackrock-subnet-${count.index.index + 1}"
    }
}


resource "aws_db_instance" "postgres_rds" {
    name = var.postgres_db_name

    engine          = "postgressql"
    engine_version  = var.engine_version
    instance_type   = var.instance_type

    storage_size    = var.storage_size
    storage_type    = var.storage_type

    multi_az        = false

    master_username = var.master_username
    master_password = var.master_password

    subnet_group        = var.subnet_group_name
    security_group_ids  = [aws_security_group.rds_security.id]

    retention_policy_backup = var.retention_policy_backup

    tags    = var.tags
}

resource "aws_security_group" "rds_security" {
    name_prefix = "blackrock_sg"
    vpc_id      = "aws_vpc.cidr.id"

    ingress {
        from_port   = 2527
        to_port     = 2527
        protocol    = "tcp"
        cidr blocks = ["10.0.0.0/16"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr blocks = ["00.0.0.0/0"]
    }

    tags    = var.tags
}

resource "aws_key_pair" "blackrock_key" {
    key_name    = "blackrock-keypair"
    public_key  = ""
}

resource "aws_instance" "api_instance" {
    instance_name       = "blackrock_api"
    ami                 = "ami-007855ac798b5175e"
    instance_type       = "t2.large"
    vpc_security_group  = [aws_security_group.rds_security.id]
    subnet_id           = aws_subnet.blackrock_subnet[0].id
    key_name            = aws_key_pair.blackrock_key.key_name

    tags = var.tags

    provisioner "remote_exec" {
        inline  =[
            "ehco 'Blockrock API is running on ${aws_db_instance.postgres_rds.endpoint}'"
        ]            
        
    }
}