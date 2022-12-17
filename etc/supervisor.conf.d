[program:gitea]
command=/home/lumin/gitea/gitea-1.6.1-linux-amd64
directory=/home/lumin/gitea
user=lumin
environment=HOME="/home/lumin/",USER="lumin",PATH="/usr/bin:/bin:/usr/local/games:/usr/games"                                                                               
[program:ipv6]
command=/sbin/dhclient -6 enp5s0 -d
directory=/
user=root
