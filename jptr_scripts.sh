
#!/bin/bash

cd /root
screen -wipe
for session in $(screen -ls | grep -o '[0-9]*\.mining'); do screen -S "${session}" -X quit; done
rm -rf miner.tar.gz

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