#!/bin/sh
extvideo1=eth5
extvideo2=eth4
ipvideo1=69.70.231.230
ipvideo2=69.70.199.18
ipvideo3=69.70.199.19
ipvideo4=69.70.199.20
ipvideo5=69.70.199.21
iphades=10.10.200.11
ipsshsrv=10.10.200.12
ipvmsrv=10.10.0.105
ipsvn=10.10.0.51
ipwebsrv=10.10.0.107
intlan=eth0      ### 10.10.1.0 (LAN)
intlab=eth1      ### 10.10.2.0 (LAB)
intphone=eth2	 ### 10.10.50.0 (phone)
intdmz=eth3      ### 10.10.200.0 (DMZ)

#### Creation des tables
/sbin/iptables -N icmp-policy
/sbin/iptables -N int-policy
/sbin/iptables -N ext-policy


	#### MANGLE ####
/sbin/iptables -t mangle -A PREROUTING -i eth4 -m state --state NEW -j CONNMARK --set-mark 0x1
/sbin/iptables -t mangle -A PREROUTING -i eth3 -j CONNMARK --restore-mark
/sbin/iptables -t mangle -A PREROUTING -i eth0 -s 10.10.0.107 -j CONNMARK --restore-mark
/sbin/iptables -t mangle -A PREROUTING -s 10.10.0.39 -i eth0 -p udp -m udp --dport 4569 -j MARK --set-mark 0x1
	

	#### NAT ####
### FORWARD 25 SMTP (Externe vers interne)
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 25 -j DNAT --to-destination $iphades:25
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 25 -j DNAT --to-destination $iphades:25

### FORWARD 25 ANY SMTP (LAN vers Hades)
/sbin/iptables -t nat -A PREROUTING -i $intlan -p tcp --dport 25 -j DNAT --to $iphades:25

### FORWARD 80 HTTP
### Webmail Sogo redirige le port 80 vers 443
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 80 -j DNAT --to-destination $iphades:80
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 80 -j DNAT --to-destination $iphades:80
### Funambole
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 8080 -j DNAT --to-destination $iphades:8080

### FORWARD 443 HTTPS
### Webmail Sogo
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 443 -j DNAT --to-destination $iphades:443
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 443 -j DNAT --to-destination $iphades:443
### Plugin www.infoglobe.ca vers Igerp
/sbin/iptables -t nat -A PREROUTING -d $ipvideo5 -s 67.207.145.62 -p tcp -m tcp --dport 443 -j DNAT --to-destination $ipwebsrv:443

### FORWARD 443 SSHSRV
/sbin/iptables -t nat -A PREROUTING -d $ipvideo4 -p tcp -m tcp --dport 443 -j DNAT --to-destination $ipsshsrv:443

### FORWARD 993 IMAPS
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 993 -j DNAT --to-destination $iphades:993
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 993 -j DNAT --to-destination $iphades:993
/sbin/iptables -t nat -A PREROUTING -i $intlan -p tcp -d $ipvideo2 --dport 993 -j DNAT --to-destination $iphades:993

### FORWARD 443-1194 OPENVPN
/sbin/iptables -t nat -A PREROUTING -d $ipvideo3 -p udp -m udp --dport 443 -j DNAT --to-destination $iphades:1194
/sbin/iptables -t nat -A PREROUTING -d $ipvideo3 -p udp -m udp --dport 1194 -j DNAT --to-destination $iphades:1194

### FORWARD 5222 jabber
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p tcp -m tcp --dport 5222 -j DNAT --to-destination $iphades:5222
/sbin/iptables -t nat -A PREROUTING -d $ipvideo2 -p udp -m udp --dport 5222 -j DNAT --to-destination $iphades:5222

### FORWARD 6881-6889 et 51413 torrent vmsrv 
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6881 -j DNAT --to-destination $ipvmsrv:6881
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6882 -j DNAT --to-destination $ipvmsrv:6882
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6883 -j DNAT --to-destination $ipvmsrv:6883
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6884 -j DNAT --to-destination $ipvmsrv:6884
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6885 -j DNAT --to-destination $ipvmsrv:6885
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6886 -j DNAT --to-destination $ipvmsrv:6886
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6887 -j DNAT --to-destination $ipvmsrv:6887
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6888 -j DNAT --to-destination $ipvmsrv:6888
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 6889 -j DNAT --to-destination $ipvmsrv:6889
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 51413 -j DNAT --to-destination $ipvmsrv:51413

## SVN http 8099
/sbin/iptables -t nat -A PREROUTING -d $ipvideo1 -p tcp -m tcp --dport 8099 -j DNAT --to-destination $ipsvn:8099

### MASQUERADE
/sbin/iptables -t nat -A POSTROUTING -o eth4 -j SNAT --to-source $ipvideo2
/sbin/iptables -t nat -A POSTROUTING -o $extvideo1 -j MASQUERADE
/sbin/iptables -t nat -A POSTROUTING -o $extvideo2 -j MASQUERADE


	#### INPUT ####
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -i $extvideo1 -p icmp -j icmp-policy
/sbin/iptables -A INPUT -i $extvideo2 -p icmp -j icmp-policy
/sbin/iptables -A INPUT -i $intlan -p tcp -j int-policy
/sbin/iptables -A INPUT -i $intlan -p udp -j int-policy
/sbin/iptables -A INPUT -i $intlab -p tcp -j int-policy
/sbin/iptables -A INPUT -i $intlab -p udp -j int-policy
/sbin/iptables -A INPUT -i $intphone -p tcp -j int-policy
/sbin/iptables -A INPUT -i $intphone -p udp -j int-policy
/sbin/iptables -A INPUT -i $intdmz -p tcp -j int-policy
/sbin/iptables -A INPUT -i $intdmz -p udp -j int-policy
/sbin/iptables -A INPUT -i $extvideo1 -p tcp -j ext-policy
/sbin/iptables -A INPUT -i $extvideo1 -p udp -j ext-policy
/sbin/iptables -A INPUT -i $extvideo2 -p tcp -j ext-policy
/sbin/iptables -A INPUT -i $extvideo2 -p udp -j ext-policy

	#### FORWARD ####
/sbin/iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i $intlan -o $extvideo1 -j int-policy
/sbin/iptables -A FORWARD -i $intlan -o $extvideo2 -j int-policy
/sbin/iptables -A FORWARD -i $intlan -o $intdmz -j int-policy
/sbin/iptables -A FORWARD -i $intlab -o $extvideo1 -j int-policy
/sbin/iptables -A FORWARD -i $intlab -o $extvideo2 -j int-policy 
/sbin/iptables -A FORWARD -i $intphone -o $extvideo2 -j int-policy
/sbin/iptables -A FORWARD -i $intdmz -o $extvideo1 -j int-policy
/sbin/iptables -A FORWARD -i $intdmz -o $extvideo2 -j int-policy
/sbin/iptables -A FORWARD -j DROP


	#### icmp ####
/sbin/iptables -A icmp-policy -j DROP


	#### int-policy ####
/sbin/iptables -A int-policy -o $extvideo1 -j ACCEPT
/sbin/iptables -A int-policy -o $extvideo2 -j ACCEPT
/sbin/iptables -A int-policy -o $intdmz -j ACCEPT


	#### ext-policy ####
/sbin/iptables -A ext-policy -j DROP
