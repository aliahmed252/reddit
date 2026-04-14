#!/bin/bash

# 1. Update and Install Dependencies
sudo apt update -y
sudo apt install -y wget apt-transport-https gnupg lsb-release

# 2. Install Java 17 (Still the most stable for Jenkins, or use 21)
# سنستخدم Java 17 لأنها الأكثر توافقاً مع إضافات Jenkins حالياً
sudo mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install temurin-17-jdk -y

# 3. Install Jenkins (Latest LTS)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7198F4B714ABFC68
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 4. Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
# بدلاً من 777، سنغير الملكية لتكون أكثر أماناً
sudo chown root:docker /var/run/docker.sock

# 5. Run SonarQube Container
# ملاحظة: تم استخدام الإصدار lts-community لضمان الاستقرار
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# 6. Install Trivy (Latest Version)
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y

# طباعة النتائج للتأكد
echo "-------------------------------------------"
java --version
jenkins --version
docker --version
trivy --version
echo "Jenkins is running on port 8080"
echo "SonarQube is running on port 9000"
