#!/bin/sh  
set -x
set -e

EMAIL_RECIPIENTS="jaisonvj053@gmail.com"
EMAIL_CC="jaison.v@mresult.com,mypcnrp@gmail.com"  # Add CC email addresses here
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
Please dont reply to this mail.
EOF
}
send_email

#edited
#sudo nano /etc/ssmtp/ssmtp.conf
#root=your_email@gmail.com
#mailhub=smtp.gmail.com:587
#AuthUser=your_email@gmail.com
#AuthPass=your_app_password
#UseSTARTTLS=YES

