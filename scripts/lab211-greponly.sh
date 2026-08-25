#!/bin/bash

# ============================================================
# Lab 211 - Global Regular Expression (Grep)
# Complete Tasks 1-20
# ============================================================

set -e

BASE="$HOME/search_lab"

cd "$BASE"

# ============================================================
# TASK 1 - postfix in passwd
# ============================================================

echo "TASK 1 - Search passwd for operator"

grep "operator" archive/passwd >> tmp/grep.txt

echo "Task 1 completed."
echo

# ============================================================
# TASK 2 - polkitd in group
# ============================================================

echo "TASK 2 - Search group for polkitd"

grep "polkitd" archive/group >> tmp/grep.txt

echo "Task 2 completed."
echo

# ============================================================
# TASK 3 - shutdown in passwd
# ============================================================

echo "TASK 3 - Search passwd for shutdown"

grep "shutdown" archive/passwd >> tmp/grep.txt

echo "Task 3 completed."
echo

# ============================================================
# TASK 4 - mail in group
# ============================================================

echo "TASK 4 - Search group for mail"

grep "mail" archive/group >> tmp/grep.txt

echo "Task 4 completed."
echo

# ============================================================
# TASK 5 - Lines NOT containing search
# ============================================================

echo "TASK 5 - Display lines from resolv.conf except search"

grep -v "search" archive/resolv.conf >> tmp/grep.txt

echo "Task 5 completed."
echo

# ============================================================
# TASK 6 - grep -n bash
# ============================================================

echo "TASK 6 - Search passwd for bash with line numbers"

grep -n "bash" archive/passwd >> tmp/option.txt

echo "Task 6 completed."
echo

# ============================================================
# TASK 7 - grep -i MAIL
# ============================================================

echo "TASK 7 - Case-insensitive search for MAIL"

grep -i "MAIL" archive/group >> tmp/option.txt

echo "Task 7 completed."
echo

# ============================================================
# TASK 8 - grep -v nameserver
# ============================================================

echo "TASK 8 - Display lines not containing nameserver"

grep -v "nameserver" archive/resolv.conf >> tmp/option.txt

echo "Task 8 completed."
echo

# ============================================================
# TASK 9 - grep -c nologin
# ============================================================

echo "TASK 9 - Count lines containing nologin"

grep -c "nologin" archive/passwd >> tmp/option.txt

echo "Task 9 completed."
echo

# ============================================================
# TASK 10 - grep -i -n permit
# ============================================================

echo "TASK 10 - Case-insensitive search for permit with line numbers"

grep -i -n "permit" archive/sshd_config >> tmp/option.txt

echo "Task 10 completed."
echo

# ============================================================
# TASK 11 - grep -l localhost
# ============================================================

echo "TASK 11 - Display filenames containing localhost"

grep -l "localhost" archive/* >> tmp/option.txt

echo "Task 11 completed."
echo

# ============================================================
# TASK 12 - Recursive grep Production
# ============================================================

echo "TASK 12 - Recursive search for Production"

grep -r "Production" application configuration >> tmp/recursive.txt

echo "Task 12 completed."
echo

# ============================================================
# TASK 13 - Recursive grep customerdb
# ============================================================

echo "TASK 13 - Recursive search for customerdb"

grep -r "customerdb" application configuration >> tmp/recursive.txt

echo "Task 13 completed."
echo

# ============================================================
# TASK 14 - Recursive grep 8080
# ============================================================

echo "TASK 14 - Recursive search for 8080"

grep -r "8080" application configuration >> tmp/recursive.txt

echo "Task 14 completed."
echo

# ============================================================
# TASK 15 - Recursive grep root in archive
# ============================================================

echo "TASK 15 - Search archive files for root"

grep -r "root" archive >> tmp/recursive.txt

echo "Task 15 completed."
echo

# ============================================================
# TASK 16 - Recursive grep nameserver in archive
# ============================================================

echo "TASK 16 - Search archive files for nameserver"

grep -rl "nameserver" archive >> tmp/recursive.txt

echo "Task 16 completed."
echo

# ============================================================
# TASK 17 - Empty lines with line numbers
# ============================================================

echo "TASK 17 - Display empty lines with line numbers"

grep -n '^$' archive/sshd_config > tmp/regexp.txt

echo "Task 17 completed."
echo

# ============================================================
# TASK 18 - Lines starting with #
# ============================================================

echo "TASK 18 - Display lines starting with #"

grep '^#' archive/sshd_config >> tmp/regexp.txt

echo "Task 18 completed."
echo

# ============================================================
# TASK 19 - Lines starting with # with line numbers
# ============================================================

echo "TASK 19 - Display lines starting with # with line numbers"

grep -n '^#' archive/sshd_config >> tmp/regexp.txt

echo "Task 19 completed."
echo

# ============================================================
# TASK 20 - Count lines starting with #
# ============================================================

echo "TASK 20 - Count lines starting with #"

grep -c '^#' archive/sshd_config >> tmp/regexp.txt

echo "Task 20 completed."
echo

echo "Lab 211 completed successfully."
