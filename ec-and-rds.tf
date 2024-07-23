resource "aws_instance" "WDP" {
  ami = "ami-0e872aee57663ae2d"
  instance_type = "t2.micro"
  key_name = "WordpressKey"
  subnet_id = aws_subnet.public1.id
  security_groups = [aws_security_group.allow-ssh.id]
  associate_public_ip_address = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  subnet_ids = [aws_subnet.private1.id,aws_subnet.private2.id]
}

resource "aws_db_instance" "main" {
  allocated_storage      = 10
  db_name                = "WordpressDB"  
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "Priyansh"
  password               = "Priyansh"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Name = "RDS_instance"
  }
}


resource "aws_security_group" "rds_security_group" {
  name = "RDS-Security-Group"
  description = "Security Group for RDS instance"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.100.0.0/16"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
