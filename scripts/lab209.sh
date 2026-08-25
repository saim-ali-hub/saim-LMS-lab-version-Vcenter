#!/bin/bash

# Lab 207 - Onboarding Ticket

# Task 1
cd
pwd
ls -l /tmp/onboarding_kit

# Task 2
cat /tmp/onboarding_kit/TICKET_4471.txt

# Task 3
mkdir ~/webshop
cd ~/webshop

# Task 4
mkdir app docs secrets reports

# Task 5
mkdir -p app/src/utils

# Task 6
touch reports/onboarding_report.txt
ls -l

# Task 7
whoami >> reports/server_audit.txt
id >> reports/server_audit.txt

# Task 8
pwd >> reports/server_audit.txt
uname -a >> reports/server_audit.txt
uptime >> reports/server_audit.txt
free -h >> reports/server_audit.txt

# Task 9
cat reports/server_audit.txt
head -n 3 reports/server_audit.txt

# Task 10
cp /tmp/onboarding_kit/app_template.sh app/start.sh

# Task 11
cp /tmp/onboarding_kit/handbook.txt docs/

# Task 12
cp /tmp/onboarding_kit/welcome_template.txt ~/webshop/docs/welcome_badsha.txt

# Task 13
cp /tmp/onboarding_kit/db_password.txt secrets/

# Task 14
echo "Welcome badsha! Your admin is: $(whoami)" >> docs/welcome_badsha.txt

# Task 15
cp -r docs reports/docs_backup
mv reports/docs_backup reports/docs_archive

# Task 16
head -5 /tmp/onboarding_kit/access_requests.log
tail -3 /tmp/onboarding_kit/access_requests.log

# Task 17
grep "badsha" /tmp/onboarding_kit/team_roster.txt

# Task 18
grep "badsha" /tmp/onboarding_kit/access_requests.log

# Task 19
grep "badsha" /tmp/onboarding_kit/team_roster.txt > reports/badsha_access.txt
grep "badsha" /tmp/onboarding_kit/access_requests.log >> reports/badsha_access.txt
cat reports/badsha_access.txt

# Task 20
chmod 775 app
ls -ld app

# Task 21
chmod u+x app/start.sh
ls -l app/start.sh

# Task 22
chmod 770 secrets
chmod 660 secrets/db_password.txt
ls -ld secrets
ls -l secrets/db_password.txt

# Task 23
ls -l docs/welcome_badsha.txt
sudo chown badsha docs/welcome_badsha.txt
ls -l docs/welcome_badsha.txt

# Task 24
sudo chgrp developers app/start.sh
ls -l app/start.sh

# Task 25
sudo chgrp -R developers app
ls -ld app
ls -l app app/src

# Task 26
sudo chown -R $(whoami):admins secrets
ls -ld secrets
ls -l secrets

# Task 27
chown root docs/handbook.txt

# Task 28
echo "badsha onboarded by $(whoami)" >> reports/onboarding_report.txt
mv reports/onboarding_report.txt reports/TICKET_4471_DONE.txt
