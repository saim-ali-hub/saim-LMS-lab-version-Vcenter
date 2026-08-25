#!/bin/bash

# Task 1
#cp -r /tmp/tar_lab ~
#chown -R "$USER:$USER" ~/tar_lab
#cd ~/tar_lab

# Task 2
tar -cvf project.tar project
ls -l

# Task 3
tar -tvf project.tar
tar -tvf project.tar > activity/project_tar.txt

# Task 4
cd backup
tar -xvf ../project.tar
ls -l

# Task 5
cd ..
pwd
tar -xvf project.tar -C restore
ls -l restore

# Task 6
tar -cvzf project.tar.gz project
ls -l
du -sh project
ls -lh project.tar project.tar.gz

# Task 7
tar -tvzf project.tar.gz
tar -tvzf project.tar.gz > activity/project_tar_gz.txt
cat activity/project_tar_gz.txt

# Task 8
tar -xvzf project.tar.gz -C activity
ls -l activity

# Task 9
tar -cvjf logs.tar.bz2 project/logs
ls -l
du -sh project/logs
ls -lh logs.tar.bz2

# Task 10
tar -tvjf logs.tar.bz2
tar -tvjf logs.tar.bz2 > activity/logs_tar_bz2.txt
cat activity/logs_tar_bz2.txt

# Task 11
tar -xvjf logs.tar.bz2 -C backup
ls -l backup

# Task 12
tar -cvf collaboration.tar project/reports project/scripts
tar -tvf collaboration.tar
tar -tvf collaboration.tar > activity/collaborative_tar1.txt

# Task 13
tar -rvf collaboration.tar project/images
tar -tvf collaboration.tar
tar -tvf collaboration.tar > activity/collaborative_tar2.txt
