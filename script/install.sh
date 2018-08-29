#!/bin/bash

#Variables - START
TARBALLURL="https://github.com/vulcanocrypto/Vulcano/releases/download/v2.0.0.0/vulcano-2.0.0.0-linux64.tar.gz"
TARBALLNAME="vulcano-2.0.0.0-linux64.tar.gz"
BOOTSTRAPURL="https://github.com/vulcanocrypto/Vulcano/releases/download/v2.0.0.0/bootstrap.dat.zip"
BOOTSTRAPARCHIVE="bootstrap.dat.zip"
BWKVERSION="2.0.0.0"
# BWK-Dash variables.
DASH_BIN_TAR="vulc-dash-1.0.0-linux-amd64.tar.gz"
DASH_HTML_TAR="vulc-dash-1.0.0-html.tar.gz"
DASH_PORT="8080"
DASH_VER="v1.0.0"
#Variables - END

#TODO: Combine back with SHN install script.
sudo apt-get install -y gcc unzip
sudo adduser vulcano

#Vulcano Service - START
sudo cat > /etc/systemd/system/vulcanod.service << EOL
[Unit]
Description=Vulcanos's distributed currency daemon
After=network.target
[Service]
User=vulcano
Group=vulcano
WorkingDirectory=/home/vulcano
Type=forking
ExecStart=/usr/local/bin/vulcanod -datadir=/home/vulcano/.vulcano -conf=/home/vulcano/.vulcano/vulcano.conf -daemon
ExecStop=/usr/local/bin/vulcano-cli -datadir=/home/vulcano/.vulcano -conf=/home/vulcano/.vulcano/vulcano.conf stop
#KillMode=process
Restart=always
TimeoutSec=120
RestartSec=30
[Install]
WantedBy=multi-user.target
EOL
sleep 1
#Vulcano Service - END

#Vulcano Config - START
sudo mkdir /home/vulcano/.vulcano
sudo touch /home/vulcano/.vulcano/vulcano.conf
sudo chown -R vulcano:vulcano /home/vulcano/.vulcano
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sudo cat > /home/vulcano/.vulcano/vulcano.conf << EOL
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
daemon=1
EOL
#Vulcano Config - END

#BWK-Dash Setup - START
# Setup systemd service and start.
sudo cat > /etc/systemd/system/vulc-dash.service << EOL
[Unit]
Description=Vulcano Home Node Dashboard
After=network.target
[Service]
User=vulcano
Group=vulcano
WorkingDirectory=/home/vulcano/dash
ExecStart=/usr/local/bin/vulc-dash
Restart=always
TimeoutSec=10
RestartSec=35
[Install]
WantedBy=multi-user.target
EOL
sleep 1
# Get binaries and install.
wget https://github.com/vulcanocrypto/vulc-dash/releases/download/$DASH_VER/$DASH_BIN_TAR
sudo tar -zxf $DASH_BIN_TAR -C /usr/local/bin
rm -f $DASH_BIN_TAR
# Copy the html files to the dash folder and create.
wget https://github.com/vulcanocrypto/vulc-dash/releases/download/$DASH_VER/$DASH_HTML_TAR
sudo mkdir -p /home/vulcano/dash
sudo tar -zxf $DASH_HTML_TAR -C /home/vulcano/dash
rm -f $DASH_HTML_TAR
# Create .env file for dashboard api and cron.
cat > /home/vulcano/dash/.env << EOL
DASH_DONATION_ADDRESS=TESTADDRESSHERE
DASH_PORT=${DASH_PORT}
DASH_RPC_ADDR=localhost
DASH_RPC_PORT=62541
DASH_RPC_USER=${RPCUSER}
DASH_RPC_PASS=${RPCPASSWORD}
DASH_WEBSITE=/home/vulcano/dash
DASH_DB=/home/vulcano/dash/vulc-dash.db
DASH_TOR=
EOL
sleep 1
# Cleanup/enforce ownership.
sudo chown -R vulcano:vulcano /home/vulcano/dash
# Setup timer and service for vulc-cron.
sudo cat > /etc/systemd/system/vulc-cron.service << EOL
[Unit]
Description=Vulcano Home Node Dashboard - Cron
After=network.target
[Service]
User=vulcano
Group=vulcano
WorkingDirectory=/home/vulcano/dash
ExecStart=/usr/local/bin/vulc-cron
Restart=always
TimeoutSec=10
RestartSec=35
EOL
sleep 1
sudo cat > /etc/systemd/system/vulc-cron.timer << EOL
[Unit]
Description=Vulcano Home Node Dashboard - Cron
[Timer]
OnCalendar=*-*-* *:*:00
OnBootSec=35
OnUnitActiveSec=60
[Install]
WantedBy=timers.target
EOL
sleep 1
# Enable service and timer.
sudo systemctl enable vulc-cron.timer
sudo systemctl enable vulc-dash.service
#BWK-Dash Setup - END

#Vulcano Node - START
sudo wget $TARBALLURL
sleep 2
sudo tar -xzf $TARBALLNAME -C /usr/local
sudo rm $TARBALLNAME
sleep 3
cd ~
sudo chown -R vulcano:vulcano /home/vulcano/vulcano/
sleep 1
sudo systemctl enable vulcanod.service
sleep 1
#Vulcano Node - END

sudo reboot
