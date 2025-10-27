variable "my_vpc_id" {
  description = "AWS account VPC_ID"
  type        = string
}

resource "aws_security_group" "http_https_ssh_database" {
  name        = "http_https_ssh_database_sg"
  description = "Allow SSH and HTTP and HTTPS traffic"
  vpc_id      = var.my_vpc_id # Replace with your VPC ID

  # Inbound rule for HTTP traffic but there is not web server in James, so this rule is not needed.
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # For the Apache James server REST APIs, we need to allow port 8000
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    #allow HTTP alternative port 8080 for backend server. the container "back" uses this port.
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  #allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow Mariadb port, But we do not need to be able to access the database from outside.
  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
