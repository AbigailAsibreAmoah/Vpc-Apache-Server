# User Data Script - references external shell script
locals {
  user_data = base64encode(file("${path.module}/userdata.sh"))
}