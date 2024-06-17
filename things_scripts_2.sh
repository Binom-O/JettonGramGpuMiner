
#!/bin/bash

cd /root
screen -wipe
for session in $(screen -ls | grep -o '[0-9]*\.mining'); do screen -S "${session}" -X quit; done
rm -r miner.tar.gz
rm chipi_clore_fabric.sh
rm install_node.sh
rm install_node.Unix.sh

apt update -y
apt install screen -y
apt install git -y
apt install nano -y
apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 18
nvm use 18
nvm alias default 18
curl -fsSL "https://www.dropbox.com/scl/fi/51fslvrgika8z33v171so/ThingsGpuMiner.tar.gz?rlkey=yxrxp99nlwqy261f6sfi3ogkg&st=0b2owxnr&dl=1" --connect-timeout 20 > miner.tar.gz
tar -xvf miner.tar.gz --one-top-level=miner --strip-components 1
cd miner


cat <<EOF > /root/miner/mine.sh
#!/bin/bash

npm install

while true; do
 node send_multigpu.js --api tonapi --bin ./pow-miner-cuda --givers 100 --gpu-count $(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l) --timeout 5
 sleep 1;
done;
EOF

chmod +x /root/miner/mine.sh
cd /root/miner;
screen -L -Logfile miner_10k.log -dmS mining ./mine.sh;
screen -r mining;
 
