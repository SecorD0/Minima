#!/bin/bash
# Default variables
function="install"
ram="1G"
port="9001"

# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script performs many actions related to a Minima node"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help         show the help page"
		echo -e "  -r,  --ram VALUE    limitation of memory usage. E.g. '${C_LGn}512m${RES}', '${C_LGn}1G${RES}' (default)"
		echo -e "  -d,  --docker       install the node into Docker"
		echo -e "  -p,  --port NUMBER  port used by the node (default is '${C_LGn}${port}${RES}')"
		echo -e "  -rg, --register     register the node in IncentiveCash program"
		echo -e "  -un, --uninstall    uninstall the node"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/Minima/blob/main/multi_tool.sh - script URL"
		echo -e "https://teletype.in/@letskynode/Minima_EN — English-language a node installation guide"
		echo -e "https://teletype.in/@letskynode/Minima_RU — Russian-language a node installation guide"
		echo -e "https://t.me/letskynode — node Community"
		echo -e "https://teletype.in/@letskynode — guides and articles"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-rg|--register)
		function="register"
		shift
		;;
	-r*|--ram*)
		if ! grep -q "=" <<< "$1"; then shift; fi
		ram=`option_value "$1"`
		shift
		;;
	-p*|--port*)
		if ! grep -q "=" <<< "$1"; then shift; fi
		port=`option_value "$1"`
		shift
		;;
	-d|--docker)
		function="docker_install"
		shift
		;;
	-un|--uninstall)
		function="uninstall"
		shift
		;;
	*|--)
		break
		;;
	esac
done
# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
install() {
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		printf_n "${C_R}You installed node into Docker!${RES}"
		docker_install
		return 0 2>/dev/null; exit 0
	else
		sudo apt update
		sudo apt upgrade -y
		if [ -f /etc/systemd/system/minima.service ]; then
			printf_n "\n${C_LGn}Updating a node...${RES}"
			rpc_port=`cat /etc/systemd/system/minima.service | grep -oP "(?<=-rpc )([^%]+)(?= )"`
			if [ ! -n "$rpc_port" ]; then
				rpc_port="9002"
			fi
			wget -qO- "localhost:${rpc_port}/quit"
			sleep 10
			sudo systemctl stop minima
			sudo systemctl disable minima
		else
			sudo apt install openjdk-11-jre-headless -y
			printf_n "${C_LGn}Node installation...${RES}"
		fi
	fi
	mkdir -p $HOME/.minima
	wget -qO $HOME/.minima/minima.jar.new https://github.com/minima-global/Minima/raw/master/jar/minima.jar
	mv $HOME/.minima/minima.jar $HOME/.minima/minima.jar.bk
	mv $HOME/.minima/minima.jar.new $HOME/.minima/minima.jar
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/ports_opening.sh) 9001 9002 9003 9004
	printf "[Unit]
Description=Minima Node
After=network-online.target

[Service]
User=$USER
ExecStart=`which java` -Xmx${ram} -jar $HOME/.minima/minima.jar -data $HOME/.minima -port ${port} -rpcenable -rpc $((port+1)) -daemon
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/minima.service
	sudo systemctl daemon-reload
	sudo systemctl enable minima
	sudo systemctl restart minima
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "minima_log" -v "sudo journalctl -fn 100 -u minima" -a
	printf_n "${C_LGn}Done!${RES}\n"
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
	printf_n "
The node was ${C_LGn}started${RES}.

\tv ${C_LGn}Useful commands${RES} v

To view the node status: ${C_LGn}systemctl status minima${RES}
To view the node log: ${C_LGn}minima_log${RES}
To restart the node: ${C_LGn}systemctl restart minima${RES}
"
}
docker_install() {
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		printf_n "\n${C_LGn}Updating a node...${RES}"
		sudo apt update
		sudo apt upgrade -y
		docker exec -t minima_node sh -c 'wget -qO- "localhost:9002/quit"'
		printf_n
		sleep 10
		docker rm minima_node -f
	elif [ -f /etc/systemd/system/minima.service ]; then
		printf_n "${C_R}You installed node via a service file!${RES}"
		install
		return 0 2>/dev/null; exit 0
	else
		printf_n "${C_LGn}Node installation...${RES}"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/installers/docker.sh)
		mkdir -p $HOME/.minima
	fi
	wget -qO $HOME/.minima/minima.jar.new https://github.com/minima-global/Minima/raw/master/jar/minima.jar
	mv $HOME/.minima/minima.jar $HOME/.minima/minima.jar.bk
	mv $HOME/.minima/minima.jar.new $HOME/.minima/minima.jar
	docker run -dit --restart on-failure --name minima_node -v $HOME/.minima:/root/.minima --network host secord/minima
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "minima_log" -v "docker logs minima_node -fn 100" -a
	printf_n "${C_LGn}Done!${RES}\n"
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
	printf_n "
The node was ${C_LGn}started${RES}.

\tv ${C_LGn}Useful commands${RES} v

To view the node log: ${C_LGn}minima_log${RES}
To restart the node: ${C_LGn}docker restart minima${RES}
"
}
uninstall() {
	printf_n "${C_LGn}Node uninstalling...${RES}"
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		docker rm minima_node -f
		docker rmi secord/minima
	else
		service_files=`echo /etc/systemd/system/minima* | sed 's%/etc/systemd/system/%%g'`
		sudo systemctl stop "$service_files"
		rm /etc/systemd/system/minima*
		sudo systemctl daemon-reload
	fi
	rm -rf $HOME/minima $HOME/.minima $HOME/minima.jar* $HOME/minima_update.sh* $HOME/minima_service.sh*
	printf_n "${C_LGn}Done!${RES}"
}
register() {
	printf "${C_LGn}Input your Node ID: ${RES}"
	local id
	read -r id
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		docker exec -t minima_node sh -c 'wget -qO- "localhost:'$rpc_port'/incentivecash%20uid:'$id'"'
	else
		rpc_port=`cat /etc/systemd/system/minima.service | grep -oP "(?<=-rpc )([^%]+)(?= )"`
		if [ ! -n "$rpc_port" ]; then
			rpc_port="9002"
		fi
		wget -qO- "localhost:${rpc_port}/incentivecash%20uid:${id}"
	fi
	printf_n
}

# Actions
sudo apt install wget -y &>/dev/null
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
$function
