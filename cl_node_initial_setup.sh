!#/bin/bash
sudo apt-get update
sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker pull smartcontract/chainlink:latest
sudo mkdir /var/chainlink-ropsten

cat <<EOF > /var/chainlink-ropsten/ropsten_env
ROOT=/chainlink
LOG_LEVEL=debug
ETH_URL=ETHNODE_ADDRESS
ETH_CHAIN_ID=3
MIN_OUTGOING_CONFIRMATIONS=2
MIN_INCOMING_CONFIRMATIONS=0
LINK_CONTRACT_ADDRESS=0x20fe562d797a42dcb3399062ae9546cd06f63280
CHAINLINK_DEV=true
CHAINLINK_TLS_PORT=0
ALLOW_ORIGINS=*
EOF

cat <<EOF > /var/chainlink-ropsten/.api
API_USER
API_PASSWORD
EOF

cat <<EOF > /var/chainlink-ropsten/.password
WALLET_PASSWORD
EOF

sudo docker run -p 6688:6688 \
           -v /var/chainlink-ropsten:/chainlink \
           -d --env-file=/var/chainlink-ropsten/ropsten_env \
           smartcontract/chainlink n \
           -p /chainlink/.password -a /chainlink/.api

echo "***** Chainlink Node Successfully Installed *****"




