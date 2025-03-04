resource "null_resource" "virtual_container" {
    provisioner "remote-exec" {
        connection {
            type="ssh"
            user="adminuser"
            private_key=file("~/.ssh/ssh_key")
            host= module.main.public_ip
        }
      inline = [ 
        "sudo apt-get update ",
        "sudo apt upgrade -y",
        "sudo apt install -y docker.io",
        "sudo docker run -d --name my-container -p 80:80 nginx",
       ]
    }
  
}