#Resource to create third instance for the Agility Docker Swarm and initiate the Agility Installation.
resource "aws_instance" "workernode2" {
  depends_on = ["aws_instance.workernode1"]
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
    "plugin_flag=${var.plugin_install}",
	"echo 'HOSTNAME CHANGE'",
	"echo ${var.workernode2hostname} > /home/smadmin/workernode2hostname",
      "echo 'The actual hostname is...'",
      "hostname",
      "hostnamectl",
      "echo 'Changing the hostname....'",
      "sudo hostnamectl set-hostname $(cat /home/smadmin/workernode2hostname)",
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
  "sudo curl -k -u <ftp_username>:<ftp_password> 'https://ftp-aus.servicemesh.com/csc/solutions/11.0/agility-cli-11.0.1.tar.gz' -o /home/smadmin/agility-cli-11.0.1.tar.gz",
  "sudo docker swarm join --token $(cat /home/smadmin/token) ${aws_instance.masternode.private_ip}:2377",
  "docker image load -i agility-images-11.0.1.tar.gz",
  "docker image load -i cloud-plugin-images-11.0.1.tar.gz",
  "docker images",
  "docker node ls",
  "sudo tar -xvzf /home/smadmin/agility-cli-11.0.1.tar.gz",
  "echo 'Setting up the Scaling Process.'",
  "sudo /home/smadmin/swarm-scale 3",
  "echo 'Agility containers scaled to 3 in the 3 nodes.'",
  "echo 'Checking for the Running Docker Service'",
  "sudo systemctl status docker",
  "echo 'Deploying the Agility containers in the 3 nodes.'",
  "sudo /home/smadmin/swarm-start",
  "if [ $plugin_flag=='yes' ]; then while (docker ps | grep -i 'starting');do echo 'Waiting for the Agility Service to Start';sleep 1m; done; echo 'Setting Up the Cloud Plugin Installation'; while (docker ps | grep -i 'unhealthy');do sudo /home/smadmin/swarm-stop;sudo /home/smadmin/swarm-scale 3;sudo /home/smadmin/swarm-start; done; sudo sed -i -e 's/^#/ /g' agility_swarm.yml; docker stack deploy -c agility_swarm.yml agility; docker stack deploy -c cloud_plugin.yml agility; fi"
    ]
  }
  tags = { 
    Name = "11.0.1-swarm-worker-2"
  }
}
