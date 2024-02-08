#!/bin/bash

GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)	

apt install screen -y
apt install git -y
apt install mc -y
apt install htop -y


curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
chmod +x /root/.nvm/nvm.sh
source /root/.nvm/nvm.sh
nvm install 16
cd ~
git clone https://github.com/TrueCarry/JettonGramGpuMiner.git
cd JettonGramGpuMiner
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211230.1/minertools-cuda-ubuntu-18.04-x86-64.tar.gz
tar -xvf minertools-cuda-ubuntu-18.04-x86-64.tar.gz
git clone https://github.com/forsbors/gr.git
mv -f /root/JettonGramGpuMiner/gr/send_multigpu.js /root/JettonGramGpuMiner/


cat <<EOF > /root/JettonGramGpuMiner/mine.sh
#!/bin/bash

npm install

while true; do
  node send_multigpu_meridian.js --api lite --bin ./pow-miner-cuda --givers 1000 --gpu-count $GPU_COUNT -c https://raw.githubusercontent.com/john-phonk/config/main/config.json
  sleep 1;
done;
EOF

chmod +x /root/JettonGramGpuMiner/mine.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:mining]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'screen -dmS mining bash /root/mine.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
