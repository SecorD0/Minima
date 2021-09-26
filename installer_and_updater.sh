#!/bin/bash
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jre-headless -y
echo -e '\e[40m\e[92mNode installation...\e[0m'
mkdir $HOME/minima
if [ -f "/etc/systemd/system/minimad.service" ]; then
	sudo systemctl stop minimad
	sudo systemctl disable minimad
	mv "/etc/systemd/system/minimad.service" "/etc/systemd/system/minima.service"
	sudo systemctl daemon-reload
fi
sudo systemctl stop minima
sudo systemctl disable minima
wget -qO $HOME/minima/minima.jar.new https://github.com/minima-global/Minima/raw/master/jar/minima.jar
mv $HOME/minima/minima.jar $HOME/minima/minima.jar.bk
mv $HOME/minima/minima.jar.new $HOME/minima/minima.jar
sudo tee <<EOF >/dev/null /etc/systemd/system/minima.service
[Unit]
Description=Minima Node
After=network-online.target

[Service]
User=$USER
ExecStart=`which java` -Xmx1G -jar $HOME/minima/minima.jar -daemon
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable minima
sudo systemctl restart minima
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) -n "minima_log" -v "sudo journalctl -f -n 100 -u minima" -a
echo -e '\e[40m\e[92mDone!\e[0m'
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e '\nThe node was \e[40m\e[92mstarted\e[0m!\n'
echo -e '\tv \e[40m\e[92mUseful commands\e[0m v\n'
echo -e 'To view the node status: \e[40m\e[92msystemctl status minima\e[0m'
echo -e 'To view the node log: \e[40m\e[92mminima_log\e[0m'
echo -e 'To restart the node: \e[40m\e[92msystemctl restart minima\e[0m\n'
