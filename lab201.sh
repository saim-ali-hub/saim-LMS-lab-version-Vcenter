#!/bin/bash

# ============================================================
# Linux Server Information & Navigation Lab
# ============================================================

# Make sure we start in the user's home directory
cd ~

SERVER_REPORT="$HOME/server-report"
SERVER_REVIEW_REPORT="$HOME/server-review-report"

# Create/clear reports for a fresh lab run
> "$SERVER_REPORT"
> "$SERVER_REVIEW_REPORT"


# ============================================================
# TASK 1 - Verify Login Information
# ============================================================

whoami >> "$SERVER_REPORT"
id >> "$SERVER_REPORT"


# ============================================================
# TASK 2 - Current Working Directory
# ============================================================

pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 3 - CPU Information
# ============================================================

lscpu >> "$SERVER_REPORT"


# ============================================================
# TASK 4 - Memory Information
# ============================================================

free >> "$SERVER_REPORT"
free -h >> "$SERVER_REPORT"
free -m >> "$SERVER_REPORT"
free -g >> "$SERVER_REPORT"


# ============================================================
# TASK 5 - Block Devices
# ============================================================

lsblk >> "$SERVER_REPORT"


# ============================================================
# TASK 6 - Kernel Information
# ============================================================

uname -a >> "$SERVER_REPORT"
uname -r >> "$SERVER_REPORT"


# ============================================================
# TASK 7 - Server Availability / Uptime
# ============================================================

uptime >> "$SERVER_REPORT"


# ============================================================
# TASK 8 - Home Directory Listings
# ============================================================

cd ~

pwd >> "$SERVER_REPORT"
ls >> "$SERVER_REPORT"
ls -l >> "$SERVER_REPORT"
ls -al >> "$SERVER_REPORT"


# ============================================================
# TASK 9 - Root Filesystem
# ============================================================

cd /

pwd >> "$SERVER_REPORT"
ls / >> "$SERVER_REPORT"


# ============================================================
# TASK 10 - Explore Important Linux Directories
# ============================================================

cd /etc
pwd >> "$SERVER_REPORT"

cd /opt
pwd >> "$SERVER_REPORT"

cd /var
pwd >> "$SERVER_REPORT"

cd /home
pwd >> "$SERVER_REPORT"

cd /tmp
pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 11 - Return to User Home Directory
# ============================================================

cd ~
pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 12 - Move One Directory Level Backward
# ============================================================

cd ..
pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 13 - Navigate to /var/log and Move Two Levels Back
# ============================================================

cd /var/log
pwd >> "$SERVER_REPORT"

cd ../../
pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 14 - Return to Previous Directory
# ============================================================

cd -
pwd >> "$SERVER_REPORT"


# ============================================================
# TASK 15 - Basic Server Health Check
# ============================================================

cd 
pwd >> "$SERVER_REVIEW_REPORT"
lscpu >> "$SERVER_REVIEW_REPORT"
free -h >> "$SERVER_REVIEW_REPORT"
lsblk >> "$SERVER_REVIEW_REPORT"
uname -a >> "$SERVER_REVIEW_REPORT"
uptime >> "$SERVER_REVIEW_REPORT"
whoami >> "$SERVER_REVIEW_REPORT"

echo "Lab tasks completed successfully."
