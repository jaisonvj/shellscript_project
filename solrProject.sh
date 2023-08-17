#!/bin/bash
##################################
# Author : jaison v j
# Date : 14/08/2023
# This script monitor the solr
# Version: V1
##################################
set -x
set -e
# Set installation directory
INSTALL_DIR="/opt/solr"

# Set Solr version
SOLR_VERSION="8.11.2"

# Stop Solr if it is running
SOLR_PID_FILE="$INSTALL_DIR/bin/solr-$SOLR_VERSION.pid"
if [ -f "$SOLR_PID_FILE" ]; then
    SOLR_PID=$(cat "$SOLR_PID_FILE")
    echo "Stopping Solr..."
    "$INSTALL_DIR/bin/solr" stop -p "$SOLR_PID"
    rm "$SOLR_PID_FILE"
fi

# Delete old Solr installation
if [ -d "$INSTALL_DIR" ]; then
    echo "Deleting old Solr installation..."
    sudo rm -rf "$INSTALL_DIR"
fi

# Download Solr distribution if not already downloaded
SOLR_URL="https://downloads.apache.org/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"
SOLR_FILE="/tmp/solr-$SOLR_VERSION.tgz"
if [ -f "$SOLR_FILE" ]; then
    echo "Deleting existing Solr distribution..."
    rm "$SOLR_FILE"
fi
wget "$SOLR_URL" -P /tmp

# Extract Solr
echo "Extracting Solr..."
tar xf "$SOLR_FILE" -C /tmp
sudo mv /tmp/solr-$SOLR_VERSION $INSTALL_DIR

# Create a Solr core
CORE_NAME="mycore"
$INSTALL_DIR/bin/solr create_core -c $CORE_NAME

# Set environment variables
echo "export SOLR_HOME=$INSTALL_DIR" >> ~/.bashrc
source ~/.bashrc

# Create a Solr systemd service unit file
SERVICE_FILE="/etc/systemd/system/solr.service"
echo "[Unit]
Description=Apache Solr Search Platform
After=network.target

[Service]
Type=forking
Environment=SOLR_HOME=$INSTALL_DIR
ExecStart=$INSTALL_DIR/bin/solr start
ExecStop=$INSTALL_DIR/bin/solr stop
ExecReload=$INSTALL_DIR/bin/solr restart
PIDFile=$INSTALL_DIR/bin/solr-$CORE_NAME.pid

[Install]
WantedBy=multi-user.target" | sudo tee "$SERVICE_FILE" > /dev/null

# Start and enable the Solr service
sudo systemctl daemon-reload
sudo systemctl start solr
sudo systemctl enable solr

# Monitor Solr service
while true; do
    SOLR_STATUS=$(curl -s http://localhost:8983/solr/admin/ping | jq -r '.status')
    if [ "$SOLR_STATUS" != "OK" ]; then
        echo "Solr is not responding. Restarting..."
        sudo systemctl restart solr
    fi
    sleep 60
done
