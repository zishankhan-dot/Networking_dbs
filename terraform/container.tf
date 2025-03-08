
// need to not use this cuz terraform don't maintain state file for configurations //example  container --will use ansible for this for configuration 


/* resource "null_resource" "virtual_container" {
    provisioner "remote-exec" {
        connection {
            type="ssh"
            user="adminuser"
            private_key=file("~/.ssh/ssh_key")
            host= module.main.public_ip
        }
    provisioner "file"{
            source=""
            path=""
            connection{
                type="ssh"
                user="adminuser"
                private_key=file("~/.shh/ssh_key")
                host=module.main.public_ip
            }
        }
      inline = [ 
        "sudo apt-get update ",
        "sudo apt upgrade -y",
        "sudo apt install -y docker.io",
        "sudo docker run -d --name my-container -p 80:80 nginx",
       ]
    }
  
}*/

