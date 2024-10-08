# -- 本脚本用途：更新域名goip.it ( 网站 www.goip.de )


# 要更新的目标域名
$DOMAIN_NAME = "xxxxxx.goip.it"
# 网站 goip.de 的域名账号（登录后，为此域名产生的专用账号）：
$USERNAME = "xxxxx"
# 域名密码：
$PASSWORD = "xxxxxxxxx"
# IPv6 的域名查询 DNS：
$DNS_Server = "2610:a1:1019::1"

# 从网址中取得本机当前公网 IPv6 地址
$GETIP_URL = "http://speed.neu6.edu.cn/getIP.php"

$IPV6_ADDR = curl $GETIP_URL

# 如果没有获得本机 ipv6 地址，就退出程序。
if ($IPV6_ADDR -notmatch ":" ) { 
    Write-Output "本机当前在公网中没有ipv6地址，本次更新退出。"
    exit 0 
}

$DOMAIN_ADDR_STR=nslookup $DOMAIN_NAME

$OLD_ADDR=$DOMAIN_ADDR_STR.split("\n")[4].split()[2]

$UPDATA_URL="https://www.goip.de/setip?username=$USERNAME&password=$PASSWORD&subdomain=$DOMAIN_NAME&ip6=$IPV6_ADDR"

# Write-Output $UPDATA_URL

Write-Output ("OLD_IP   = " + $OLD_ADDR)
Write-Output ("IPV6_ADDR= " + $IPV6_ADDR) 
Write-Output ("DOMAIN_NAME= " + $DOMAIN_NAME )

if ( $OLD_ADDR -eq $IPV6_ADDR ) {
    Write-Output "IP地址没有改变，无需更新。The IP address has not changed and no update is required "
    exit 0
       }
else {
    Write-Output "现在更新域名 IP 地址 Now update the domain IP address "$IPV6_ADDR
    # Write-Output $UPDATA_URL
    curl $UPDATA_URL
}