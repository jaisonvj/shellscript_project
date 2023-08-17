#!/bin/bash
##################################
# Author : jaison v j
# Date : 14/08/2023
# This script monitor the tomcat
# Version: V1
##################################
set -x
set -e

EMAIL_RECIPIENTS="jaisonvj053@gmail.com"
EMAIL_CC="jaison.v@mresult.com,mypcnrp@gmail.com" 
EMAIL_SUBJECT="Tomcat Service Alert !"

# Function to send an email
send_email() {
    echo "Tomcat service is stopped. Sending an email alert."
    # Construct the email using a here document
    cat << EOF | ssmtp -c "$EMAIL_CC" "$EMAIL_RECIPIENTS"
To: $EMAIL_RECIPIENTS
Cc: $EMAIL_CC
Subject: $EMAIL_SUBJECT

Tomcat service is stopped on $(hostname).
please check the link below
http://192.168.42.224:8011/webapp/
Please don't reply to this email.
EOF
}

# Set the actual installation directory
INSTALL_DIR="/opt/tomcat"
# Tomcat version
TOMCAT_VERSION="9.0.78"
# create a directory
sudo mkdir -p "$INSTALL_DIR"
# change the owner
sudo chown -R "$(whoami)" "$INSTALL_DIR"
# Download and extract Tomcat
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
wget "$TOMCAT_URL" -O /tmp/apache-tomcat.tar.gz
tar -xf /tmp/apache-tomcat.tar.gz -C "$INSTALL_DIR" --strip-components=1
# copying the project build file to tomcat
cp "/mnt/d/IMP files/apache-tomcat-9.0.73-windows-x64/apache-tomcat-9.0.73/webapps/webapp.war" "/opt/tomcat/webapps/"

# Set environment variables
echo "export CATALINA_HOME=$INSTALL_DIR" >> ~/.bashrc
echo "export PATH=\$PATH:\$CATALINA_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# Modify server.xml to change the port to 8081
sed -i 's/8080/8011/g' "$INSTALL_DIR/conf/server.xml"
sudo ufw allow 8011    

# Create a systemd service unit file
SERVICE_FILE="/etc/systemd/system/tomcat.service"
echo "[Unit]
Description=Apache Tomcat Web Application
After=network.target

[Service]
Type=forking
Environment=CATALINA_PID=$INSTALL_DIR/temp/tomcat.pid
Environment=CATALINA_HOME=$INSTALL_DIR
Environment=CATALINA_BASE=$INSTALL_DIR
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
ExecStart=$INSTALL_DIR/bin/startup.sh
ExecStop=$INSTALL_DIR/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee "$SERVICE_FILE" > /dev/null

# Start and enable the Tomcat service
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

echo "Apache Tomcat has been installed, started, and enabled."

# Restart Tomcat service
sudo systemctl restart tomcat
echo "Tomcat service has been restarted."

# Monitor Tomcat service
while true; do
    TOMCAT_STATUS=$(systemctl is-active tomcat)
    if [ "$TOMCAT_STATUS" != "active" ]; then
        send_email
        echo "server is inactive mail send"
    fi
    sleep 60
done
