#!/bin/bash
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jre-headless -y
echo -e '\e[40m\e[92mNode installation...\e[0m'
mkdir $HOME/minima
sudo systemctl stop minimad
sudo systemctl disable minimad
wget -qO $HOME/minima/minima.jar.new https://github.com/minima-global/Minima/raw/master/jar/minima.jar
mv $HOME/minima/minima.jar $HOME/minima/minima.jar.bk
mv $HOME/minima/minima.jar.new $HOME/minima/minima.jar
sudo tee <<EOF >/dev/null /etc/systemd/system/minimad.service
[Unit]
Description=Minima Node
After=network-online.target

[Service]
User=$USER
ExecStart=`which java` -Xmx1G -jar $HOME/minima/minima.jar
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable minimad
sudo systemctl restart minimad
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) "minima_log" "sudo journalctl -f -n 100 -u minimad" true
echo -e '\e[40m\e[92mDone!\e[0m'
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e '\nThe node was \e[40m\e[92mstarted\e[0m!\n'
echo -e '\tv \e[40m\e[92mUseful commands\e[0m v\n'
echo -e 'To view the node status: \e[40m\e[92msystemctl status minimad\e[0m'
echo -e 'To view the node log: \e[40m\e[92mminima_log\e[0m'
echo -e 'To restart the node: \e[40m\e[92msystemctl restart minimad\e[0m\n'
