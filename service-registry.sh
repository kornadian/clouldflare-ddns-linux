
SERVICE_NAME=cloudflare-ddns-agent

sudo cp cloudflare-ddns-from-linux.sh /usr/bin/$SERVICE_NAME.sh
sudo chmod +x /usr/bin/$SERVICE_NAME.sh


cat <<EOF > $SERVICE_NAME.service
#!/bin/bash

[Unit]
Description=Agent to register/update a dns record with Dynamic DNS of the Cloudflare

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/$SERVICE_NAME.sh

[Install]
Wants=$SERVICE_NAME-timer.timer

EOF

cat <<EOF > $SERVICE_NAME-timer.timer
[Unit]
Description=Cf DDNS DNS Update Timer for $SERVICE_NAME service

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=$SERVICE_NAME.service

[Install]
WantedBy=basic.target
EOF


sudo cp $SERVICE_NAME-timer.timer /etc/systemd/system/$SERVICE_NAME-timer.timer
sudo chmod 644 /etc/systemd/system/$SERVICE_NAME-timer.timer


sudo cp $SERVICE_NAME.service /etc/systemd/system/$SERVICE_NAME.service
sudo chmod 644 /etc/systemd/system/$SERVICE_NAME.service

sudo systemctl reload
sudo systemctl enable $SERVICE_NAME-timer.timer
sudo systemctl start $SERVICE_NAME-timer.timer

