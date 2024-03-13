#!/bin/bash

sudo tee -a /etc/sudoers <<EOF
%MAXCORP\\\SG\ -\ ITAccess\ -\ Corporate\ Service\ Desk ALL=(ALL:ALL) ALL
%MAXCORP\\\Domain\ Admins ALL=(ALL:ALL) ALL
EOF
sudo sed -i '/:ALL:ALL/i \
+:MAXCORP\\Domain Admins:ALL \
+:MAXCORP\\SG - ITAccess - Corporate Service Desk:ALL
' /etc/security/access.conf
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart

