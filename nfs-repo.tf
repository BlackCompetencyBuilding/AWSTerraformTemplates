resource "aws_security_group" "Repo_SG" {
  name = "repo-security-group"
  description = "Security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.mgmt_vpc.id}"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "1"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["${var.management_vpc_cidr}"]
  }
  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "111"
    to_port   = "111"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "445"
    to_port   = "445"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "5985"
    to_port   = "5985"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "892"
    to_port   = "892"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
   ingress {
    from_port   = "222"
    to_port     = "222"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = "3389"
    to_port   = "3389"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
    ingress {
    from_port = "5986"
    to_port   = "5986"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags { 
    Name = "RepoSG" 
  }
}

#Resource to create NFS Repo Server.

resource "aws_instance" "NFS-Repo" {
    depends_on = ["aws_instance.masternode"],
    ami = "ami-6d67bd15"
    instance_type = "t2.medium"
    security_groups = ["${aws_security_group.Repo_SG.id}"]
    subnet_id = "${aws_subnet.mngmt_private_subnet.id}"
    #vpc_security_group_ids = ["sg-c05f4ba8"]
    connection {
    host = "${self.private_ip}"
    type     = "ssh"
    user     = "smadmin"
    password = "M3sh@dmin!"
    bastion_host = "${aws_instance.masternode.public_ip}"
    bastion_user = "smadmin"
    bastion_password = "M3sh@dmin!"
    bastion_port = 22
  }
  provisioner "remote-exec" {
    inline = [
    "sudo /etc/init.d/rpcbind start",
    "sudo /etc/init.d/nfs start",
    "mkdir repo",
    "sudo chmod 777 repo",
    "sudo echo '/home/smadmin/repo  *(rw,insecure,no_root_squash)' >>exports",
    "sudo mv exports /etc/exports",
    "sudo /usr/sbin/exportfs -a",
    "sudo /sbin/chkconfig --add nfs",
    "sudo /sbin/chkconfig nfs on",
    "sudo /sbin/chkconfig --add rpcbind",
    "sudo /sbin/chkconfig rpcbind on",
    "sudo service rpcbind restart",
    "sudo service nfs restart"
    ]
    }
}
