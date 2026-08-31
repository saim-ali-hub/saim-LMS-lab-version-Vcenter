#!/bin/bash

# Task 1
#cp -r /tmp/search_lab "$HOME/"
cd "$HOME/search_lab"

# Task 2
find . -type f \( -name "app.conf" -o -name "application.log" -o -name "database.conf" \) > tmp/file-name.txt

# Task 3
find . -type d
find . -type d > tmp/search-dir.txt

find . -type f
find . -type f > tmp/search-file.txt

# Task 4
find logs -type f -size -100M > tmp/small-size.txt
find logs -type f -size +100M > tmp/large-size.txt

# Task 5
find . -type f -mtime -30 > tmp/time-day.txt
find . -type f -mmin -1 > tmp/time-min.txt

# Task 6 - Task 10
grep "operator" archive/passwd >> tmp/grep.txt
grep "polkitd" archive/group >> tmp/grep.txt
grep "shutdown" archive/passwd >> tmp/grep.txt
grep "mail" archive/group >> tmp/grep.txt
grep -v "search" archive/resolv.conf >> tmp/grep.txt

# Task 11
grep -n "bash" archive/passwd >> tmp/option.txt

# Task 12
grep -i "MAIL" archive/group >> tmp/option.txt

# Task 13
grep -v "nameserver" archive/resolv.conf >> tmp/option.txt
