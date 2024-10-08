#!/bin/sh

# -- 更新动态域名 goip.it ，IPv6 版本 --

# 获取 IP 的网址

DOMAIN_NAME=xxxx.goip.it
USERNAME=xxxxxx
PASSWORD=xxxxxx
DNS_Server=2610:a1:1019::1

# 从网址中取得本机当前公网 IPv6 地址
GETIP_URL=http://speed.neu6.edu.cn/getIP.php
# IPV6_ADDR=`curl $GETIP_URL | awk '$0 ~ ":"  {print $0}'` 
IPV6_ADDR=`curl $GETIP_URL | awk '{print $0}'`

# IPV6_ADDR=`ip addr list  | grep inet6 | grep global | awk '{print $2}' | awk -F '/' '{print $1}'`

# GETIP_URL=http://myip6.ipip.net
# IPV6_ADDR=`curl $GETIP_URL | awk '{print $2}'| awk -F '：' '{print $2}' `

# 如果没有获得合法的 IPv6 地址，就退出
if [ -z $IPV6_ADDR ] ; then
	echo '本机当前在公网中没有ipv6地址，本次更新退出。'
	exit 0
fi

# 查询域名解析的 IP地址
# OLD_IP=`nslookup $DOMAIN_NAME | grep 'Address: 2' | awk -F 'Address: ' '{print $2}'`
OLD_IP=`nslookup $DOMAIN_NAME $DNS_Server | grep 'Address: [0-9]' | awk '{print $2}'`

# 如果为空，就设置该值为“no”
if [ -z $OLD_IP ] ; then OLD_IP=no ; fi

UPDATA_URL=`echo https://www.goip.de/setip?username=$USERNAME\&password=$PASSWORD\&subdomain=$DOMAIN_NAME\&ip6=$IPV6_ADDR`

# update URL ： https://www.goip.de/setip?username=BENUTZER&password=PASSWORT&subdomain=meinesubdomain.goip.de&ip6=xxxx

sleep 1s 
# echo $UPDATA_URL

echo "OLD_IP   ="$OLD_IP
echo "IPV6_ADDR="$IPV6_ADDR
echo "DOMAIN_NAME="$DOMAIN_NAME

if [ $OLD_IP != $IPV6_ADDR ] ; then 
    echo "现在更新域名 IP 地址 Now update the domain IP address "$IPV6_ADDR
    # echo $UPDATA_URL
    curl $UPDATA_URL
else
    echo "IP地址没有改变，无需更新。The IP address has not changed and no update is required "
fi
