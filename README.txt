LAB Vcenter Single Servere ARCHITECTURE:
===============================================
[root@student-linux-01 ~]# ls -lR /var/www
/var/www:
total 4
drwxr-xr-x. 2 root root      6 Jul 20 10:07 cgi-bin
drwxr-xr-x. 5 root root   4096 Aug 10 15:43 html
drwxr-s--x. 4 root apache   34 Aug  9 12:09 private_data

/var/www/cgi-bin:
total 0

/var/www/html:
total 68
-rw-r-----. 1 root apache   481 Aug 10 10:24 api.php
drwxr-x---. 2 root apache    80 Aug 10 10:52 config
-rw-r-----. 1 root apache   438 Aug  9 13:53 get_item.php
-rw-r-----. 1 root apache  4014 Aug 10 10:17 get_results.php
drwxr-xr-x. 2 root root      42 Aug  8 23:28 images
-rw-r--r--. 1 root root    2437 Aug  9 18:39 index.html
drwxr-xr-x. 2 root root      74 Aug 10 21:39 js
-rw-r-----. 1 root apache 11798 Aug 10 15:38 leaderboard.php
-rw-r-----. 1 root root    4847 Aug 10 08:18 leaderboardv1.php
-rw-r--r--. 1 root root    4382 Aug  9 13:52 login.html
-rw-r-----. 1 root apache  1010 Aug  9 12:26 login.php
-rwxr-xr-x. 1 root root   19557 Aug  9 18:41 style.css

/var/www/html/config:
total 16
-rw-r-----. 1 root apache 1039 Aug  9 09:50 config.php
-rw-r-----. 1 root apache 1615 Aug 10 10:52 functions.php
-rw-r-----. 1 root apache  524 Aug  9 09:53 ldap.php
-rw-r-----. 1 root apache  714 Aug  9 09:53 vcenter.php

/var/www/html/images:
total 44
-rw-r--r--. 1 root root 32806 Aug  8 23:28 image.png
-rw-r--r--. 1 root root  7198 Aug  8 23:28 linoop1.png

/var/www/html/js:
total 40
-rw-r--r--. 1 root root  6519 Aug  9 13:50 main.js
-rw-r--r--. 1 root root 17774 Aug 10 15:37 script_lab.js
-rw-r--r--. 1 root root 11820 Aug 10 10:05 script_leaderboard_v1.js

/var/www/private_data:
total 4
drwxr-s--x. 4 root apache 4096 Aug 12 21:08 lab
drwxrws---. 2 root apache   55 Aug 10 16:06 validator

/var/www/private_data/lab:
total 188
drwxr-xr-x. 2 root   root      52 Aug 10 18:44 extra
-rw-r-----. 1 apache apache  1426 Aug  9 17:32 file1
-rw-r-----. 1 root   apache  5376 Aug  8 23:28 lab101.json
-rw-r-----. 1 root   apache  7930 Aug  8 23:28 lab102.json
-rw-r-----. 1 root   apache  4376 Aug  8 23:28 lab103.json
-rw-r-----. 1 root   apache  3265 Aug  8 23:28 lab104.json
-rw-r-----. 1 root   apache  7026 Aug  8 23:28 lab105.json
-rw-r-----. 1 root   apache  4723 Aug  8 23:28 lab1.json
-rw-r-----. 1 root   apache 10906 Aug 12 19:48 lab201.json
-rw-r-----. 1 root   apache  5971 Aug  9 13:07 lab202.json
-rw-r-----. 1 root   apache  5871 Aug 11 11:20 lab203.json
-rw-r-----. 1 root   apache  4646 Aug  9 13:10 lab204.json
-rw-r-----. 1 root   apache 12474 Aug 10 17:55 lab205.json
-rw-r-----. 1 root   apache  8024 Aug 12 20:45 lab206.json
-rw-r-----. 1 root   apache  5482 Aug  8 23:28 lab2.json
-rw-r-----. 1 root   apache  1451 Aug 12 21:08 list.json
drwxrws---. 2 root   apache  4096 Aug 13 03:55 results
-rwxr-xr-x. 1 root   apache  1457 Aug 12 21:06 validate_lab.sh
-rwxr-xr-x. 1 root   apache 58557 Aug 12 21:04 validator-2026.sh

/var/www/private_data/lab/extra:
total 344
-rwxr-xr-x. 1 root root    245 Aug  9 19:10 myscript
-rw-r--r--. 1 root root 126788 Aug  9 19:40 newfile
-rw-r--r--. 1 root root 217322 Aug  9 19:19 onefile

/var/www/private_data/lab/results:
total 100
-rw-rw----. 1 root apache 30818 Aug 13 16:53 debug.log
-rw-rw----. 1 root apache   672 Aug 13 12:55 lab101_result.txt
-rw-rw----. 1 root apache   432 Aug 11 13:58 lab103_result.txt
-rw-rw----. 1 root apache   352 Aug 11 19:35 lab104_result.txt
-rw-rw----. 1 root apache  8432 Aug 13 16:53 lab201_result.txt
-rw-rw----. 1 root apache 10112 Aug 13 16:52 lab202_result.txt
-rw-rw----. 1 root apache  4032 Aug 13 06:38 lab203_result.txt
-rw-rw----. 1 root apache 13690 Aug 13 13:53 lab204_result.txt
-rw-rw----. 1 root apache  2112 Aug 13 10:14 lab205_result.txt
-rw-rw----. 1 root apache   272 Aug 12 21:12 lab206_result.txt
-rw-rw----. 1 root apache  1385 Aug  9 18:01 sorting.sh

/var/www/private_data/validator:
total 16
-rw-r-----. 1 root apache 6409 Aug 10 16:06 evaluate_lab.php
-rw-r-----. 1 root apache 6226 Aug  8 23:21 evaluate_quiz.php
===================================================================================
## Configurations:
=================================================================================
httpd and PHP dependencies Configuration:
========================================
[root@platform html]# httpd -M | grep php
[root@platform html]# apachectl -M | grep php
[root@platform html]# dnf install -y httpd php php-cli php-common php-fpm
[root@platform html]# systemctl enable --now php-fpm
[root@platform html]# systemctl enable --now httpd
[root@server101 ~]# firewall-cmd --add-port=8080/tcp --permanent
[root@server101 ~]# firewall-cmd –reload
[root@platform conf.d]# systemctl restart php-fpm
[root@platform conf.d]# systemctl restart httpd

SELINUX ISSUE RESOLVE:
[root@platform html]# chcon -R -t httpd_sys_rw_content_t /var/www/html
[root@platform html]# semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html(/.*)?"
[root@platform html]# restorecon -Rv /var/www/html
[root@platform html]# tail -f /var/log/httpd/error_log
[root@platform html]# setenforce 0
[root@platform html]# vi /etc/selinux/config
SELINUX=permissive
[root@platform html]# semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/private_data/lab/results(/.*)?"
[root@platform html]# restorecon -Rv /var/www/private_data/lab/results

[root@platform html]# setsebool -P httpd_can_network_connect on
[root@platform html]# ausearch -m AVC -ts recent | audit2why            ##### (To check issues)
Manual Test:
============
 [root@platform html]# curl -X POST \
-d "name=Saim" \
-d "quiz=quiz3" \
-d "total=20" \
-d "passed=18" \
-d "percent=90" \
http://127.0.0.1:8080/api.php?action=save_result

[root@platform html]# systemctl cat php-fpm
PrivateTmp=true
# /usr/lib/systemd/system/php-fpm.service
# It's not recommended to modify this file in-place, because it
# will be overwritten during upgrades.  If you want to customize,
# the best way is to use the "systemctl edit" command.

[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=notify
ExecStart=/usr/sbin/php-fpm --nodaemonize
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true
RuntimeDirectory=php-fpm
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target


REVERSE PROXY:
Architecture
Internet
    |
Public Apache Server
    |
Quiz VM (192.168.10.50)
Student accesses:
https://quiz.yourdomain.com
Apache forwards requests to:
http://192.168.10.50
________________________________________
Step 1: Install Required Modules
On the Apache reverse proxy server:
dnf install httpd -y
Verify modules:
httpd -M | egrep "proxy|ssl"
You should see:
proxy_module
proxy_http_module
ssl_module
If not, enable them in Apache configuration.
________________________________________
Step 2: Create Virtual Host
Example:
<VirtualHost *:80>

    ServerName quiz.yourdomain.com

    ProxyPreserveHost On

    ProxyPass / http://192.168.10.50/
    ProxyPassReverse / http://192.168.10.50/

</VirtualHost>
________________________________________
Step 3: Restart Apache
systemctl restart httpd
________________________________________
Step 4: Test
Browse:
http://quiz.yourdomain.com
You should see content from:
192.168.10.50
even though users never connect directly to it.
________________________________________
SSL Example
Once DNS is working:
dnf install certbot python3-certbot-apache -y
certbot --apache
Apache SSL virtual host:
<VirtualHost *:443>

    ServerName quiz.yourdomain.com

    SSLEngine On

    ProxyPreserveHost On

    ProxyPass / http://192.168.10.50/
    ProxyPassReverse / http://192.168.10.50/

</VirtualHost>
________________________________________
If Quiz Runs on Port 8080
ProxyPass / http://192.168.10.50:8080/
ProxyPassReverse / http://192.168.10.50:8080/
________________________________________
If You Want Multiple Quizzes
ProxyPass /quiz1/ http://192.168.10.50/
ProxyPassReverse /quiz1/ http://192.168.10.50/

ProxyPass /quiz2/ http://192.168.10.51/
ProxyPassReverse /quiz2/ http://192.168.10.51/
Students access:
https://quiz.yourdomain.com/quiz1
https://quiz.yourdomain.com/quiz2
________________________________________
One Important Requirement
The Apache reverse proxy server must be able to reach the Quiz VM's IP address.
For example:
curl http://192.168.10.50
from the Apache server should return the quiz page.
If the Apache server is:
•	In the same network → easy. 
•	On a cloud VPS → you'll need Tailscale, WireGuard, or a VPN between the VPS and your management network. 
For your training environment, a common setup is:
Internet
    |
Public Apache Reverse Proxy
(Public IP)
    |
Tailscale/WireGuard Tunnel
    |
Quiz VM (192.168.10.50)
This keeps the quiz VM private while making the quiz available to all students.
In the reverse proxy configuration, the proxy_pass points to the private IP address of your Quiz VM.
For example, if your Quiz VM is:
192.168.10.50
and Apache/Nginx on that VM serves the quiz on port 80, then:
location / {
    proxy_pass http://192.168.10.50;
}
or more explicitly:
location / {
    proxy_pass http://192.168.10.50:80;
}
________________________________________
Example Architecture
Internet
    |
Public Reverse Proxy
Public IP: 100.100.100.100
    |
Management Network
    |
Quiz VM
192.168.10.50
Student accesses:
https://quiz.mydomain.com
DNS resolves:
quiz.mydomain.com
    ↓
100.100.100.100
The reverse proxy receives the request and forwards it to:
192.168.10.50:80
The student never sees:
192.168.10.50
because it's a private address.
________________________________________
If Quiz Runs on Port 8080
Then:
location / {
    proxy_pass http://192.168.10.50:8080;
}
________________________________________
If You Have Multiple Quiz Servers
You can route by URL:
location /quiz1 {
    proxy_pass http://192.168.10.50;
}

location /quiz2 {
    proxy_pass http://192.168.10.51;
}
or by hostname:
server {
    server_name quiz1.mydomain.com;

    location / {
        proxy_pass http://192.168.10.50;
    }
}

server {
    server_name quiz2.mydomain.com;

    location / {
        proxy_pass http://192.168.10.51;
    }
}
________________________________________
