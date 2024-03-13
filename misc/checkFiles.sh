#!/bin/bash

# backup files
sudo cp /etc/sudoers /etc/sudoers.bu
sudo cp /etc/security/access.conf  /etc/security/access.conf.bu
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bu

ls -l /etc/sudoers*
ls -l /etc/security/access.conf*
ls -l /etc/ssh/sshd_config*


exit 0

