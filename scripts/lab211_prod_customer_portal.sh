#!/bin/bash

# Lab 211 – Production Customer Portal File Management and Backup


# Task 1
#cp -r /tmp/lab211_review ~
#chown -R "$USER:$USER" ~/lab211_review
cd ~/lab211_review
pwd
ls -l
find . -maxdepth 3 -type d


# Task 2
cd application
chmod 640 README.txt
chmod 750 bin
chmod 750 config
ls -ld README.txt bin config


# Task 3
cd ../scripts
chmod u+rwx,g+rx,o-rwx backup.sh
chmod u+rwx,g+rx,o-rwx cleanup.sh
chmod u+rwx,g+rx,o-rwx monitor.sh
ls -l backup.sh cleanup.sh monitor.sh


# Task 4
cd ../reports
chmod -R u+rwx,g+rx,o-rwx daily monthly
ls -l daily
ls -l monthly


# Task 5
cd ../scripts
sudo chown smith:admins backup.sh cleanup.sh monitor.sh
ls -l backup.sh cleanup.sh monitor.sh


# Task 6
cd ..
sudo chgrp -R developers shared
chmod 770 shared
ls -ld shared
ls -l shared


# Task 7
ln data/customers/customers.txt reports/daily/customer_data.txt
ls -li data/customers/customers.txt reports/daily/customer_data.txt


# Task 8
ln -s ../../data/customers/customers.txt application/config/customer_data
ls -l application/config/customer_data


# Task 9
tar -cvf archive/appdata.tar application data
ls -l archive/appdata.tar


# Task 10
tar -rvf archive/appdata.tar shared/
tar -tvf archive/appdata.tar


# Task 11
tar -tvf archive/appdata.tar
tar -tvf archive/appdata.tar > tmp/appdata_tar
cat tmp/appdata_tar


# Task 12
tar -xvf archive/appdata.tar -C restore
ls -l restore
find restore -maxdepth 3 -type f


# Task 13
tar -cvzf archive/logs.tar.gz logs
ls -lh archive/logs.tar.gz


# Task 14
tar -xvzf archive/logs.tar.gz -C backup
ls -l backup
find backup/logs -type f


# Task 15
tar -cvjf archive/reports.tar.bz2 reports
ls -lh archive/reports.tar.bz2


# Task 16
tar -xvjf archive/reports.tar.bz2 -C tmp
ls -l tmp
find tmp/reports -type f
