variable "admin_password" {}
variable "awin_password" {}

variable "john_password" {}
variable "jane_password" {}
variable "test_password" {}
variable "demo_password" {}

resource "local_file" "james_initialize_sh" {
  filename = "james_initialize.sh"
  content = replace(<<EOF
echo "Initializing James server..."
docker exec james bash -c "james-cli AddDomain awin.dk"
docker exec james bash -c "james-cli AddUser admin@awin.dk ${var.admin_password}"
docker exec james bash -c "james-cli AddUser awin@awin.dk ${var.awin_password}"

docker exec james bash -c "james-cli AddUser john@awin.dk ${var.john_password}"
docker exec james bash -c "james-cli AddUser jane@awin.dk ${var.jane_password}"
docker exec james bash -c "james-cli AddUser test@awin.dk ${var.test_password}"
docker exec james bash -c "james-cli AddUser demo@awin.dk ${var.demo_password}"
EOF
, "\r", "")
}
