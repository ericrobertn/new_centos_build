useradd %username%
passwd  %username%
%password%
%password%
echo '%username%  ALL=(ALL:ALL) ALL' >> /etc/sudoers
sed -i '48s/.*/PermitRootLogin no/' /etc/ssh/sshd_config
yum -y update && yum -y install epel-release
yum -y install fail2ban
yum -y install sendmail
systemctl start fail2ban
systemctl enable fail2ban
systemctl start sendmail
systemctl enable sendmail
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
mv /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
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
systemctl restart fail2ban
systemctl restart sshd
