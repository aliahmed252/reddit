resource "aws_instance" "web" {
  ami                    = "ami-0ec10929233384c7f" #change ami id for different region
  instance_type          = "m7i-flex.large"
  subnet_id              = "subnet-0f80bfa691f99146d"
  key_name               = "promethus-course" #change key name as per your setup
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Jenkins-SonarQube"
  }

  root_block_device {
    volume_size = 40
  }
}

