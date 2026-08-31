#!/bin/bash

# Lab 215 - Simple Linux Process Management
# Student Task Completion Script

LAB_DIR="$HOME/lab215_vim"

echo "=============================================="
echo " Lab 215 - Linux Process Management"
echo "=============================================="

# ============================================================
# TASK 1 - CREATE WORKING DIRECTORY
# ============================================================

echo
echo "Task 1 - Creating working directory..."

mkdir -p "$LAB_DIR"
cd "$LAB_DIR" || exit 1

pwd

# ============================================================
# TASK 2 - VIEW RUNNING PROCESSES
# ============================================================

echo
echo "Task 2 - Viewing running processes..."

echo
echo "--- ps ---"
ps

echo
echo "--- ps -ef ---"
ps -ef

echo
echo "--- ps aux ---"
ps aux

# ============================================================
# TASK 3 - START BACKGROUND VIM PROCESSES
# ============================================================

echo
echo "Task 3 - Starting Vim processes in background..."

vim file1_bg.vim &
VIM1_PID=$!

vim file2_bg.vim &
VIM2_PID=$!

echo "Vim process 1 PID: $VIM1_PID"
echo "Vim process 2 PID: $VIM2_PID"

# Give processes a moment to start
sleep 1

# ============================================================
# TASK 4 - VIEW BACKGROUND JOBS
# ============================================================

echo
echo "Task 4 - Investigating background jobs..."

echo
echo "--- jobs ---"
jobs

echo
echo "--- ps -ef | grep vim ---"
ps -ef | grep vim

echo
echo "--- ps aux | grep vim ---"
ps aux | grep vim

echo
echo "--- Saving jobs output to bg.txt ---"

jobs > bg.txt

cat bg.txt

# ============================================================
# TASK 5 - TERMINATE VIM PROCESSES BY NAME
# ============================================================

echo
echo "Task 5 - Terminating Vim processes by name..."

echo
echo "--- Vim processes before termination ---"
pgrep -a -u "$USER" vim

# Terminate only Vim processes owned by the current student
pkill -u "$USER" vim

sleep 1

echo
echo "--- Vim processes after termination ---"
pgrep -a -u "$USER" vim || echo "No Vim processes remain."

# ============================================================
# TASK 6 - START MULTIPLE SLEEP PROCESSES
# ============================================================

echo
echo "Task 6 - Starting background sleep processes..."

sleep 5000 &
SLEEP5000_PID=$!

sleep 8000 &
SLEEP8000_PID=$!

sleep 10000 &
SLEEP10000_PID=$!

sleep 15000 &
SLEEP15000_PID=$!

sleep 20000 &
SLEEP20000_PID=$!

echo
echo "Created sleep processes:"
echo "sleep 5000  PID: $SLEEP5000_PID"
echo "sleep 8000  PID: $SLEEP8000_PID"
echo "sleep 10000 PID: $SLEEP10000_PID"
echo "sleep 15000 PID: $SLEEP15000_PID"
echo "sleep 20000 PID: $SLEEP20000_PID"

sleep 1

echo
echo "--- jobs ---"
jobs

echo
echo "--- Saving jobs output to bg.txt ---"
jobs > bg.txt

cat bg.txt

# ============================================================
# TASK 7 - TERMINATE SLEEP 5000 USING PID
# ============================================================

echo
echo "Task 7 - Terminating sleep 5000 using PID..."

echo "sleep 5000 PID: $SLEEP5000_PID"

ps -p "$SLEEP5000_PID" -o pid,ppid,user,stat,cmd

kill "$SLEEP5000_PID"

sleep 1

echo
echo "--- Verification ---"

if ps -p "$SLEEP5000_PID" > /dev/null 2>&1; then
    echo "sleep 5000 is still running."
else
    echo "sleep 5000 has been terminated."
fi

# ============================================================
# TASK 8 - GRACEFULLY TERMINATE SLEEP 8000
# ============================================================

echo
echo "Task 8 - Gracefully terminating sleep 8000..."

echo "sleep 8000 PID: $SLEEP8000_PID"

ps -p "$SLEEP8000_PID" -o pid,ppid,user,stat,cmd

kill -15 "$SLEEP8000_PID"

sleep 1

echo
echo "--- Verification ---"

if ps -p "$SLEEP8000_PID" > /dev/null 2>&1; then
    echo "sleep 8000 is still running."
else
    echo "sleep 8000 has been gracefully terminated."
fi

# ============================================================
# TASK 9 - FORCE TERMINATE SLEEP 10000
# ============================================================

echo
echo "Task 9 - Force terminating sleep 10000..."

echo "sleep 10000 PID: $SLEEP10000_PID"

ps -p "$SLEEP10000_PID" -o pid,ppid,user,stat,cmd

kill -9 "$SLEEP10000_PID"

sleep 1

echo
echo "--- Verification ---"

if ps -p "$SLEEP10000_PID" > /dev/null 2>&1; then
    echo "sleep 10000 is still running."
else
    echo "sleep 10000 has been forcefully terminated."
fi

# ============================================================
# TASK 10 - TERMINATE REMAINING SLEEP PROCESSES
# ============================================================

echo
echo "Task 10 - Checking remaining sleep processes..."

echo
echo "--- Remaining sleep processes ---"
pgrep -a -u "$USER" sleep

echo
echo "Terminating remaining sleep processes..."

pkill -u "$USER" sleep

sleep 1

echo
echo "--- Verification ---"

if pgrep -u "$USER" -x sleep > /dev/null 2>&1; then
    echo "Some sleep processes are still running."
else
    echo "No student-owned sleep processes remain."
fi

# ============================================================
# TASK 11 - COUNT ALL PROCESSES
# ============================================================

echo
echo "Task 11 - Counting processes..."

echo
echo "--- All processes ---"
ps -ef

echo
echo "--- Process count ---"

ps -ef | wc -l

echo
echo "--- Saving process count to process.txt ---"

ps -ef | wc -l > process.txt

echo
echo "--- process.txt ---"
cat process.txt

# ============================================================
# FINAL CLEANUP
# ============================================================

echo
echo "=============================================="
echo " Lab 215 cleanup"
echo "=============================================="

# Make sure no processes created by this script remain.
pkill -u "$USER" sleep 2>/dev/null
pkill -u "$USER" vim 2>/dev/null

echo
echo "Remaining student-owned sleep processes:"
pgrep -a -u "$USER" sleep || echo "None"

echo
echo "Remaining student-owned Vim processes:"
pgrep -a -u "$USER" vim || echo "None"

echo
echo "Lab 215 tasks completed."
echo "Working directory: $LAB_DIR"
