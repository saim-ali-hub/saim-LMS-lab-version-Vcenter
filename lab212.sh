#!/bin/bash

# ============================================================
# Lab 212 - Tape Archive (TAR) & Backup Management
# Complete Tasks 1-10
# ============================================================

set -e

BASE="$HOME/search_lab"

cd "$BASE"


# ============================================================
# TASK 1
# Create a Tar Archive
# ============================================================

echo "TASK 1 - Create a Tar Archive"

tar -cvf backup/application_backup.tar application

echo
echo "Listing contents of application_backup.tar:"
tar -tvf backup/application_backup.tar

echo
echo "Verifying application archive..."
tar -tf backup/application_backup.tar | grep -q '^application/'

echo "Task 1 completed successfully."
echo

# ============================================================
# TASK 2
# Create gzip-compressed archive
# ============================================================

echo "============================================================"
echo "TASK 2 - Create gzip-compressed Tar Archive"
echo "============================================================"

tar -czvf backup/configuration_backup.tar.gz configuration

echo
echo "Listing contents of configuration_backup.tar.gz:"
tar -tzvf backup/configuration_backup.tar.gz

echo
echo "Task 2 completed successfully."
echo

# ============================================================
# TASK 3
# Create bzip2-compressed archive
# ============================================================

echo "============================================================"
echo "TASK 3 - Create bzip2-compressed Tar Archive"
echo "============================================================"

tar -cjvf backup/logs_backup.tar.bz2 logs

echo
echo "Listing contents of logs_backup.tar.bz2:"
tar -tjvf backup/logs_backup.tar.bz2

echo
echo "Task 3 completed successfully."
echo

# ============================================================
# TASK 4
# Create xz-compressed archive
# ============================================================

echo "============================================================"
echo "TASK 4 - Create xz-compressed Tar Archive"
echo "============================================================"

tar -cJvf backup/reports_backup.tar.xz reports

echo
echo "Listing contents of reports_backup.tar.xz:"
tar -tJvf backup/reports_backup.tar.xz

echo
echo "Task 4 completed successfully."
echo

# ============================================================
# TASK 5
# Extract application archive
# ============================================================

echo "============================================================"
echo "TASK 5 - Extract and Verify Application Archive"
echo "============================================================"

mkdir -p tmp/restore_app

tar -xvf backup/application_backup.tar -C tmp/restore_app

echo "Task 5 completed successfully."
echo

# ============================================================
# TASK 6
# Extract configuration archive
# ============================================================

echo "============================================================"
echo "TASK 6 - Extract and Verify Configuration Archive"
echo "============================================================"

mkdir -p tmp/restore_config

tar -xzvf backup/configuration_backup.tar.gz -C tmp/restore_config

echo "Task 6 completed successfully."
echo

# ============================================================
# TASK 7
# Find all .log files and save long-list output
# ============================================================

echo "============================================================"
echo "TASK 7 - Find .log Files"
echo "============================================================"

find . -type f -name "*.log" -exec ls -l {} \; > tmp/final_report.txt

echo
echo "Task 7 completed successfully."
echo

# ============================================================
# TASK 8
# Find .conf files and search for DATABASE
# ============================================================

echo "============================================================"
echo "TASK 8 - Find .conf Files and Search for DATABASE"
echo "============================================================"

find . -type f -name "*.conf" -exec grep -l "DATABASE" {} \; >> tmp/final_report.txt

echo
echo "Task 8 completed successfully."
echo

# ============================================================
# TASK 9
# Create final compressed archive
# ============================================================

echo "============================================================"
echo "TASK 9 - Create Final Compressed Archive"
echo "============================================================"

tar -czvf archive/search_lab_backup.tar.gz application configuration logs reports scripts

tar -tzvf archive/search_lab_backup.tar.gz
echo
echo "Task 9 completed successfully."
echo


# ============================================================
# TASK 10
# Extract final archive
# ============================================================

echo "============================================================"
echo "TASK 10 - Extract Final Archive"
echo "============================================================"

mkdir -p tmp/final_restore

tar -xzvf archive/search_lab_backup.tar.gz -C tmp/final_restore

echo "Verifying final restore..."


echo "Lab 212 completed successfully."
