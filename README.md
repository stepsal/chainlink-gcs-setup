# chainlink-gcs-setup
Chainlink Node Automated Setup for Google Cloud.
This script creates a VPS and automatically provisions a Chainlink node right up to GUI login.
This node setup is for demo purposes only and should not be considered as suitable for mainnet.

## Pre-requisites
You are running on Linux or Mac OS ( Linux VM should work on Windows).

You have signed up for Google Cloud Account.

Git and gcloud have been installed on your host machine.

You have created a new project (with billing enabled) on Google Cloud.

You have a http://fiews.io/ or similar Ethereum node as a service account.

## Installation Steps
Clone the repo

```git clone https://github.com/stepsal/chainlink-gcs-setup.git```

CD into the directory.

```cd chainlink-gcs-setup```

Modify the cl_node_initial_setup.bsh script in a text editor.
Replace the placeholders ETHNODE_ADDRESS, WALLET_PASSWORD, API_USER and API_PASSWORD with your desired config.

Open the HTTP port 6688 on your project.

```gcloud compute firewall-rules create default-allow-http --allow tcp:6688```

Provision the VPS and automatically install the Chainlink node. You may want to modify the --zone variable to your local zone.

 ```gcloud compute instances create chainlink-node-primary --machine-type g1-small --image-family debian-9 --image-project debian-cloud --zone europe-west1-b  --restart-on-failure  --tags http-server --metadata-from-file startup-script=cl_node_initial_setup.bsh```

When the instance is created take note of its EXTERNAL_IP.
The startup script will still be running in the background. To monitor the ongoing install, run the command.

 ```gcloud compute ssh chainlink-node-primary --command 'tail -f /var/log/daemon.log'```

Once the startup scripts says it has completed, you can login to your (Ropsten) Chainlink node via http://your_external_ip:6688

## Post-installation
If you dont want to have passwords in plain text on the node you can remove the passwords file after installation. Make sure you have them written down and stored safely somewhere

```rm -rf /var/chainlink-ropsten/.api /var/chainlink-ropsten/.password```
