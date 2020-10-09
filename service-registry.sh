
SERVICE_NAME=cloudflare-ddns-agent

sudo mv cloudflare-ddns-from-linux.sh /usr/bin/$SERVICE_NAME.sh
sudo chmod +x /usr/bin/$SERVICE_NAME.sh


cat <<EOF > /lib/systemd/system/$SERVICE_NAME.service
#!/bin/bash

[Unit]
Description=Agent to register/update a dns record with Dynamic DNS of the Cloudflare

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/$SERVICE_NAME.sh

[Install]
WantedBy=multi-user.target

EOF

sudo cp /lib/systemd/system/$SERVICE_NAME.service /etc/systemd/system/$SERVICE_NAME.service
sudo chmod 644 /etc/systemd/system/$SERVICE_NAME.service

sudo systemctl reload
