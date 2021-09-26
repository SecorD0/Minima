#!/bin/bash
# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script installs and updates Minima node"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h, --help  show the help page"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/Minima/blob/main/multi_tool.sh - script URL"
		echo -e "https://t.me/letskynode — node Community"
		echo
		return 0
		;;
	*|--)
		break
		;;
	esac
done
# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
# Actions
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jre-headless -y
printf_n "${C_LGn}Node installation...${RES}"
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
printf_n "${C_LGn}Done!${RES}\n"
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
printf_n "
The node was ${C_LGn}started${RES}.

\tv ${C_LGn}Useful commands${RES} v

To view the node status: ${C_LGn}systemctl status minima${RES}
To view the node log: ${C_LGn}minima_log${RES}
To restart the node: ${C_LGn}systemctl restart minima${RES}
"
