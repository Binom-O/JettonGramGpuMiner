
#!/bin/bash

cd /root
screen -wipe
for session in $(screen -ls | grep -o '[0-9]*\.mining'); do screen -S "${session}" -X quit; done
rm -rf miner.tar.gz

sudo apt install curl -y
sudo curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install node
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211230.1/minertools-cuda-ubuntu-18.04-x86-64.tar.gz
tar -xzf minertools-cuda-ubuntu-18.04-x86-64.tar.gz
git clone https://github.com/JupiterTokenTon/JettonJPTRGpuMiner-main.git temp
cp -r /root/temp/. /root/miner
rm -rf temp
cd miner


cat <<EOF > /root/miner/mine.sh
#!/bin/bash

npm install

while true; do
 node send_multigpu_jptr.js --api tonhub --givers 100000 --bin ./pow-miner-cuda --gpu-count $(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
 sleep 1;
done;
EOF

chmod +x /root/miner/mine.sh
cd /root/miner;
screen -L -Logfile miner_10k.log -dmS mining ./mine.sh;
screen -r mining;