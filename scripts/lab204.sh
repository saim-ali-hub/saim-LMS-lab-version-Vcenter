#!/bin/bash

# Lab 204 – Linux Filesystem Navigation and Basic Commands
# This script assumes it is executed by the user from their home directory.

# Move to the user's home directory
cd "$HOME" || exit 1

echo "Starting Lab 204..."

# 1. Create nested directory structure
mkdir -p vars/systems/logs

# 2. Create empty files
touch vars/systems/passwd_tail
touch vars/systems/group_head

# 3. Create file1.txt with the required text
echo "I love linux and excited to join the DevOps course" > vars/systems/logs/file1.txt

# 4. Create second nested directory structure
mkdir -p vars/os/configs

# 5. Copy /etc/hosts into vars directory
cp /etc/hosts vars/

# 6. Display hosts file and redirect standard output to hosts.bak
cat vars/hosts > vars/os/hosts.bak

# 7. Search /etc/passwd for "chrony" and save matching output
cat /etc/passwd | grep "chrony" > vars/os/configs/chrony_info

# 8. Copy file1.txt and rename it to new_file1.txt
cp vars/systems/logs/file1.txt vars/os/new_file1.txt

# 9. Display last 10 lines of /etc/passwd and append to passwd_tail
tail -n 10 /etc/passwd >> vars/systems/passwd_tail

# 10. Display first 10 lines of /etc/group and append to group_head
head -n 10 /etc/group >> vars/systems/group_head

