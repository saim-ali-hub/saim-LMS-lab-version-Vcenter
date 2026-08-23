#!/bin/bash

# Lab 210 - Find Files and Directories in Linux Filesystem

set -e

HOME_DIR="$HOME"
BASE="$HOME_DIR/search_lab"

# ============================================================
# TASK 2 - Search by File Name
# ============================================================

find . -name "app.conf" -o -name "application.log" -o -name "database.conf" > tmp/file-name.txt

echo
echo "Matching files:"
cat tmp/file-name.txt

echo
echo "Task 2 completed."
echo

# ============================================================
# TASK 3 - Search by File and Directory Type
# ============================================================

echo "============================================================"
echo "TASK 3 - Practice find - Search by File and Directory Type"
echo "============================================================"

echo "Directories:"
find . -type d

echo
echo "Saving directories to tmp/search-dir.txt..."
find . -type d > tmp/search-dir.txt

echo
echo "Regular files:"
find . -type f

echo
echo "Saving regular files to tmp/search-file.txt..."
find . -type f > tmp/search-file.txt

echo
echo "Task 3 completed."
echo

# ============================================================
# TASK 4 - Search by File Extension
# ============================================================

echo "============================================================"
echo "TASK 4 - Practice find - Search by File Extension"
echo "============================================================"

# Start a new extension report
> tmp/extension.txt

echo "LOG files:"
find . -type f -name "*.log"
find . -type f -name "*.log" >> tmp/extension.txt

echo
echo "CONF files:"
find . -type f -name "*.conf"
find . -type f -name "*.conf" >> tmp/extension.txt

echo
echo "PROPERTIES files:"
find . -type f -name "*.properties"
find . -type f -name "*.properties" >> tmp/extension.txt

echo
echo "Task 4 completed."
echo

# ============================================================
# TASK 5 - Search by File Size
# ============================================================

echo "============================================================"
echo "TASK 5 - Practice find - Search by File Size"
echo "============================================================"

echo "Files less than 100M in logs directory:"
find logs -type f -size -100M

find logs -type f -size -100M > tmp/small-size.txt

echo
echo "Files larger than 100M in logs directory:"
find logs -type f -size +100M

find logs -type f -size +100M > tmp/large-size.txt

echo
echo "Task 5 completed."
echo

# ============================================================
# TASK 6 - Search by Modification Time
# ============================================================

echo "============================================================"
echo "TASK 6 - Practice find - Search by Modification Time"
echo "============================================================"

echo "Files modified within the last 30 days:"
find . -type f -mtime -30

# Lab specifically requests tmp/time-day.txt
find . -type f -mtime -30 > tmp/time-day.txt

echo
echo "Files modified in less than 1 minute:"
find . -type f -mmin -1

# Lab specifically requests tmp/time-min.txt
find . -type f -mmin -1 > tmp/time-min.txt

echo
echo "Task 6 completed."
echo

# ============================================================
# TASK 7 - Search by Permissions
# ============================================================

echo "============================================================"
echo "TASK 7 - Practice find - Search by Permissions"
echo "============================================================"

# Start a new permission report
> tmp/permission.txt

echo "Files with execute permission for both owner and group:"
find . -type f -perm -ug=x -exec ls -l {} \;

find . -type f -perm -ug=x -exec ls -l {} \; >> tmp/permission.txt

echo
echo "Files in scripts directory with SGID permission:"
find scripts -type f -perm -2000 -exec ls -l {} \; 

find scripts -type f -perm -2000 -exec ls -l {} \; >> tmp/permission.txt

# ============================================================
# TASK 8 - find with -exec
# ============================================================

echo "============================================================"
echo "TASK 8 - Practice find with -exec"
echo "============================================================"

# Start a new exec report
> tmp/exec.txt

find . -type f -name "*.log" -exec ls -l {} \; >> tmp/exec.txt

echo
echo "Detailed information for .log files:"
cat tmp/exec.txt

echo
echo "Task 8 completed."
echo

# ============================================================
# TASK 9 - find with Multiple Conditions
# ============================================================

echo "============================================================"
echo "TASK 9 - Practice find with Multiple Conditions"
echo "============================================================"

# Append Task 9 output to exec.txt
find . -type f -name "*.sh" -perm -ug=x -exec ls -l {} \; >> tmp/exec2.txt

echo
echo "Task 9 output:"
tail -n +1 tmp/exec.txt

echo
echo "Task 9 completed."
echo

# ============================================================
# TASK 10 - find with Multiple Conditions and cp
# ============================================================

echo "============================================================"
echo "TASK 10 - Practice find with Multiple Conditions and -exec cp"
echo "============================================================"

mkdir -p tmp/exec-dir/

find . -type f -name "*.sh" -perm -ug=x -exec cp {} tmp/exec-dir/ \;

echo
echo "Files copied to tmp/exec-dir:"
ls -l tmp/exec-dir

echo "Task 10 completed."

echo "Lab 210 completed successfully."
