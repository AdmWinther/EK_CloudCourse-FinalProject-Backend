terraform {
    required_providers {
        awscc = {
            source  = "hashicorp/awscc"
            version = "1.23.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

locals {
    availability_zone = "us-east-1a"  # Replace with your desired availability zone
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    FILE GENERATOR   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    DOCKER COMPOSE file gen.    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
module "file_gen_docker_compose_yml" {
    source                = "./modules/file_gen_docker_compose_yml"

    home-directory        = var.home-directory
    docker-network        = var.docker-network

    db-container-name     = var.db-container-name
    db-docker-image       = var.db-docker-image
    db_root_password      = var.db_root_password
    db_volume             = var.db_volume


    james-container-name  = var.james-container-name
    james-docker-image    = var.james-docker-image

    volume-initialize     = var.container_volume_initialize
    backend-container-name = var.backend-container-name
    backend-docker-image   = var.backend-docker-image
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    Database CONFIG FILEs GENERATOR    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
module "file_gen_database_init" {
    source = "./modules/file_gen_database_init"
    james_db_name = var.james_db_name
    james_db_username = var.james_db_username
    james_db_password = var.james_db_password
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    JAMES CONFIG FILEs GENERATOR    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
module "file_gen_james_database_properties" {
    source = "./modules/file_gen_james_database_properties"
    db_software           = var.db_software
    db-container-name     = var.db-container-name
    james_db_username           = var.james_db_username
    james_db_password           = var.james_db_password
    db_driver_className   = var.db_driver_className

    james_db_name         = var.james_db_name
}

module "file_gen_james_initialize_sh" {
    source = "./modules/file_gen_james_initialize_sh"
    admin_password          = var.admin_password
    awin_password           = var.awin_password
    john_password           = var.john_password
    jane_password           = var.jane_password
    test_password           = var.test_password
    demo_password           = var.demo_password
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    Security Grp.    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Create a security group to allow SSH, HTTP and HTTPS traffic
module "sec_grp_http_https_ssh_database" {
    source    = "./modules/sec_grp_http_https_ssh_database"
    my_vpc_id = var.my_vpc_id
}
module "sec_grp_mail_server" {
    source    = "./modules/sec_grp_mail_server"
    my_vpc_id = var.my_vpc_id
}

#______________________________        EC2          _____________________________
resource "aws_instance" "my_instance" {
    ami           = var.ec2-ami
    instance_type = "t2.micro"
    availability_zone = local.availability_zone

    # Associate the security group with the EC2 instance
    security_groups = [module.sec_grp_http_https_ssh_database.sec_grp_name, module.sec_grp_mail_server.sec_grp_name]
    key_name = "AccessKey"

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./AccessKey.pem")
        host = self.public_ip
    }
    #
    tags = {
        Name = "EK-CloudCourse-Project-EC2"
    }
    #
    #     # Copy some files into the EC2
    # //####################################################################################
    #     //Provisioning Database configuration files
    provisioner "file" {
        source      = "./james-database.properties"
        destination = "${var.home-directory}james-database.properties"
    }

    provisioner "file" {
        source      = "./jdbc.jar"
        destination = "/${var.home-directory}jdbc.jar"
    }
    provisioner "file" {
        source      = "./database_init.sql"
        destination = "/${var.home-directory}database_init.sql"
    }
    #     //####################################################################################
    #     //###################  Provisioning James Mail Server configuration files  ###########
    #     //####################################################################################
    provisioner "file" {
        source      = "./james_keystore_with_ssl_certificate_do_not_delete"
        destination = "/${var.home-directory}keystore"
    }

    provisioner "file" {
        source      = "./james_initialize.sh"
        destination = "/${var.home-directory}james_initialize.sh"
    }

    #     //####################################################################################
    #     //#####################  Provisioning the docker-compose.yml file  ###################
    #     //####################################################################################
    #
    provisioner "file" {
        source      = "./compose.yml"
        destination = "/${var.home-directory}compose.yml"
    }
    #
    #     //####################################################################################
    #     //####################################################################################
    #     //####################################################################################
    #     //EC2  User Data
    #
    user_data = <<-EOF
        #!/bin/bash
        set -x
        sudo ${var.package-installer} update -y

        #Installing and starting docker
        sudo ${var.package-installer} install -y docker
        sudo service docker start
        sudo usermod -a -G docker ec2-user
        sudo docker network create ${var.docker-network}

        #Installing docker-compose
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        #Make a directory to mount the containers volumes in it.
        sudo mkdir ${var.home-directory}volumes/
        sudo mkdir ${var.home-directory}volumes/${var.db_volume}

        #To avoid an error, first one should make the folder for database persistant data before give the ownership to mysql.
        #give the ownership fo the docker volume for database to mysql. MySQL needs it to write data into the volume.
        sudo chown -R 999:999 ${var.home-directory}volumes/${var.db_volume}/

        sudo -s

        #Run the containers
        #It is important to run this command with (-d) to detach, otherwise the rest of the initializers will not execute.
        docker-compose -f ${var.home-directory}compose.yml up -d
    EOF
}
#
#         #Make a directory to mount the containers volumes in it.
#         sudo mkdir ${var.home-directory}volumes/
#
#         #To avoid an error, first one should make the folder for database persistant data before give the ownership to mysql.
#         #give the ownership fo the docker volume for database to mysql. MySQL needs it to write data into the volume.
#         sudo chown -R 999:999 ${var.home-directory}volumes/${var.db_volume}/
#
#         #Run the containers
#         #It is important to run this command with (-d) to detach, otherwise the rest of the initializers will not execute.
#         docker-compose -f ${var.home-directory}compose.yml up -d
#
#         #Inform the user that you are waiting for the containers to be up and running
#         #The following initializers will be executed only if the server is being initialized.
#         ${!var.container_volume_initialize ? "#": ""}echo "Waiting for the containers to be up and running..."
#         ${!var.container_volume_initialize ? "#": ""}sleep 60
#
#         # Changing the ownership of the james initializers file and execing it.
#         ${!var.container_volume_initialize ? "#": ""}sudo chmod +x ${var.home-directory}james_initialize.sh
#         ${!var.container_volume_initialize ? "#": ""}sudo bash ${var.home-directory}james_initialize.sh
#
#          echo "Our mail server setup cmpleted."
#      EOF
# }
#
# resource "aws_volume_attachment" "Thusia_data" {
#   device_name = "/dev/sdf"  # The device name you want to use (e.g., /dev/sdf)
#   volume_id   = var.containers_volume_id  # Replace with your EBS volume ID
#   instance_id = aws_instance.my_instance.id
#   # Ensure that the attachment waits for the instance to be ready.
#   depends_on = [aws_instance.my_instance]
# }
#
resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.my_instance.id
  allocation_id = var.eip_association_id
}