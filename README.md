# chainlink-gcs-setup
Google Cloud Chainlink Node Automated Install (Ropsten)

Clone this repo

```git clone https://github.com/stepsal/chainlink-gcs-setup.git```

Modify the cl_node_initial_setup.bsh script in a text editor
Replace the placeholders ETHNODE_ADDRESS, NODE_PASSWORD, API_USER and API_PASSWORD with your desired config.

Open the HTTP port on your project If its not already.

```gcloud compute firewall-rules create default-allow-http --allow tcp:6688```

Provision the VPS and automatically install the Chainlink node. You may want to modify the --zone variable to your local zone.

 ```gcloud compute instances create chainlink-node-primary --machine-type g1-small --image-family debian-9 --image-project debian-cloud --zone europe-west1-b  --restart-on-failure  --tags http-server --metadata-from-file startup-script=cl_node_initial_setup.bsh```

When the instance is created take note of its EXTERNAL_IP.
The startup script will still be running in the background. To monitor the ongoing install, run the command.

 ```gcloud compute ssh chainlink-node-primary --command 'tail -f /var/log/daemon.log'```

Once the startup scripts says it has completed login to your Chainlink node via the HTTP link.
