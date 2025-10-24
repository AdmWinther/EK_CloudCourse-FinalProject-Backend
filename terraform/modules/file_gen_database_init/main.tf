variable "james_db_name" {}
variable "james_db_username" {}
variable "james_db_password" {}

resource "local_file" "database_init" {
  filename = "database_init.sql"
  content  = replace(<<EOF

-- Create databases and users for Apache James, set username and password
CREATE DATABASE ${var.james_db_name};
CREATE USER '${var.james_db_username}'@'%' IDENTIFIED BY '${var.james_db_password}';
GRANT ALL PRIVILEGES ON ${var.james_db_name}.* TO '${var.james_db_username}'@'%';

EOF
    , "\r", "")
}