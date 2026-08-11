#!/bin/bash

# ============================================================
# Lab 202 - Linux File System Navigation and File Management
# ============================================================

set -e

HOME_DIR="$HOME"
BASE="$HOME_DIR/linux_lab"

# ============================================================
# PART 1 - CREATE DIRECTORY STRUCTURE
# ============================================================

# Task 1
cd "$HOME_DIR"
mkdir -p "$BASE"

# Task 2
cd "$BASE"

# Task 3
mkdir -p projects backups

# Task 4
mkdir -p projects/project1 projects/project2

# Task 5
mkdir -p documents/scripts
mkdir -p reports/notes


# ============================================================
# PART 2 - CREATE FILES
# ============================================================

# Task 6
touch projects/project1/inventory.txt

# Task 7
touch documents/scripts/daily.sh

# Task 8
touch reports/summary.txt

# Task 9
echo "Linux is my backbone and I really love Linux." \
    > projects/project1/users.txt


# ============================================================
# PART 3 - COPY FILES
# ============================================================

# Task 10
# Copy inventory.txt from project1 to project2
# using a relative path.
cp projects/project1/inventory.txt \
   projects/project2/

# Task 11
# Copy users.txt from project1 to reports
# using an absolute path.
cp "$BASE/projects/project1/users.txt" \
   "$BASE/reports/"

# Task 12
# Copy summary.txt from reports to notes.
cp reports/summary.txt \
   reports/notes/

# Task 13
# Copy daily.sh into project1.
cp documents/scripts/daily.sh \
   projects/project1/

# Task 14
# Copy the entire project1 directory into backups.
cp -r projects/project1 \
      backups/


# ============================================================
# PART 4 - MOVE AND RENAME FILES
# ============================================================

# Task 15
# Rename inventory.txt in project2.
mv projects/project2/inventory.txt \
   projects/project2/inventory_backup.txt

# Task 16
# Rename daily.sh in the backup copy of project1.
mv backups/project1/daily.sh \
   backups/project1/startup.sh

# Task 17
# Move users.txt from reports into project2.
mv reports/users.txt \
   projects/project2/

# Task 18
# Rename project2 to production.
mv projects/project2 \
   projects/production


# ============================================================
# PART 5 - ABSOLUTE AND RELATIVE PATH PRACTICE
# ============================================================

# Task 19
# Return to home directory and navigate to notes
# using an absolute path.
cd
cd "$BASE/reports/notes"

# Task 20
# Return to linux_lab using a relative path.
cd ../..

# Task 21
# From linux_lab, navigate to production
# using a relative path.
cd projects/production


# ============================================================
# FINAL STATUS
# ============================================================

echo
echo "============================================================"
echo "Lab202 completed successfully."
echo "============================================================"
