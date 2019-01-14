# chainlink-gcs-setup
Chainlink Node Automated Setup for Google Cloud.
This script creates a VPS and automatically provisions a Chainlink node right up to GUI login.
This node setup is for demo purposes only and should not be considered as suitable for mainnet.

## Pre-requisites

* You are running on Linux or Mac OS (Linux VM should work on Windows).

* You have signed up for [Google Cloud Account](https://cloud.google.com/).

* [gcloud](https://cloud.google.com/sdk/install) (and optionally git) have been installed on your host machine.

* You have created a new project (with billing enabled) on Google Cloud.

* In this project you have enabled the [Compute Engine API](https://console.cloud.google.com/apis/api/compute.googleapis.com/overview).

* You have a [Fiews.io](https://fiews.io/) or similar Ethereum node as a service (EaaS) account.

## Installation Steps

### Download the repo

With git installed:

```
git clone https://github.com/stepsal/chainlink-gcs-setup.git && cd chainlink-gcs-setup
```

Without git:

```
wget https://github.com/stepsal/chainlink-gcs-setup/archive/master.zip && unzip master.zip && cd chainlink-gcs-setup-master
```

### Prepare configuration

Modify the cl_node_initial_setup.bsh script in a text editor.
Replace the placeholders `ETHNODE_ADDRESS`, `WALLET_PASSWORD`, `API_USER` and `API_PASSWORD` with your [desired config](#configuration-variables).

Open the HTTP port 6688 on your project.

```
gcloud compute firewall-rules create default-allow-http --allow tcp:6688
```

### Provision the VPS

Provision the VPS and automatically install the Chainlink node. You may want to modify the --zone variable to your local zone.

```
gcloud compute instances create chainlink-node-primary --machine-type g1-small --image-family debian-9 --image-project debian-cloud --zone europe-west1-b  --restart-on-failure  --tags http-server --metadata-from-file startup-script=cl_node_initial_setup.sh
```

When the instance is created take note of its EXTERNAL_IP.
The startup script will still be running in the background. To monitor the ongoing install, run the command.

```
gcloud compute ssh chainlink-node-primary --command 'tail -f /var/log/daemon.log'
```

Once the startup scripts says it has completed, you can login to your (Ropsten) Chainlink node via http://EXTERNAL_IP:6688

## Post-installation
If you dont want to have passwords in plain text on the node you can remove the passwords file after installation. Make sure you have them written down and stored safely somewhere

```
rm -rf /var/chainlink-ropsten/.api /var/chainlink-ropsten/.password
```

## Configuration variables

Variable | Description | Example
-------- | ----------- | -------
`ETHNODE_ADDRESS` | The WS endpoint URL for your Ethereum node. | Fiews: `wss://cl-ropsten.fiews.io/v1/yourapikey` LinkPool: `wss://ropsten-rpc.linkpool.io/ws`
`API_USER` | The email you want to use to sign in to your CL node. | `you@example.com`
`API_PASSWORD` | The password you want to use to sign in to your CL node. | `yourpassword123`
`WALLET_PASSWORD` | A (secure) password for your Ethereum wallet. | `U!^926*KmBqsj68RpcI$*!w9$YpSTJK!#T`
