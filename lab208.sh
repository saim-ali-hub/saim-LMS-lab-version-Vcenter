#!/bin/bash

# ============================================================
# Lab 208 - Linux File Links: Hard Links and Soft Links
# ============================================================

LAB="$HOME/links_lab"

echo "Lab 208 - Linux File Links"

# Task 1 - Create the Lab Directory Structure
echo "Task 1: Creating Lab Directory Structure..."

mkdir -p "$LAB"/{data,reports,backup,tmp,application}

touch "$LAB/data/customer.txt"
touch "$LAB/data/application.log"

cd "$LAB" || exit 1

# Task 2 - Create and Verify the Original File
echo "Task 2: Creating customer.txt content..."

echo "Customer Database" >> data/customer.txt
echo "Application: Customer Portal" >> data/customer.txt
echo "Environment: Production" >> data/customer.txt

# Task 3 - Create a Hard Link
echo "Task 3: Creating hard link..."

ln data/customer.txt reports/customer_hard.txt

# Task 4 - Verify Same Inode
echo "Task 4: Comparing inode numbers..."

ls -li data/customer.txt reports/customer_hard.txt

# Task 5 - Modify Original File
echo "Task 5: Modifying original file..."

echo "Last Updated: 2026-08-16" >> data/customer.txt
cp data/customer.txt tmp/task5_customer.txt
# Task 6 - Modify File Through Hard Link
echo "Task 6: Modifying file through hard link..."

echo "Updated By: Reporting Team" >> reports/customer_hard.txt
cp data/customer.txt tmp/task6_customer.txt

# Task 7 - Create Symbolic Link
echo "Task 7: Creating symbolic link..."

ln -s ../data/customer.txt application/customer_soft.txt

# Task 8 - Compare Original, Hard Link and Soft Link
echo "Task 8: Comparing inode information..."

ls -li data/customer.txt reports/customer_hard.txt application/customer_soft.txt

# Task 9 - Create Hard Link to Application Log
echo "Task 9: Creating application log..."

echo "Application: Started" >> data/application.log
echo "Database Connection: Successful" >> data/application.log
echo "Application Status: Running" >> data/application.log

ln data/application.log backup/application_hard.log

# Task 10 - Create Symbolic Link to Application Log
echo "Task 10: Creating symbolic link to application log..."

ln -s ../data/application.log reports/application_soft.log

# Task 11 - Compare Hard Link, Soft Link and Copy
echo "Task 11: Creating normal copy..."

cp data/application.log backup/application_copy.log

echo "Here is new update" >> data/application.log

# Task 12 - Delete Original File and Test Hard Link
echo "Task 12: Removing original customer.txt..."

rm data/customer.txt

# Task 13 - Test Symbolic Link After Target Deleted
echo "Task 13: Testing symbolic link after target deletion..."

# Task 14 - Re-create Original Filename
echo "Task 14: Re-creating customer.txt..."

echo "Customer Database" >> data/customer.txt
echo "Application: Customer Portal" >> data/customer.txt
echo "Environment: Production" >> data/customer.txt
echo "Status: Restored" >> data/customer.txt

# Task 15 - Create Symbolic Link to Directory
echo "Task 15: Creating symbolic link to data directory..."

ln -s data production_data

# Task 16 - Move Symbolic-Link Target
echo "Task 16: Moving application.log..."

mv data/application.log backup/application.log

# Task 17 - Safely Remove Links
echo "Task 17: Removing links..."

rm application/customer_soft.txt
rm reports/application_soft.log
rm production_data

rm reports/customer_hard.txt
rm backup/application_hard.log

echo "Lab 208 Completed Successfully!"
