output "domain-name-master"{
    value=aws_instance.master.public_dns
}

output "application-url-master"{
    value = "${aws_instance.master.public_dns}/index.php"
}

output "domain-name-client"{
    value=aws_instance.client.public_dns
}

output "application-url-client"{
    value = "${aws_instance.client.public_dns}/index.php"
}