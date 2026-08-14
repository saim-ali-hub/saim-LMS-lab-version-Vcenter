#!/bin/bash

# Lab 206 - Linux File Permissions


HOME_DIR="$HOME"
BASE="$HOME_DIR/permissions_lab"

# --------------------------------------------------
# TASK 1 - Create Lab Directory Structure
# --------------------------------------------------

cd "$HOME_DIR" || exit 1

mkdir -p "$BASE"/{application,configuration,logs,scripts,reports,private}

# --------------------------------------------------
# TASK 2 - Practice Symbolic Permissions
# --------------------------------------------------

cd "$BASE/scripts" || exit 1

touch backup.sh monitor.sh cleanup.sh

# backup.sh -> rwx------
chmod u+rwx,g-rwx,o-rwx backup.sh

# monitor.sh -> rwxr-xr-x
# Add execute without changing existing read/write permissions
chmod u+x,g+x,o+x monitor.sh

# cleanup.sh -> rwxr-x---
# Add execute for owner and group
# Remove read permission from others
chmod u+x,g+x,o-r cleanup.sh

# --------------------------------------------------
# TASK 3 - Configure Private Directory
# --------------------------------------------------

cd "$BASE/private" || exit 1

touch credentials.txt keys.txt

# Private directory -> rwx------
chmod u+rwx,g-rwx,o-rwx "$BASE/private"

# credentials.txt -> rw-r-----
chmod u+rw,g+r,o-rwx credentials.txt

# keys.txt -> rw-------
chmod u+rw,g-rwx,o-rwx keys.txt

# --------------------------------------------------
# TASK 4 - Application Files
# --------------------------------------------------

cd "$BASE/application" || exit 1

touch app.conf app.log deploy.sh README.txt

# app.conf -> rw-r--r--
chmod 644 app.conf

# app.log -> rw-r-----
chmod 640 app.log

# deploy.sh -> rwxr-xr-x
chmod 755 deploy.sh

# README.txt -> rw-r--r--
chmod 644 README.txt

# --------------------------------------------------
# TASK 5 - Configuration Files
# --------------------------------------------------

cd "$BASE/configuration" || exit 1

touch database.conf network.conf

# database.conf -> rw-------
chmod 600 database.conf

# network.conf -> rw-r-----
chmod 640 network.conf

# --------------------------------------------------
# TASK 6 - Log Files and Directory Permissions
# --------------------------------------------------

cd "$BASE" || exit 1

touch logs/application.log logs/access.log

# logs directory -> rwxr-x---
chmod 750 logs

# application.log -> rw-r-----
chmod 640 logs/application.log

# access.log -> rw-r--r--
chmod 644 logs/access.log

# --------------------------------------------------
# TASK 7 - Practice Recursive Permissions
# --------------------------------------------------

cd "$BASE" || exit 1

mkdir -p reports/engineering reports/management

touch reports/engineering/report1.txt
touch reports/engineering/report2.txt

touch reports/management/bonus.txt
touch reports/management/rise.txt

# Apply permission 700 recursively
chmod -R 700 reports

# Create daily.txt after recursive chmod
cd reports || exit 1

touch daily.txt

# daily.txt -> rw-rw----
chmod 660 daily.txt

echo "Lab 206 completed successfully!"
