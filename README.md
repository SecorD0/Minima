<h1><p align="center">Minima | Testnet</p></h1>

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/190912891-6d3c6c43-4378-4c62-8315-0ec19d79de1f.jpg"></p>

<p align="center"><a href="https://t.me/OnePackage">1package</a></p>



<h1><p align="center">Content</p></h1>

- Content
- [Server requirements](#Server-requirements)
- [Launching](#Launching)
  - [Docker](#Docker)
- [Useful commands](#Useful-commands)
- [Useful links](#Useful-links)
- [1package](#1package)
- [Express your gratitude](#Express-your-gratitude)



<h1><p align="center">Server requirements</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀Minimal (VPS/VDS/DS): 1 CPU, 1 GB RAM, 10 GB HDD/SSD, Ubuntu 20.04

⠀Recommended: 2 CPU, 2 GB RAM, 10 GB HDD/SSD, Ubuntu 20.04

⠀Suitable servers:
- [Hetzner — CPX11](https://hetzner.cloud/?ref=VLYST6YYvi30)
- [Contabo — VPS S](https://contabo.com/en/vps/vps-s-ssd/?image=ubuntu.267&qty=1&contract=1)



<h1><p align="center">Launching</p></h1>
<p align="right"><a href="#Content">To the content</a></p>


<h2><p align="center">Docker</p></h2>

⠀Install Docker
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/installers/docker.sh)
```

⠀Create a container with a node
```sh
docker run -dit --restart on-failure --name minima_node -p 9001:9001 -p 9005:9005 secord/minima
```

⠀Add commands to the system as aliases:
- To view the log of the node;
- To view the information about the node.
```sh
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n minima_log -v "docker logs minima_node -fn 100" -a
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n minima_node_info -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) 2> /dev/null" -a
```

⠀Wait for the node launching
```sh
minima_log
```

<p align="center"><img src="https://user-images.githubusercontent.com/25284138/190913254-126a5516-cfe8-40f9-b5af-9fffde2892f8.png"></p>


<h1><p align="center">Useful commands</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀To view info about the node
```sh
minima_node_info
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/Minima/main/node_info.sh) 2> /dev/null
```

⠀To view the node's log
```sh
docker logs minima_node -fn 100
```

⠀To restart the node
```sh
docker restart minima_node
```



<h1><p align="center">Useful links</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

<p align="center"><a href="https://minima.global/">Official website</a> | <a href="https://t.me/Minima_Global">Official group in Telegram</a></p>

<p align="center"><a href="https://discord.gg/ZQaUXPape5">Discord</a> | <a href="https://twitter.com/Minima_Global">Twitter</a> | <a href="https://medium.com/minima-global">Medium</a> | <a href="https://cdn.minima.global/media/2021/07/02/Minima_Whitepaper_v9.pdf">Whitepaper</a> | <a href="https://docs.minima.global/docs/runanode/linux_vps/">Official guide</a></p>

<p align="center"><a href="https://github.com/minima-global">GitHub</a> | <a href="https://www.youtube.com/channel/UCDe2j57uQrUVtVizFbDpsoQ">YouTube</a> | <a href="https://incentivecash.minima.global/">IncentiveCash</a> | <a href="https://bit.ly/3surYbV">Registration Link</a></p>



<h1><p align="center">1package</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

<p align="center"><a href="https://t.me/OnePackage">Telegram</a> (RU) | <a href="https://t.me/OnePackage_Chat">Chat</a> (RU) | <a href="https://discord.gg/dnDaVqeWZe">Discord</a> (RU) | <a href="https://twitter.com/1package_">Twitter</a> | <a href="https://learning.1package.io/">Learning</a> | <a href="https://t.me/Admitix_News/2">Admitix</a></p>



<h1><p align="center">Express your gratitude</p></h1>
<p align="right"><a href="#Content">To the content</a></p>

⠀You can express your gratitude to the bot developers by sending fund to crypto wallets!
- Ethereum-like address (Ethereum, BSC, Moonbeam, etc.): `0x55AD64372bf4452759D577453521eb502001529A`
- USDT TRC-20: `TQvc5ruZPUSrs7riWeeekka5FjCGAiQ2wE`
- SOL: `8zpWbtTxmubgqcBXHQ129YbZszVp3WUcYc6a34peam3h`
- BTC: `bc1qnuwkg5ph0r8s332kle6jz2qmxe9ls36z9yt9ws`
