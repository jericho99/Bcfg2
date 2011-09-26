#!/bin/bash

#Vider le contenue de /var/www/virtuals/ftp 
/bin/rm -rf /var/www/virtuals/ftp/*

#Generer les mot de passe aleatoire
#Usager infoglobe
passwd_infoglobe=`/usr/bin/apg -n 1`
/bin/echo "infoglobe : $passwd_infoglobe <br>" > /home/gestion/passwd
/bin/echo "use ftp; update vsftpd set user_passwd=ENCRYPT('$passwd_infoglobe') where user_name='infoglobe';" > /root/passwd.sql
/usr/bin/htpasswd -b /var/www/passwords/htpasswd_ftpinfoglobe infoglobe $passwd_infoglobe

#Usager client
passwd_client=`/usr/bin/apg -n 1`
/bin/echo client : $passwd_client >> /home/gestion/passwd
/bin/echo "use ftp; update vsftpd set user_passwd=ENCRYPT('$passwd_client') where user_name='client';" >> /root/passwd.sql
/usr/bin/mysql -u ftp -pgo2Ic7go < /root/passwd.sql
/usr/bin/htpasswd -b /var/www/passwords/htpasswd_ftpinfoglobe client $passwd_client

#Effacer /root/passwd.sql
/bin/rm -rf /root/passwd.sql


