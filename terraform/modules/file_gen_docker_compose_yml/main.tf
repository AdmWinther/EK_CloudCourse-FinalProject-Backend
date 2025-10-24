variable "home-directory" {}
#Docker related variables
variable "docker-network" {}

#Database Container related variables
variable "db-container-name" {}
variable "db-docker-image" {}
variable "db_root_password" {}
variable "db_volume" {}

#James Server related variables
variable "james-container-name" {}
variable "james-docker-image" {}


#EBC volume related variables
variable "volume-initialize" {
  type = bool
}

resource "local_file" "docker_compose_yml" {
  filename = "compose.yml"
  content  = <<EOF

name: ek_cloud

services:
  mariadb:
    image: ${var.db-docker-image}
    container_name: ${var.db-container-name}
    restart: always
    volumes:
      - ${var.home-directory}volumes/${var.db_volume}:/var/lib/mysql
      #this line needs to be executed just the first time. It is needed for making the users and databases.
      ${!var.volume-initialize? "#": ""}- ${var.home-directory}database_init.sql:/docker-entrypoint-initdb.d/database_init.sql
    ports:
      - "3306:3306"
    environment:
      ALLOW_EMPTY_PASSWORD: yes
      MARIADB_ROOT_PASSWORD: ${var.db_root_password}
    networks:
      - ${var.docker-network}

  james:
    image: ${var.james-docker-image}
    container_name: ${var.james-container-name}
    restart: always
    volumes:
      - type: bind
        source: ${var.home-directory}james-database.properties
        target: /root/conf/james-database.properties

      - type: bind
        source: ${var.home-directory}jdbc.jar
        target: /root/libs/jdbc.jar

      - type: bind
        source: ${var.home-directory}keystore
        target: /root/conf/keystore

    ports:
      - "25:25"
      - "110:110"
      - "143:143"
      - "465:465"
      - "587:587"
      - "993:993"
      #Port 8000 is used for the REST API of James
      - "8000:8000"

    networks:
      - ${var.docker-network}
    depends_on:
      - mariadb

networks:
  ${var.docker-network}:

EOF
}