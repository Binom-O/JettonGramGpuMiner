#!/bin/bash

GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)	

apt install screen -y
apt install git -y
apt install mc -y
apt install htop -y


cd ~
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
apt-get install -y nodejs
git clone https://github.com/TrueCarry/JettonGramGpuMiner.git
cd JettonGramGpuMiner

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
