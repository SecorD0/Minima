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
	printf_n "${C_R}Not supported anymore${RES}"
	return 0 2>/dev/null; exit 0
	
	if [ "$port" = "9001" ]; then
		local node_name="minima"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "minima_node_info" -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) -l RU 2> /dev/null" -a
	else
		local node_name="minima_${port}"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "${node_name}_node_info" -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) -l RU -p $((port+1)) 2> /dev/null" -a
	fi
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		printf_n "${C_R}You installed node into Docker!${RES}"
		docker_install
		return 0 2>/dev/null; exit 0
	else
		sudo apt update
		sudo apt upgrade -y
		if [ -f "/etc/systemd/system/${node_name}.service" ]; then
			printf_n "\n${C_LGn}Updating a node...${RES}"
			local rpc_port=`cat "/etc/systemd/system/${node_name}.service" | grep -oP "(?<=-rpc )([^%]+)(?= )"`
			if [ ! -n "$rpc_port" ]; then
				local rpc_port="9002"
			fi
			wget -qO- "localhost:${rpc_port}/quit"
			printf_n
			sleep 10
			sudo systemctl stop "$node_name"
			sudo systemctl disable "$node_name"
		else
			sudo apt install openjdk-11-jre-headless -y
			printf_n "${C_LGn}Node installation...${RES}"
		fi
	fi
	mkdir -p $HOME/.minima "$HOME/.${node_name}"
	wget -qO $HOME/.minima/minima.jar.new https://github.com/minima-global/Minima/raw/master/jar/minima.jar
	mv $HOME/.minima/minima.jar $HOME/.minima/minima.jar.bk
	mv $HOME/.minima/minima.jar.new $HOME/.minima/minima.jar
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/ports_opening.sh) "$port" $((port+1))
	printf "[Unit]
Description=Minima Node
After=network-online.target

[Service]
User=$USER
ExecStart=`which java` -Xmx${ram} -jar $HOME/.minima/minima.jar -data $HOME/.${node_name} -port ${port} -rpcenable -rpc $((port+1)) -daemon
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > "/etc/systemd/system/${node_name}.service"
	sudo systemctl daemon-reload
	sudo systemctl enable "$node_name"
	sudo systemctl restart "$node_name"
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "${node_name}_log" -v "sudo journalctl -fn 100 -u ${node_name}" -a
	printf_n "${C_LGn}Done!${RES}\n"
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
	printf_n "
The node was ${C_LGn}started${RES}.

\tv ${C_LGn}Useful commands${RES} v

To view the node status: ${C_LGn}systemctl status ${node_name}${RES}
To view the node log: ${C_LGn}${node_name}_log${RES}
To restart the node: ${C_LGn}systemctl restart ${node_name}${RES}
"
}
docker_install() {
	if [ "$port" = "9001" ]; then
		local node_name="minima"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "minima_node_info" -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) -l RU 2> /dev/null" -a
	else
		local node_name="minima_${port}"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "${node_name}_node_info" -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) -l RU -p $((port+1)) 2> /dev/null" -a
	fi
	local is_docker=`docker ps -a 2>/dev/null | grep "${node_name}_node"`
	if [ -n "$is_docker" ]; then
		printf_n "\n${C_LGn}Updating a node...${RES}"
		wget -qO- "localhost:$((port+1))/quit"
		printf_n
		sleep 10
		docker restart "${node_name}_node"
	elif [ -f /etc/systemd/system/minima.service ]; then
		printf_n "${C_R}You installed node via a service file!${RES}"
		install
		return 0 2>/dev/null; exit 0
	else
		printf_n "${C_LGn}Node installation...${RES}"
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/installers/docker.sh)
		docker run -dit --restart on-failure --name "${node_name}_node" -v $HOME/.minima/:/minima/.minima -p $port:9001 -p $((port+1)):9002 secord/minima
	fi
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "${node_name}_log" -v "docker logs ${node_name}_node -fn 100" -a
	printf_n "${C_LGn}Done!${RES}\n"
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
	printf_n "
The node was ${C_LGn}started${RES}.

\tv ${C_LGn}Useful commands${RES} v

To view the node log: ${C_LGn}${node_name}_log${RES}
To restart the node: ${C_LGn}docker restart ${node_name}_node${RES}
"
}
uninstall() {
	printf_n "${C_LGn}Node uninstalling...${RES}"
	local is_docker=`docker ps -a 2>/dev/null | grep minima_node`
	if [ -n "$is_docker" ]; then
		docker rm `docker ps -a | grep minima | awk '{print $1}'` -f
		docker rmi secord/minima
	else
		local service_files=`echo /etc/systemd/system/minima* | sed 's%/etc/systemd/system/%%g'`
		for service_file in $service_files; do
			sudo systemctl stop "$service_file"
		done
		rm /etc/systemd/system/minima*
		sudo systemctl daemon-reload
	fi
	rm -rf $HOME/minima* $HOME/.minima* $HOME/minima.jar* $HOME/minima_update.sh* $HOME/minima_service.sh* /etc/cron.weekly/minima*
	sed -i "/minima/d" $HOME/.bash_profile
	. $HOME/.bash_profile
	printf_n "${C_LGn}Done!${RES}"
}
register() {
	printf "${C_LGn}Input your Node ID: ${RES}"
	local id
	read -r id
	wget -qO- "localhost:$((port+1))/incentivecash%20uid:${id}"
	printf_n "\n${C_LGn}Done!${RES}"
}

# Actions
if [ `whoami` != "root" ]; then
	printf_n "${C_LGn}Authorizing as root user...${RES}"
	sudo su -
fi
sudo apt install wget -y &>/dev/null
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
$function
