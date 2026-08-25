#!/bin/bash

# Lab 207 - Ownership and Group Management
# Create the required directory and file structure

mkdir -p ~/ownership_lab
cd ~/ownership_lab || exit 1

# Create files
touch file1.txt file2.txt file3.txt file4.txt

# Create directories
mkdir -p application database project1 project2 backup

# Create backup files
touch backup/backup1.txt backup/backup2.txt

sudo chown john ~/ownership_lab/file1.txt
sudo chown :developers ~/ownership_lab/file2.txt
sudo chgrp developers ~/ownership_lab/file3.txt
sudo chown john:developers ~/ownership_lab/file4.txt
sudo chown smith ~/ownership_lab/application
sudo chown :admins ~/ownership_lab/database
sudo chgrp admins ~/ownership_lab/project1
sudo chown smith:admins ~/ownership_lab/project2
sudo chown -R smith:admins ~/ownership_lab/backup
