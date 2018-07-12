#!/bin/sh
cat <<EOF
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

sudo bash -c 'echo "[Unit] 
Description=Reddit
Requires=network-online.target
After=network.target
[Service] 
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma
Restart=always
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/puma-service.service'

sudo systemctl daemon-reload
sudo systemctl enable puma-service
sudo systemctl start puma-service
EOF