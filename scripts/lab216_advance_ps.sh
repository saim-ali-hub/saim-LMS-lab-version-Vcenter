#!/bin/bash

# ============================================================
# Lab 216 - Advanced Linux Process Management
# Solution Script
# ============================================================

BASE="$HOME/lab216_challenge_vim"

echo "=============================================="
echo " Lab 216 - Advanced Linux Process Management"
echo "=============================================="

# ============================================================
# TASK 1 - WORKSPACE
# ============================================================

echo
echo "Task 1 - Create Workspace"

mkdir -p "$BASE"
cd "$BASE" || exit 1

pwd

# ============================================================
# TASK 2 - FIND SSHD PROCESS
# ============================================================

echo
echo "Task 2 - Find sshd Process"
pgrep -a sshd >> sshd.txt

# ============================================================
# TASK 3 - START BACKGROUND SLEEP PROCESSES
# ============================================================

echo
echo "Task 3 - Start Background Processes"

sleep 5000 &
sleep 8000 &
sleep 10000 &
sleep 15000 &
sleep 20000 &

sleep 1

echo
echo "Background jobs:"

jobs

jobs > bg.txt

echo
echo "Contents of bg.txt:"
cat bg.txt

# ============================================================
# TASK 4 - FOREGROUND / STOP / RESUME
# ============================================================

echo
echo "Task 4 - Foreground and Job Control"

# Find the job associated with sleep 5000
JOB_5000=$(jobs -l | awk '/sleep 5000/ {gsub(/[\[\]]/, "", $1); print $1; exit}')

echo "sleep 5000 Job ID: $JOB_5000"

# In an automated script we cannot press Ctrl+Z interactively.
# Instead, obtain the PID and stop it using SIGSTOP.

PID_5000=$(pgrep -u "$USER" -f '^sleep 5000$' | head -1)

echo "sleep 5000 PID: $PID_5000"

if [ -n "$PID_5000" ]; then
    kill -STOP "$PID_5000"
fi

sleep 1

echo
echo "Stopped process:"
ps -o pid,ppid,stat,cmd -p "$PID_5000"

# Resume in background equivalent
if [ -n "$PID_5000" ]; then
    kill -CONT "$PID_5000"
fi

sleep 1

echo
echo "Resumed process:"
ps -o pid,ppid,stat,cmd -p "$PID_5000"

# ============================================================
# TASK 5 - TERMINATE SLEEP 5000 USING PID
# ============================================================

echo
echo "Task 5 - Terminate sleep 5000"

if [ -n "$PID_5000" ]; then
    kill "$PID_5000"
fi

sleep 1

if pgrep -u "$USER" -f '^sleep 5000$' >/dev/null; then
    echo "sleep 5000 is still running"
else
    echo "sleep 5000 terminated successfully"
fi

echo
echo "Remaining sleep processes:"
pgrep -a -u "$USER" sleep

# ============================================================
# TASK 6 - PARENT / CHILD PROCESS
# ============================================================

echo
echo "Task 6 - Parent and Child Processes"

PID_SLEEP=$(pgrep -u "$USER" -f '^sleep 8000$' | head -1)

if [ -n "$PID_SLEEP" ]; then

    echo
    echo "Sleep process:"
    ps -o pid,ppid,comm -p "$PID_SLEEP"

    PPID_SLEEP=$(ps -o ppid= -p "$PID_SLEEP" | tr -d ' ')

    echo
    echo "Parent process:"
    ps -o pid,ppid,comm -p "$PPID_SLEEP"

    echo
    echo "Process relationship:"
    echo "Child PID : $PID_SLEEP"
    echo "Parent PID: $PPID_SLEEP"

fi

# ============================================================
# TASK 7 - TERMINATE REMAINING SLEEP PROCESSES
# ============================================================

echo
echo "Task 7 - Terminate Remaining Sleep Processes"

echo "Sleep processes before cleanup:"
pgrep -a -u "$USER" sleep

# Only terminate sleep processes owned by current user
pkill -u "$USER" sleep

sleep 1

echo
echo "Sleep processes after cleanup:"

if pgrep -u "$USER" sleep >/dev/null; then
    pgrep -a -u "$USER" sleep
else
    echo "No student sleep processes remain."
fi

# ============================================================
# TASK 8 - START PROCESS WITH NICE VALUE 10
# ============================================================

echo
echo "Task 8 - Start Process with Nice Value 10"

nice -n 10 sleep 20000 &

sleep 1

NICE_PID=$(pgrep -u "$USER" -f '^sleep 20000$' | head -1)

echo "Nice process PID: $NICE_PID"

if [ -n "$NICE_PID" ]; then
    ps -o pid,ppid,user,ni,cmd -p "$NICE_PID" | tee nice_value.txt
else
    echo "Unable to find nice process."
fi

# ============================================================
# TASK 9 - CHANGE NICE VALUE TO 15
# ============================================================

echo
echo "Task 9 - Change Process Priority"

if [ -n "$NICE_PID" ]; then

    renice -n 15 -p "$NICE_PID"

    echo
    echo "Updated process priority:"

    ps -o pid,ppid,user,ni,cmd -p "$NICE_PID" | tee renice_value.txt

fi

# ============================================================
# TASK 10 - FINAL CLEANUP
# ============================================================

echo
echo "Task 10 - Final Process Cleanup"

echo "Processes before cleanup:"
pgrep -a -u "$USER" sleep

# Terminate lab-created sleep processes
pkill -u "$USER" sleep

sleep 1

echo
echo "Processes after cleanup:"

if pgrep -u "$USER" sleep >/dev/null; then
    pgrep -a -u "$USER" sleep
else
    echo "No student sleep processes remain."
fi

echo
echo "Background jobs:"
jobs

# ============================================================
# TASK 11 - SORT PROCESSES BY CPU
# ============================================================

echo
echo "Task 11 - Processes Sorted by CPU Usage"

ps -eo pid,ppid,user,%cpu,%mem,state,cmd --sort=-%cpu > sort_process_cpu.txt 

# ============================================================
# FINAL VERIFICATION
# ============================================================

echo
echo "=============================================="
echo " Final Verification"
echo "=============================================="

echo
echo "Lab directory:"
ls -lh "$BASE"

echo
echo "Remaining student sleep processes:"
if pgrep -u "$USER" sleep >/dev/null; then
    pgrep -a -u "$USER" sleep
else
    echo "None"
fi

echo
echo "Remaining student Vim processes:"
if pgrep -u "$USER" vim >/dev/null; then
    pgrep -a -u "$USER" vim
else
    echo "None"
fi

echo
echo "Required evidence files:"
ls -l top.txt bg.txt nice_value.txt renice_value.txt 2>/dev/null

echo
echo "Lab 216 solution completed."
