#!/bin/bash

# Task 1
pwd
mkdir my_own_dir
ls -ld my_own_dir

# Task 2
chmod u=rw,g=r,o=r my_own_dir
ls -ld my_own_dir
ls my_own_dir

# Task 3
cd my_own_dir
cd ~

# Task 4
mkdir my_own_dir/Redhat

# Task 5
chmod u=rwx,g=rwx,o=rx my_own_dir
ls -ld my_own_dir
mkdir my_own_dir/Redhat
mkdir my_own_dir/OEL
ls -ld my_own_dir/Redhat
ls -ld my_own_dir/OEL

# Task 6
chmod -R 775 my_own_dir
ls -ld my_own_dir
ls -ld my_own_dir/Redhat
ls -ld my_own_dir/OEL

# Task 7
cd ~/my_own_dir
echo "I love Linux" > file_1.txt
mkdir dir_1
ls -l file_1.txt
ls -ld dir_1

# Task 8
chmod u-r file_1.txt
chmod g-r file_1.txt
chmod o-r file_1.txt
ls -l file_1.txt

# Task 9
cat file_1.txt

# Task 10
chmod u+r file_1.txt
chmod g+r file_1.txt
chmod o+r file_1.txt
ls -l file_1.txt
cat file_1.txt

# Task 11
chmod u-w file_1.txt
chmod g-w file_1.txt
ls -l file_1.txt

# Task 12
echo "File permission setting is fun" >> file_1.txt

# Task 13
chmod u+w file_1.txt
chmod g+w file_1.txt
ls -l file_1.txt

# Task 14
echo "File permission setting is fun" >> file_1.txt
cat file_1.txt

# Task 15
chmod u+x file_1.txt
ls -l file_1.txt

# Task 16
chmod u-r dir_1
chmod g-x dir_1
chmod o-x dir_1
ls -ld dir_1

# Task 17
ls -ld dir_1 > Redhat/new_info
ls -l Redhat/new_info
cat Redhat/new_info

# Task 18
cp Redhat/new_info OEL/
ls -l OEL

# Task 19
chmod 777 dir_1
ls -ld dir_1

# Task 20
cp OEL/new_info OEL/new_info.txt
ls -l OEL
