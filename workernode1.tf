resource "aws_instance" "workernode1" {
  ami = "ami-4934ea31"
  instance_type = "m4.xlarge"
  security_groups = ["${aws_security_group.swarm_sg.id}"]
  subnet_id = "${aws_subnet.mngmt_public_subnet.id}"
  #vpc_security_group_ids = ["sg-c05f4ba8"]
  connection {
    host = "${self.public_ip}"
    type     = "ssh"
    user     = "smadmin"
    password = "M3sh@dmin!"
  }
  provisioner "remote-exec" {
    inline = [
	"echo 'HOSTNAME CHANGE'",
	"echo ${var.workernode1hostname} > /home/smadmin/workernode1hostname",
      "echo 'The actual hostname is...'",
      "hostname",
      "hostnamectl",
      "echo 'Changing the hostname....'",
      "sudo hostnamectl set-hostname $(cat /home/smadmin/workernode1hostname)",
      "echo 'Rebooting the machine....'",
      "echo 'The changed hostname......'",
      "hostname",
  "docker network create --subnet=10.10.0.0/16 --gateway 10.10.0.1 -o com.docker.network.bridge.enable_icc=false -o com.docker.network.bridge.name=docker_gwbridge -o com.docker.network.bridge.enable_ip_masquerade=true docker_gwbridge",
  "sudo firewall-cmd --permanent --zone=trusted --change-interface=docker_gwbridge",
  "sudo firewall-cmd --zone=public --permanent --add-masquerade",
  "sudo firewall-cmd --zone=public --permanent --add-port=2377/tcp",
  "sudo firewall-cmd --zone=public --permanent --add-port=2376/tcp",
  "sudo firewall-cmd --zone=public --permanent --add-port=7946/tcp",
  "sudo firewall-cmd --zone=public --permanent --add-port=7946/udp",
  "sudo firewall-cmd --zone=public --permanent --add-port=4789/udp",
  "sudo firewall-cmd --zone=trusted --permanent --add-masquerade",
  "sudo firewall-cmd --zone=trusted --permanent --add-port=2377/tcp",
  "sudo firewall-cmd --zone=trusted --permanent --add-port=2376/tcp",
  "sudo firewall-cmd --zone=trusted --permanent --add-port=7946/tcp",
  "sudo firewall-cmd --zone=trusted --permanent --add-port=7946/udp",
  "sudo firewall-cmd --zone=trusted --permanent --add-port=4789/udp",
  "sudo firewall-cmd --reload",
  "sudo systemctl stop docker",
  "sudo systemctl start docker",
  "sudo sshpass -p 'M3sh@dmin!' scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null smadmin@${aws_instance.masternode.private_ip}:/home/smadmin/token /home/smadmin/",
  
  "sudo sshpass -p 'M3sh@dmin!' scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null smadmin@${aws_instance.masternode.private_ip}:/home/smadmin/agility-images-11.0.1.tar.gz /home/smadmin/",
  "sudo sshpass -p 'M3sh@dmin!' scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null smadmin@${aws_instance.masternode.private_ip}:/home/smadmin/cloud-plugin-images-11.0.1.tar.gz /home/smadmin/",
  
  
  "sudo docker swarm join --token $(cat /home/smadmin/token) ${aws_instance.masternode.private_ip}:2377",
  
  "docker image load -i agility-images-11.0.1.tar.gz",
  "docker image load -i cloud-plugin-images-11.0.1.tar.gz",
  "docker images",
    ]
  }
  tags = { 
    Name = "11.0.1-swarm-worker-1"
  }
}