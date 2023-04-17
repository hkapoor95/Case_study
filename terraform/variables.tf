variable "postgres_db_name"{
    description = "Name of the Blackrock RDS instance"
}

variable "engine_version" {
    description = "Version of the Balckrock Database engine"
}

variable "instance_type"{
    description = "Type of instance to be used for Blackrock RDS insatnce"
}

variable "storage_size"{
    description = "Blackrock RDS storage size in GBs"
}

variable "storage_size"{
    description = "Blackrock RDS storage type"
}

variable "master_username"{
    description = "Provide master_username to login into Blackrock RDS insatnce"
}

variable "master_password"{
    description = "Provide master_password to login into Blackrock RDS insatnce"
}

variable "subnet_group_name"{
    description = "Name of the attached Blackrock subnet group"
}

variable "security_group_ids"{
    description = "Show the list type of securty group ids attached with Balckrock RDS instance"
    type        = list(String)
}

variable "retention_policy_backup"{
    description = "Number of days the automated backup retention"
}

variable "tags" {
    description = "Blackrock RDS instance Tags"
    type        = map(string)
}