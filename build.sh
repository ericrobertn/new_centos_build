useradd %username%
passwd  %username%

###################################################
###################################################
###########          Eric Neudorfer 07252017
###########   :Bash file to config basic centos box 
###########     Adds new sudo user / Disables root ssh/ installs fail2ban
###########       TO DO: Build optiosn at end (Docker/ Word Press/ Other

%password%
%password%
echo '%username%  ALL=(ALL:ALL) ALL' >> /etc/sudoers
sed -i '48s/.*/PermitRootLogin no/' /etc/ssh/sshd_config
yum -y update && yum -y install epel-release
yum -y install fail2ban
yum -y install sendmail
yum -y install git

systemctl start fail2ban
systemctl enable fail2ban
systemctl start sendmail
systemctl enable sendmail
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
mv /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
######## WRITE TO JAIL.LOCAL
echo "
[DEFAULT]
ignoreip = 127.0.0.1 
bantime  = 3600
banaction = iptables-multiport
findtime  = 600
Maxretry = 3
[sshd]
enabled = true
destemail = eneudorfer@gmail.com
sendername = Fail2Ban
mta = sendmail" >>  /etc/fail2ban/jail.conf
######## FINISH WRITE TO JAIL.LOCAL
systemctl restart fail2ban
systemctl restart sshd


########################################################################
########################################################################
###########    INSTALL DOCKER AND ADD MYSQL/WORDPRESS CONTAINERS

curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker %username%
systemctl enable docker
systemctl start docker
sudo yum install -y python-pip
pip install --upgrade pip
sudo pip install docker-compose
sudo yum upgrade python*
