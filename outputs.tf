output "webserver_instance_id" {
  value = aws_instance.my_ubuntu.id
}

output "WebServer_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}
