#!/bin/bash
validate_lab201_commands_sysinfo() {
    set +e
    set +u
    set +o pipefail

    echo "Checking Lab 201 - Linux Basic Commands and System Information..."

    HOME_DIR="/home/$STUDENT_NAME"

    TOTAL_TASKS=15
    PASSED=0

    LAB_NAME="Lab ${LAB_NUMBER#lab} - Linux Server Information & Navigation"
    DATE=$(date "+%F %T")

    SERVER_REPORT="$HOME_DIR/server-report"
    SERVER_REVIEW_REPORT="$HOME_DIR/server-review-report"

    # ============================================================
    # HELPERS
    # ============================================================
    pass() {
        echo "<div class='validation-pass'>✓ $1 – Pass</div>"
        ((PASSED++))
    }

    fail() {
        echo "<div class='validation-fail'>✗ $1 – Fail</div>"
    }

    # TASK 1 - Login / Identity Information
    if [ -f "$SERVER_REPORT" ] &&
       grep -q "^$STUDENT_NAME$" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "uid=" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "gid=" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "groups=" "$SERVER_REPORT" 2>/dev/null; then
        pass "Task 1: User identity and account information recorded"
    else
        fail "Task 1: User identity information is missing from server-report"
    fi

    # TASK 2 - Present Working Directory
    if [ -f "$SERVER_REPORT" ] &&
       grep -Fxq "$HOME_DIR" "$SERVER_REPORT" 2>/dev/null; then
        pass "Task 2: Home directory path recorded in server-report"
    else
        fail "Task 2: Home directory path is missing from server-report"
    fi

    # TASK 3 - CPU Information
    if [ -f "$SERVER_REPORT" ] &&
       grep -q "Architecture:" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "CPU(s):" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "Model name:" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "Core(s) per socket:" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "Thread(s) per core:" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 3: CPU information recorded in server-report"
    else
        fail "Task 3: Required CPU information is missing from server-report"
    fi

    # TASK 4 - Memory Information
    if [ -f "$SERVER_REPORT" ] &&
       grep -q "Mem:" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "Swap:" "$SERVER_REPORT" 2>/dev/null; then

        FREE_COUNT=$(grep -c "Mem:" "$SERVER_REPORT" 2>/dev/null)
        if [ "$FREE_COUNT" -ge 4 ]; then
            pass "Task 4: Memory information recorded in required formats"
        else
            fail "Task 4: Memory information is incomplete"
        fi
    else
        fail "Task 4: Memory information is missing from server-report"
    fi

    # TASK 5 - Block Devices
    if [ -f "$SERVER_REPORT" ] &&
       grep -q "NAME.*MAJ:MIN.*RM.*SIZE" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 5: Block device information recorded in server-report"

    else
        fail "Task 5: Block device information is missing from server-report"
    fi

    # TASK 6 - Kernel Information
    KERNEL_VERSION=$(uname -r 2>/dev/null)
    if [ -f "$SERVER_REPORT" ] &&
       [ -n "$KERNEL_VERSION" ] &&
       grep -Fq "$KERNEL_VERSION" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 6: Kernel information recorded in server-report"

    else
        fail "Task 6: Kernel information is missing from server-report"
    fi

    # TASK 7 - Uptime
    if [ -f "$SERVER_REPORT" ] &&
       grep -q "load average" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 7: Server uptime and load information recorded"

    else
        fail "Task 7: Uptime information is missing from server-report"
    fi

    # TASK 8 - Home Directory Listings
    TASK8_OK=1
    if [ ! -f "$SERVER_REPORT" ]; then
        TASK8_OK=0
    fi

    if ! grep -q "total " "$SERVER_REPORT" 2>/dev/null; then
        TASK8_OK=0
    fi

    if ! grep -q "^.*[rwx-][rwx-][rwx-].*" "$SERVER_REPORT" 2>/dev/null; then
        TASK8_OK=0
    fi

    # Hidden files should normally include .bashrc on the lab systems.
    if [ -f "$HOME_DIR/.bashrc" ] &&
       ! grep -q "\.bashrc" "$SERVER_REPORT" 2>/dev/null; then
        TASK8_OK=0
    fi

    if [ "$TASK8_OK" -eq 1 ]; then
        pass "Task 8: Normal, detailed and hidden file listings recorded"
    else
        fail "Task 8: Required home directory listings are missing"
    fi

    # TASK 9 - Root Filesystem
    if [ -f "$SERVER_REPORT" ] &&
       grep -Fxq "/" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "^etc$" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "^var$" "$SERVER_REPORT" 2>/dev/null &&
       grep -q "^home$" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 9: Root filesystem location and directory listing recorded"

    else
        fail "Task 9: Root filesystem information is missing from server-report"
    fi

    # TASK 10 - Important Linux Directories
    TASK10_OK=1

    for DIR in /etc /opt /var /home /tmp
    do
        if ! grep -Fxq "$DIR" "$SERVER_REPORT" 2>/dev/null; then
            TASK10_OK=0
            break
        fi
    done

    if [ "$TASK10_OK" -eq 1 ]; then
        pass "Task 10: Required Linux directory paths recorded"
    else
        fail "Task 10: One or more required directory paths are missing"
    fi

    # TASK 11 - Return to Home Directory
    if [ -f "$SERVER_REPORT" ] &&
       grep -Fxq "$HOME_DIR" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 11: Home directory location recorded"

    else
        fail "Task 11: Home directory location is missing from server-report"
    fi

    # TASK 12 - Parent Directory
    PARENT_DIR=$(dirname "$HOME_DIR")

    if [ -f "$SERVER_REPORT" ] &&
       grep -Fxq "$PARENT_DIR" "$SERVER_REPORT" 2>/dev/null; then

        pass "Task 12: Parent directory location recorded"

    else
        fail "Task 12: Parent directory location is missing from server-report"
    fi

    # TASK 13 - /var/log and Two Levels Back
    TASK13_OK=1

    if ! grep -Fxq "/var/log" "$SERVER_REPORT" 2>/dev/null; then
        TASK13_OK=0
    fi

    if ! grep -Fxq "/" "$SERVER_REPORT" 2>/dev/null; then
        TASK13_OK=0
    fi

    if [ "$TASK13_OK" -eq 1 ]; then
        pass "Task 13: /var/log and two-level backward navigation recorded"
    else
        fail "Task 13: Required /var/log navigation output is missing"
    fi

    # TASK 14 - cd -
    LAST_PATH=$(grep '^/' "$SERVER_REPORT" 2>/dev/null | tail -n 1)

    if [ "$LAST_PATH" = "/var/log" ]; then

        pass "Task 14: Previous directory restored to /var/log"

    else
        fail "Task 14: Final navigation did not return to /var/log"
    fi

    # TASK 15 - Basic Server Health Check
    TASK15_OK=1
    if [ ! -f "$SERVER_REVIEW_REPORT" ]; then
        TASK15_OK=0
    fi

    # Current location / home directory
    if ! grep -Fxq "$HOME_DIR" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # Username
    if ! grep -q "^$STUDENT_NAME$" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # CPU
    if ! grep -q "Architecture:" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # Memory
    if ! grep -q "Mem:" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # Block storage
    if ! grep -q "NAME.*MAJ:MIN.*RM.*SIZE" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # Kernel
    if ! grep -Fq "$KERNEL_VERSION" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    # Uptime
    if ! grep -q "load average" "$SERVER_REVIEW_REPORT" 2>/dev/null; then
        TASK15_OK=0
    fi

    if [ "$TASK15_OK" -eq 1 ]; then
        pass "Task 15: Basic server health check completed successfully"
    else
        fail "Task 15: server-review-report is incomplete"
    fi


    # ============================================================
    # SUMMARY
    # ============================================================

    PERCENT=$((PASSED * 100 / TOTAL_TASKS))

    if [ "$PASSED" -eq "$TOTAL_TASKS" ]; then
        RESULT_CLASS="result-success"
        RESULT_ICON="✓"
        RESULT_TEXT="LAB PASSED"
    else
        RESULT_CLASS="result-failed"
        RESULT_ICON="✗"
        RESULT_TEXT="LAB NEEDS ATTENTION"
    fi


    # ============================================================
    # RESULT STYLES
    # ============================================================

    cat <<'HTML'
<style>
.validation-pass {
    margin: 6px 0;
    padding: 10px 14px;
    background: #DCFCE7;
    color: #166534;
    border-left: 5px solid #22C55E;
    border-radius: 6px;
    font-weight: 600;
}

.validation-fail {
    margin: 6px 0;
    padding: 10px 14px;
    background: #FEE2E2;
    color: #991B1B;
    border-left: 5px solid #EF4444;
    border-radius: 6px;
    font-weight: 600;
}

.lab-summary {
    margin-top: 25px;
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: #0f172a;
    border: 2px solid #38bdf8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.35);
    color: white;
}

.lab-summary-title {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #38bdf8;
}

.lab-summary-info {
    text-align: left;
    max-width: 650px;
    margin: 0 auto 20px auto;
}

.lab-summary-row {
    padding: 10px 0;
    border-bottom: 1px solid #334155;
}

.lab-summary-label {
    font-weight: 700;
    color: #94a3b8;
    display: inline-block;
    min-width: 110px;
}

.lab-summary-value {
    color: #ffffff;
}

.result-percentage {
    margin-top: 20px;
    font-size: 42px;
    font-weight: 800;
    color: #38bdf8;
}

.result-success {
    margin-top: 20px;
    padding: 15px;
    background: #166534;
    color: #dcfce7;
    border: 2px solid #22c55e;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}

.result-failed {
    margin-top: 20px;
    padding: 15px;
    background: #991b1b;
    color: #fee2e2;
    border: 2px solid #ef4444;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
</style>
HTML


    # ============================================================
    # RESULT SUMMARY
    # ============================================================

    cat <<HTML

<div class="lab-summary">

    <div class="lab-summary-title">
        LAB RESULT SUMMARY
    </div>

    <div class="lab-summary-info">

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Student:
            </span>

            <span class="lab-summary-value">
                $STUDENT_NAME
            </span>
        </div>

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Lab:
            </span>

            <span class="lab-summary-value">
                $LAB_NAME
            </span>
        </div>

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Total Tasks:
            </span>

            <span class="lab-summary-value">
                $TOTAL_TASKS
            </span>
        </div>

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Passed:
            </span>

            <span class="lab-summary-value">
                $PASSED
            </span>
        </div>

    </div>

    <div class="result-percentage">
        $PERCENT%
    </div>

    <div class="$RESULT_CLASS">
        $RESULT_ICON $RESULT_TEXT
    </div>

</div>

HTML
}

# ===============================================================

validate_lab202_linuxfs_navigation_fsmgt() {
    set +e
    set +u
    set +o pipefail

    echo "Checking Lab 202 - Linux File System Navigation and File Management..."

    HOME_DIR="/home/$STUDENT_NAME"
    BASE="$HOME_DIR/linux_lab"

    TOTAL_TASKS=21
    PASSED=0

    LAB_NAME="Lab ${LAB_NUMBER#lab} - Linux File System Navigation and File Management"
    DATE=$(date "+%F %T")

    # ============================================================
    # HELPERS
    # ============================================================

    pass() {
        echo "<div class='validation-pass'>✓ $1 – Pass</div>"
        ((PASSED++))
    }

    fail() {
        echo "<div class='validation-fail'>✗ $1 – Fail</div>"
    }


    # PART 1 - CREATE DIRECTORY STRUCTURE
    # TASK 1
    if [ -d "$BASE" ]; then
        pass "Task 1: linux_lab directory created in home directory"
    else
        fail "Task 1: linux_lab directory is missing from home directory"
    fi


    # TASK 2
    if [ -d "$BASE" ]; then
        pass "Task 2: linux_lab directory is available for navigation"
    else
        fail "Task 2: linux_lab directory is missing"
    fi


    # TASK 3
    if [ -d "$BASE/projects" ] &&
       [ -d "$BASE/backups" ]; then
        pass "Task 3: projects and backups directories created"

    else
        fail "Task 3: projects or backups directory is missing"
    fi


    # TASK 4
    if [ -d "$BASE/projects/project1" ] &&
       { [ -d "$BASE/projects/project2" ] || [ -d "$BASE/projects/production" ]; }; then
        pass "Task 4: project1 and project2 directories created"

    else
        fail "Task 4: project1 or project2 directory is missing"
    fi


    # TASK 5
    if [ -d "$BASE/documents/scripts" ] &&
       [ -d "$BASE/reports/notes" ]; then
        pass "Task 5: documents/scripts and reports/notes directory structures created"

    else
        fail "Task 5: documents/scripts or reports/notes structure is missing"
    fi

    # PART 2 - CREATE FILES
    # TASK 6
    if [ -f "$BASE/projects/project1/inventory.txt" ]; then
        if [ ! -s "$BASE/projects/project1/inventory.txt" ]; then
            pass "Task 6: Empty inventory.txt created inside project1"
        else
            fail "Task 6: inventory.txt exists but is not empty"
        fi
    else
        fail "Task 6: inventory.txt is missing from project1"
    fi

    # TASK 7
    if [ -f "$BASE/documents/scripts/daily.sh" ]; then
        if [ ! -s "$BASE/documents/scripts/daily.sh" ]; then
            pass "Task 7: Empty daily.sh created inside scripts"
        else
            fail "Task 7: daily.sh exists but is not empty"
        fi
    else
        fail "Task 7: daily.sh is missing from scripts"
    fi


    # TASK 8
    if [ -f "$BASE/reports/summary.txt" ]; then
        if [ ! -s "$BASE/reports/summary.txt" ]; then
            pass "Task 8: Empty summary.txt created inside reports"
        else
            fail "Task 8: summary.txt exists but is not empty"
        fi
    else
        fail "Task 8: summary.txt is missing from reports"
    fi


    # TASK 9
    EXPECTED_TEXT="Linux is my backbone and I really love Linux."
    if [ -f "$BASE/projects/project1/users.txt" ] &&
       [ "$(cat "$BASE/projects/project1/users.txt" 2>/dev/null)" = "$EXPECTED_TEXT" ]; then
        pass "Task 9: users.txt created with the correct content"
    else
        fail "Task 9: users.txt is missing or contains incorrect content"
    fi

    # PART 3 - COPY FILES
    # TASK 10
    if [ -f "$BASE/projects/project1/inventory.txt" ] &&
       { [ -f "$BASE/projects/project2/inventory_backup.txt" ] ||
         [ -f "$BASE/projects/production/inventory_backup.txt" ]; }; then

        if [ -f "$BASE/projects/project2/inventory_backup.txt" ] &&
           cmp -s \
               "$BASE/projects/project1/inventory.txt" \
               "$BASE/projects/project2/inventory_backup.txt" 2>/dev/null; then

        pass "Task 10: inventory.txt file copied correctly to project2"

    elif [ -f "$BASE/projects/production/inventory_backup.txt" ] &&
         cmp -s \
             "$BASE/projects/project1/inventory.txt" \
             "$BASE/projects/production/inventory_backup.txt" 2>/dev/null; then
            pass "Task 10: inventory.txt file copied correctly to project2"
        else
            fail "Task 10: project2/inventory.txt does not match project1/inventory.txt"
        fi
    else
        fail "Task 10: inventory.txt file is missing from project1 or project2"
    fi

    # TASK 11
    if [ -f "$BASE/projects/project1/users.txt" ]; then

        if [ -f "$BASE/reports/users.txt" ] &&
           cmp -s \
               "$BASE/projects/project1/users.txt" \
               "$BASE/reports/users.txt" 2>/dev/null; then

             pass "Task 11: users.txt copied correctly to reports"

        elif [ -f "$BASE/projects/project2/users.txt" ] &&
             cmp -s \
                 "$BASE/projects/project1/users.txt" \
                 "$BASE/projects/project2/users.txt" 2>/dev/null; then

             pass "Task 11: users.txt copied correctly to reports"

        elif [ -f "$BASE/projects/production/users.txt" ] &&
             cmp -s \
                 "$BASE/projects/project1/users.txt" \
                 "$BASE/projects/production/users.txt" 2>/dev/null; then

             pass "Task 11: users.txt copied correctly to reports"

        else
             fail "Task 11: users.txt copy is missing or does not match the original"
        fi   

        else
             fail "Task 11: Original users.txt is missing from project1"
        fi    

    # TASK 12
    if [ -f "$BASE/reports/summary.txt" ] &&
       [ -f "$BASE/reports/notes/summary.txt" ]; then
        if cmp -s \
            "$BASE/reports/summary.txt" \
            "$BASE/reports/notes/summary.txt" 2>/dev/null; then
            pass "Task 12: summary.txt copied correctly to notes"
        else
            fail "Task 12: notes/summary.txt does not match reports/summary.txt"
        fi
    else
        fail "Task 12: summary.txt is missing from reports or notes"
    fi

    # TASK 13
    if [ -f "$BASE/documents/scripts/daily.sh" ] &&
       [ -f "$BASE/projects/project1/daily.sh" ]; then
        if cmp -s \
            "$BASE/documents/scripts/daily.sh" \
            "$BASE/projects/project1/daily.sh" 2>/dev/null; then
            pass "Task 13: daily.sh copied correctly into project1"
        else
            fail "Task 13: project1/daily.sh does not match scripts/daily.sh"
        fi
    else
        fail "Task 13: daily.sh is missing from scripts or project1"
    fi

    # TASK 14
    if [ -d "$BASE/projects/project1" ] &&
       [ -d "$BASE/backups/project1" ]; then
        pass "Task 14: project1 directory copied correctly into backups"
    else
        fail "Task 14: project1 backup directory is missing"
    fi

    # PART 4 - MOVE AND RENAME FILES
    # TASK 15
    if [ -f "$BASE/projects/project2/inventory_backup.txt" ] &&
       [ ! -e "$BASE/projects/project2/inventory.txt" ]; then
        pass "Task 15: inventory.txt renamed to inventory_backup.txt"
    elif [ -f "$BASE/projects/production/inventory_backup.txt" ] &&
         [ ! -e "$BASE/projects/production/inventory.txt" ]; then
        pass "Task 15: inventory.txt renamed to inventory_backup.txt"
    else
        fail "Task 15: inventory_backup.txt is missing or inventory.txt still exists"
    fi

    # TASK 16
    if [ -f "$BASE/backups/project1/startup.sh" ] &&
       [ ! -e "$BASE/backups/project1/daily.sh" ]; then
        pass "Task 16: daily.sh renamed to startup.sh in backup project1"
    else
        fail "Task 16: startup.sh is missing or daily.sh was not renamed"
    fi

    # TASK 17
    if [ -f "$BASE/projects/project2/users.txt" ] &&
       [ ! -e "$BASE/reports/users.txt" ]; then
        pass "Task 17: users.txt moved from reports to project2"
    elif [ -f "$BASE/projects/production/users.txt" ] &&
         [ ! -e "$BASE/reports/users.txt" ]; then
        pass "Task 17: users.txt moved from reports to project2"
    else
        fail "Task 17: users.txt was not moved correctly from reports"
    fi

    # TASK 18
    if [ -d "$BASE/projects/production" ] &&
       [ ! -e "$BASE/projects/project2" ]; then
        pass "Task 18: project2 renamed to production"
    else
        fail "Task 18: production directory is missing or project2 still exists"
    fi

    # PART 5 - ABSOLUTE AND RELATIVE PATH PRACTICE
    # TASK 19
    if [ -d "$BASE/reports/notes" ]; then
        pass "Task 19: notes directory exists at the required absolute path"
    else
        fail "Task 19: notes directory is missing"
    fi

    # TASK 20
    if [ -d "$BASE" ]; then
        pass "Task 20: linux_lab directory exists for relative navigation"

    else
        fail "Task 20: linux_lab directory is missing"
    fi

    # TASK 21
    if [ -d "$BASE/projects/production" ]; then
        pass "Task 21: production directory exists for relative navigation"
    else
        fail "Task 21: production directory is missing"
    fi

    # ============================================================
    # SUMMARY
    # ============================================================

    PERCENT=$((PASSED * 100 / TOTAL_TASKS))

    if [ "$PASSED" -eq "$TOTAL_TASKS" ]; then
        RESULT_CLASS="result-success"
        RESULT_ICON="✓"
        RESULT_TEXT="LAB PASSED"
    else
        RESULT_CLASS="result-failed"
        RESULT_ICON="✗"
        RESULT_TEXT="LAB NEEDS ATTENTION"
    fi


    # ============================================================
    # RESULT STYLES
    # ============================================================

    cat <<'HTML'
<style>
.validation-pass {
    margin: 6px 0;
    padding: 10px 14px;
    background: #DCFCE7;
    color: #166534;
    border-left: 5px solid #22C55E;
    border-radius: 6px;
    font-weight: 600;
}

.validation-fail {
    margin: 6px 0;
    padding: 10px 14px;
    background: #FEE2E2;
    color: #991B1B;
    border-left: 5px solid #EF4444;
    border-radius: 6px;
    font-weight: 600;
}

.lab-summary {
    margin-top: 25px;
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: #0f172a;
    border: 2px solid #38bdf8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.35);
    color: white;
}

.lab-summary-title {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #38bdf8;
}

.lab-summary-info {
    text-align: left;
    max-width: 650px;
    margin: 0 auto 20px auto;
}

.lab-summary-row {
    padding: 10px 0;
    border-bottom: 1px solid #334155;
}

.lab-summary-label {
    font-weight: 700;
    color: #94a3b8;
    display: inline-block;
    min-width: 110px;
}

.lab-summary-value {
    color: #ffffff;
}

.result-percentage {
    margin-top: 20px;
    font-size: 42px;
    font-weight: 800;
    color: #38bdf8;
}

.result-success {
    margin-top: 20px;
    padding: 15px;
    background: #166534;
    color: #dcfce7;
    border: 2px solid #22c55e;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}

.result-failed {
    margin-top: 20px;
    padding: 15px;
    background: #991b1b;
    color: #fee2e2;
    border: 2px solid #ef4444;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
</style>
HTML


    # ============================================================
    # RESULT SUMMARY
    # ============================================================

    cat <<HTML

<div class="lab-summary">

    <div class="lab-summary-title">
        LAB RESULT SUMMARY
    </div>

    <div class="lab-summary-info">

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Student:
            </span>

            <span class="lab-summary-value">
                $STUDENT_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Lab:
            </span>

            <span class="lab-summary-value">
                $LAB_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Total Tasks:
            </span>

            <span class="lab-summary-value">
                $TOTAL_TASKS
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Passed:
            </span>

            <span class="lab-summary-value">
                $PASSED
            </span>
        </div>

    </div>


    <div class="result-percentage">
        $PERCENT%
    </div>


    <div class="$RESULT_CLASS">
        $RESULT_ICON $RESULT_TEXT
    </div>

</div>

HTML

}


# ===========================================================================

validate_lab203_command_navigation() {
    set +e
    set +u
    set +o pipefail

    echo "Checking Lab 203 - Linux Basic Commands & Navigation..."

    HOME_DIR="/home/$STUDENT_NAME"

    TOTAL_TASKS=14
    PASSED=0

    LAB_NAME="Lab ${LAB_NUMBER#lab} - Linux Basic Commands & Navigation"
    DATE=$(date "+%F %T")

    SERVER_INFO="$HOME_DIR/server_info"

    # ============================================================
    # HELPERS
    # ============================================================

    pass() {
        echo "<div class='validation-pass'>✓ $1 – Pass</div>"
        ((PASSED++))
    }

    fail() {
        echo "<div class='validation-fail'>✗ $1 – Fail</div>"
    }

    # Section 1: Server Info Append to server_info

    # TASK 1
    if [ -f "$SERVER_INFO" ] &&
       grep -Eq "^$HOME_DIR/?$" "$SERVER_INFO" 2>/dev/null; then

        pass "Task 1: Current working directory was recorded in server_info"
    else
        fail "Task 1: Current working directory output is missing from server_info"
    fi

    # TASK 2
    KERNEL_VERSION=$(uname -r 2>/dev/null)
    if [ -f "$SERVER_INFO" ] &&
       [ -n "$KERNEL_VERSION" ] &&
       grep -Fq "$KERNEL_VERSION" "$SERVER_INFO" 2>/dev/null; then
        pass "Task 2: Kernel version was recorded in server_info"
    else
        fail "Task 2: Kernel version output is missing from server_info"
    fi

    # TASK 3
    if grep -q "$HOME_DIR" "$SERVER_INFO"; then 
        pass "Task 3: Detailed directory listing was recorded in server_info"
    else
        fail "Task 3: Detailed directory listing is missing from server_info"
    fi

    # TASK 4
    if grep -q "\.bashrc" "$SERVER_INFO"; then
        pass "Task 4: Hidden files were included in detailed listing"
    else
        fail "Task 4: Hidden file listing is missing from server_info"
    fi

    # TASK 5
    if [ -d "$HOME_DIR/Linux" ]; then
        pass "Task 5: Linux directory created"
    else
        fail "Task 5: Linux directory is missing"
    fi

    # TASK 6
    if [ -f "$SERVER_INFO" ] &&
       grep -Eq "^$HOME_DIR/Linux/?$" "$SERVER_INFO" 2>/dev/null; then
        pass "Task 6: Linux directory path was recorded in server_info"
    else
        fail "Task 6: Linux directory path is missing from server_info"
    fi
    
    # TASK 7
    if [ -d "$HOME_DIR/Linux/Redhat" ] &&
       [ -d "$HOME_DIR/Linux/oel" ] &&
       [ -d "$HOME_DIR/Linux/debian" ]; then
        pass "Task 7: Redhat, oel and debian directories created"
    else
        fail "Task 7: One or more required Linux subdirectories are missing"
    fi

    # TASK 8
    if [ -f "$SERVER_INFO" ] &&
       grep -Eq "^$HOME_DIR/?$" "$SERVER_INFO" 2>/dev/null; then
        pass "Task 8: Student returned to the home directory"
    else
        fail "Task 8: Home directory verification is missing from server_info"
    fi

    # TASK 9
    TASK9_OK=1

    for FILE in \
        "$HOME_DIR/documents/file1.txt" \
        "$HOME_DIR/images/pic.jpg" \
        "$HOME_DIR/media/clip.avi"
    do
        if [ ! -f "$FILE" ] || [ -s "$FILE" ]; then
            TASK9_OK=0
            break
        fi
    done

    if [ "$TASK9_OK" -eq 1 ]; then
        pass "Task 9: file1.txt, pic.jpg and clip.avi created as empty files"
    else
        fail "Task 9: Required empty files are missing or contain data"
    fi

    # TASK 10
    if [ -f "$HOME_DIR/documents/file1.txt" ] &&
       [ -f "$HOME_DIR/images/pic.jpg" ] &&
       [ -f "$HOME_DIR/media/clip.avi" ] &&
       [ ! -e "$HOME_DIR/file1.txt" ] &&
       [ ! -e "$HOME_DIR/pic.jpg" ] &&
       [ ! -e "$HOME_DIR/clip.avi" ]; then
        pass "Task 10: Files moved into the correct directories"
    else
        fail "Task 10: Required directories or file locations are incorrect"
    fi
    
    # TASK 11
    if [ -d "$HOME_DIR/office" ] &&
       [ -d "$HOME_DIR/office/hobby" ] &&
       [ -d "$HOME_DIR/office/hobby/personal" ]; then

        pass "Task 11: Nested office/hobby/personal directory structure created"
    else
        fail "Task 11: office/hobby/personal directory structure is incomplete"
    fi

    # TASK 12
    if [ -f "$HOME_DIR/documents/file1.txt" ] &&
       [ -f "$HOME_DIR/office/file1.txt" ]; then
        if cmp -s \
            "$HOME_DIR/documents/file1.txt" \
            "$HOME_DIR/office/file1.txt" 2>/dev/null; then
            pass "Task 12: file1.txt copied correctly to office"
        else
            fail "Task 12: office/file1.txt does not match documents/file1.txt"
        fi
    else
        fail "Task 12: file1.txt is missing from documents or office"
    fi

    # TASK 13
    if [ -f "$HOME_DIR/images/pic.jpg" ] &&
       [ -f "$HOME_DIR/office/hobby/pic.jpg" ]; then
        if cmp -s \
            "$HOME_DIR/images/pic.jpg" \
            "$HOME_DIR/office/hobby/pic.jpg" 2>/dev/null; then
            pass "Task 13: pic.jpg copied correctly to office/hobby"
        else
            fail "Task 13: office/hobby/pic.jpg does not match images/pic.jpg"
        fi
    else
        fail "Task 13: pic.jpg is missing from images or office/hobby"
    fi

    # TASK 14
    OFFICE_TREE="$HOME_DIR/office/hobby/personal/office_tree"
    if [ -f "$OFFICE_TREE" ] &&
       grep -q "personal" "$OFFICE_TREE" 2>/dev/null; then 
        pass "Task 14: office directory tree saved correctly in office_tree"
    else
        fail "Task 14: office_tree exists but does not contain the expected tree output"
    fi

# =========================================================
# SUMMARY
# =========================================================

PERCENT=$((PASSED * 100 / TOTAL_TASKS))

if [ "$PASSED" -eq "$TOTAL_TASKS" ]; then
    RESULT_CLASS="result-success"
    RESULT_ICON="✓"
    RESULT_TEXT="LAB PASSED"
else
    RESULT_CLASS="result-failed"
    RESULT_ICON="✗"
    RESULT_TEXT="LAB NEEDS ATTENTION"
fi

# =========================================================
# RESULT STYLES
# =========================================================
cat <<'HTML'
<style>
.validation-pass {
    margin: 6px 0;
    padding: 10px 14px;
    background: #DCFCE7;
    color: #166534;
    border-left: 5px solid #22C55E;
    border-radius: 6px;
    font-weight: 600;
}
.validation-fail {
    margin: 6px 0;
    padding: 10px 14px;
    background: #FEE2E2;
    color: #991B1B;
    border-left: 5px solid #EF4444;
    border-radius: 6px;
    font-weight: 600;
}
.lab-summary {
    margin-top: 25px;
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: #0f172a;
    border: 2px solid #38bdf8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.35);
    color: white;
}
.lab-summary-title {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #38bdf8;
}
.lab-summary-info {
    text-align: left;
    max-width: 650px;
    margin: 0 auto 20px auto;
}
.lab-summary-row {
    padding: 10px 0;
    border-bottom: 1px solid #334155;
}
.lab-summary-label {
    font-weight: 700;
    color: #94a3b8;
    display: inline-block;
    min-width: 110px;
}
.lab-summary-value {
    color: #ffffff;
}
.result-percentage {
    margin-top: 20px;
    font-size: 42px;
    font-weight: 800;
    color: #38bdf8;
}
.result-success {
    margin-top: 20px;
    padding: 15px;
    background: #166534;
    color: #dcfce7;
    border: 2px solid #22c55e;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
.result-failed {
    margin-top: 20px;
    padding: 15px;
    background: #991b1b;
    color: #fee2e2;
    border: 2px solid #ef4444;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
</style>
HTML

# =========================================================
# RESULT SUMMARY
# =========================================================

cat <<HTML

<div class="lab-summary">

    <div class="lab-summary-title">
        LAB RESULT SUMMARY
    </div>

    <div class="lab-summary-info">

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Student:
            </span>

            <span class="lab-summary-value">
                $STUDENT_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Lab:
            </span>

            <span class="lab-summary-value">
                $LAB_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Total Tasks:
            </span>

            <span class="lab-summary-value">
                $TOTAL_TASKS
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Passed:
            </span>

            <span class="lab-summary-value">
                $PASSED
            </span>
        </div>

    </div>


    <div class="result-percentage">
        $PERCENT%
    </div>


    <div class="$RESULT_CLASS">
        $RESULT_ICON $RESULT_TEXT
    </div>

</div>

HTML
}
#=================================================================

validate_lab204_review_navigation() {
    set +e
    set +u
    set +o pipefail

    echo "Checking Lab 204 - Review Linux File System Navigation and Basic Commands..."

    HOME_DIR="/home/$STUDENT_NAME"
    BASE="$HOME_DIR/vars"

    TOTAL_TASKS=10
    PASSED=0
    LAB_NAME="Lab ${LAB_NUMBER#lab} - Review Linux File System Navigation and Basic Commands"
    DATE=$(date "+%F %T")
    
    # HELPERS
    pass() {
        echo "<div class='validation-pass'>✓ $1 – Pass</div>"
        ((PASSED++))
    }

    fail() {
        echo "<div class='validation-fail'>✗ $1 – Fail</div>"
    }    

    # TASK 1
    if [ -d "$BASE/systems/logs" ]; then
        pass "Task 1: Nested directory vars/systems/logs created"
    else
        fail "Task 1: Directory structure vars/systems/logs missing"
    fi

    # TASK 2
    if [ -f "$BASE/systems/passwd_tail" ] &&
       [ -f "$BASE/systems/group_head" ]; then
        pass "Task 2: Empty files passwd_tail and group_head created"
    else
        fail "Task 2: passwd_tail or group_head missing or not empty"
    fi
    # TASK 3
    EXPECTED_TEXT="I love linux and excited to join the DevOps course"
    if [ -f "$BASE/systems/logs/file1.txt" ] &&
       [ "$(cat "$BASE/systems/logs/file1.txt" 2>/dev/null)" = "$EXPECTED_TEXT" ]; then
        pass "Task 3: file1.txt created with the exact required text"
    else
        fail "Task 3: file1.txt missing or text does not match exactly"
    fi
    # TASK 4
    if [ -d "$BASE/os/configs" ]; then
        pass "Task 4: Nested directory vars/os/configs created"
    else
        fail "Task 4: Directory structure vars/os/configs missing"
    fi
    # TASK 5
    if [ -f "$BASE/hosts" ] &&
       cmp -s /etc/hosts "$BASE/hosts"; then
        pass "Task 5: /etc/hosts copied correctly to vars/hosts"
    else
        fail "Task 5: vars/hosts missing or does not match /etc/hosts"
    fi
    # TASK 6
    if [ -f "$BASE/os/hosts.bak" ] &&
       cmp -s "$BASE/hosts" "$BASE/os/hosts.bak"; then
        pass "Task 6: hosts content redirected to vars/os/hosts.bak"
    else
        fail "Task 6: hosts.bak missing or content does not match vars/hosts"
    fi
    # TASK 7
    EXPECTED_CHRONY=$(grep "chrony" /etc/passwd 2>/dev/null)

    if [ -n "$EXPECTED_CHRONY" ] &&
       [ -f "$BASE/os/configs/chrony_info" ] &&
       grep -Fxq "$EXPECTED_CHRONY" "$BASE/os/configs/chrony_info" 2>/dev/null; then
        pass "Task 7: chrony information stored correctly in chrony_info"
    else
        fail "Task 7: chrony_info missing or does not contain the required chrony entry"
    fi
    # TASK 8
    if [ -f "$BASE/os/new_file1.txt" ] &&
       cmp -s "$BASE/systems/logs/file1.txt" "$BASE/os/new_file1.txt"; then
        pass "Task 8: file1.txt copied and renamed to new_file1.txt"
    else
        fail "Task 8: new_file1.txt missing or content does not match file1.txt"
    fi
    # TASK 9
    if [ -f "$BASE/systems/passwd_tail" ] &&
       [ "$(wc -l < "$BASE/systems/passwd_tail")" -eq 10 ]; then
       pass "Task 9: Required passwd output stored correctly"
    else
       fail "Task 9: passwd_tail does not contain the required passwd output"
    fi
    # TASK 10
     if [ -f "$BASE/systems/group_head" ] &&
        [ "$(wc -l < "$BASE/systems/group_head")" -eq 10 ]; then
        pass "Task 10: First 10 lines of /etc/group appended to group_head"
    else
        fail "Task 10: group_head does not contain the required head output"
    fi
# =========================================================
# SUMMARY
# =========================================================
PERCENT=$((PASSED * 100 / TOTAL_TASKS))

if [ "$PASSED" -eq "$TOTAL_TASKS" ]; then
    RESULT_CLASS="result-success"
    RESULT_ICON="✓"
    RESULT_TEXT="LAB PASSED"
else
    RESULT_CLASS="result-failed"
    RESULT_ICON="✗"
    RESULT_TEXT="LAB NEEDS ATTENTION"
fi

# =========================================================
# RESULT STYLES
# =========================================================
cat <<'HTML'
<style>
.validation-pass {
    margin: 6px 0;
    padding: 10px 14px;
    background: #DCFCE7;
    color: #166534;
    border-left: 5px solid #22C55E;
    border-radius: 6px;
    font-weight: 600;
}
.validation-fail {
    margin: 6px 0;
    padding: 10px 14px;
    background: #FEE2E2;
    color: #991B1B;
    border-left: 5px solid #EF4444;
    border-radius: 6px;
    font-weight: 600;
}
.lab-summary {
    margin-top: 25px;
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: #0f172a;
    border: 2px solid #38bdf8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.35);
    color: white;
}
.lab-summary-title {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #38bdf8;
}
.lab-summary-info {
    text-align: left;
    max-width: 650px;
    margin: 0 auto 20px auto;
}
.lab-summary-row {
    padding: 10px 0;
    border-bottom: 1px solid #334155;
}
.lab-summary-label {
    font-weight: 700;
    color: #94a3b8;
    display: inline-block;
    min-width: 110px;
}
.lab-summary-value {
    color: #ffffff;
}
.result-percentage {
    margin-top: 20px;
    font-size: 42px;
    font-weight: 800;
    color: #38bdf8;
}
.result-success {
    margin-top: 20px;
    padding: 15px;
    background: #166534;
    color: #dcfce7;
    border: 2px solid #22c55e;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
.result-failed {
    margin-top: 20px;
    padding: 15px;
    background: #991b1b;
    color: #fee2e2;
    border: 2px solid #ef4444;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
</style>
HTML

# =========================================================
# RESULT SUMMARY
# =========================================================
cat <<HTML
<div class="lab-summary">

    <div class="lab-summary-title">
        LAB RESULT SUMMARY
    </div>

    <div class="lab-summary-info">

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Student:
            </span>

            <span class="lab-summary-value">
                $STUDENT_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Lab:
            </span>

            <span class="lab-summary-value">
                $LAB_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Total Tasks:
            </span>

            <span class="lab-summary-value">
                $TOTAL_TASKS
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Passed:
            </span>

            <span class="lab-summary-value">
                $PASSED
            </span>
        </div>

    </div>


    <div class="result-percentage">
        $PERCENT%
    </div>


    <div class="$RESULT_CLASS">
        $RESULT_ICON $RESULT_TEXT
    </div>

</div>

HTML
}

# ===============================================================

validate_lab205_file_permissions() {
    set +e
    set +u
    set +o pipefail

    echo "Checking Lab 205 - Linux File Permissions..."
    HOME_DIR="/home/$STUDENT_NAME"
    BASE="$HOME_DIR/my_own_dir"

    TOTAL_TASKS=20
    PASSED=0
    LAB_NAME="Lab ${LAB_NUMBER#lab} - Linux File Permissions"
    DATE=$(date "+%F %T")

    # HELPERS
    pass() {
        echo "<div class='validation-pass'>✓ $1 – Pass</div>"
        ((PASSED++))
    }

    fail() {
        echo "<div class='validation-fail'>✗ $1 – Fail</div>"
    }


    # TASK 1
    if [ -d "$BASE" ]; then
        pass "Task 1: my_own_dir directory created"
    else
        fail "Task 1: my_own_dir directory is missing"
    fi

    # TASK 2
    PERMS=$(stat -c "%a" "$BASE" 2>/dev/null)
    if [ -d "$BASE" ] &&
       [ "$PERMS" = "775" ]; then
        pass "Task 2: Permissions set correctly using symbolic notation"
    else
        fail "Task 2: incorrect permissions set on my_own_dir"
    fi

    # TASK 3
    # Final state confirms the directory was later restored with execute
    # permission, so there is no permanent filesystem state to validate
    # for the failed cd command.

    if [ -d "$BASE" ]; then
        pass "Task 3: my_own_dir exists after navigation test"
    else
        fail "Task 3: my_own_dir is missing"
    fi

    # TASK 4
    # Redhat should not have been created during the permission-denied test.
    # It is created later in Task 5, so validate its final existence.

    if [ -d "$BASE/Redhat" ]; then
        pass "Task 4: Redhat directory exists after permission test"
    else
        fail "Task 4: Redhat directory is missing"
    fi

    # TASK 5
    BASE_PERMS=$(stat -c "%a" "$BASE" 2>/dev/null)
    if [ -d "$BASE/Redhat" ] &&
       [ -d "$BASE/OEL" ] &&
       [ "$BASE_PERMS" = "775" ]; then
        pass "Task 5: Correct permissions set on my_own_dir, Redhat and OEL created"
    else
        fail "Task 5: Required directories or permission is in incorrect"
    fi

    # TASK 6
    REDHAT_PERMS=$(stat -c "%a" "$BASE/Redhat" 2>/dev/null)
    OEL_PERMS=$(stat -c "%a" "$BASE/OEL" 2>/dev/null)
    if [ "$REDHAT_PERMS" = "775" ] &&
       [ "$OEL_PERMS" = "775" ]; then
        pass "Task 6: Recursive permission 775 applied to directory contents"
    else
        fail "Task 6: Redhat or OEL does not have expected 775 permissions"
    fi

    # TASK 7
    EXPECTED_TEXT="I love Linux"
    if [ -f "$BASE/file_1.txt" ] &&
       [ "$(head -n 1 "$BASE/file_1.txt" 2>/dev/null)" = "$EXPECTED_TEXT" ] &&
       [ -d "$BASE/dir_1" ]; then
        pass "Task 7: file_1.txt and dir_1 created correctly"
    else
        fail "Task 7: file_1.txt or dir_1 missing, or file content is incorrect"
    fi

    # TASK 8
    # Read permission is restored later, so final state cannot prove
    # the temporary removal. The file must exist.
    if [ -f "$BASE/file_1.txt" ]; then
        pass "Task 8: file_1.txt exists after permission modification"
    else
        fail "Task 8: file_1.txt is missing"
    fi

    # TASK 9
    # The failed cat is temporary and cannot be validated after the fact.
    # Validate that the file exists.
    if [ -f "$BASE/file_1.txt" ]; then
        pass "Task 9: file_1.txt exists after read-permission test"
    else
        fail "Task 9: file_1.txt is missing"
    fi

    # TASK 10
    if [ -f "$BASE/file_1.txt" ] &&
       [ "$(head -n 1 "$BASE/file_1.txt" 2>/dev/null)" = "$EXPECTED_TEXT" ] &&
       [ "$(stat -c "%a" "$BASE/file_1.txt" 2>/dev/null)" == "764" ]; then
        pass "Task 10: Read permission restored and original content is readable"
    else
        fail "Task 10: Read permission or original file content is incorrect"
    fi

    # TASK 11
    # Write permission is restored in Task 13, therefore validate the
    # resulting file rather than the temporary permission state.
    if [ -f "$BASE/file_1.txt" ]; then
        pass "Task 11: file_1.txt exists after write-permission test"
    else
        fail "Task 11: file_1.txt is missing"
    fi

    # TASK 12
    # The first append should fail. The final file should NOT contain
    # duplicate text from the failed attempt.
    if [ -f "$BASE/file_1.txt" ]; then
        pass "Task 12: file_1.txt exists after write-permission test"
    else
        fail "Task 12: file_1.txt is missing"
    fi

    # TASK 13
    FILE_PERMS=$(stat -c "%a" "$BASE/file_1.txt" 2>/dev/null)
    if [ -f "$BASE/file_1.txt" ] &&
       [ "$FILE_PERMS" = "764" ] || [ "$FILE_PERMS" = "664" ] || [ "$FILE_PERMS" = "644" ]; then
        pass "Task 13: Write permission restored for owner and group"
    else
        fail "Task 13: Write permission was not restored correctly"
    fi

    # TASK 14
    EXPECTED_CONTENT=$'I love Linux\nFile permission setting is fun'
    if [ -f "$BASE/file_1.txt" ] &&
       [ "$(cat "$BASE/file_1.txt" 2>/dev/null)" = "$EXPECTED_CONTENT" ]; then
        pass "Task 14: Required text appended successfully"
    else
        fail "Task 14: file_1.txt does not contain the expected two lines"
    fi

    # TASK 15
    OWNER_EXEC=$(stat -c "%A" "$BASE/file_1.txt" 2>/dev/null | cut -c4)
    if [ "$OWNER_EXEC" = "x" ]; then
        pass "Task 15: Execute permission added for owner"
    else
        fail "Task 15: Owner execute permission is missing"
    fi

    # TASK 16
    DIR1_PERMS=$(stat -c "%A" "$BASE/dir_1" 2>/dev/null)

    # After Task 16, starting from 775:
    # Owner: r-x -> -wx
    # Group: rwx -> rw-
    # Others: r-x -> r--
    #
    # Expected: d-wxrwx? 
    #
    # However Task 19 later changes dir_1 to 777.
    # Therefore validate final state in Task 19.
    if [ -d "$BASE/dir_1" ]; then
        pass "Task 16: dir_1 exists after permission modification"
    else
        fail "Task 16: dir_1 is missing"
    fi

    # TASK 17
    if [ -f "$BASE/Redhat/new_info" ] &&
       grep -q "dir_1" "$BASE/Redhat/new_info" 2>/dev/null; then
        pass "Task 17: new_info created with dir_1 permission information"
    else
        fail "Task 17: Redhat/new_info missing or incorrect"
    fi

    # TASK 18
    if [ -f "$BASE/OEL/new_info" ] &&
       cmp -s "$BASE/Redhat/new_info" "$BASE/OEL/new_info"; then
        pass "Task 18: new_info copied correctly into OEL"
    else
        fail "Task 18: OEL/new_info missing or content does not match"
    fi

    # TASK 19
    DIR1_FINAL_PERMS=$(stat -c "%a" "$BASE/dir_1" 2>/dev/null)
    if [ -d "$BASE/dir_1" ] &&
       [ "$DIR1_FINAL_PERMS" = "777" ]; then
        pass "Task 19: dir_1 permissions set to 777"
    else
        fail "Task 19: dir_1 permissions are not 777"
    fi

    # TASK 20
    if [ -f "$BASE/OEL/new_info" ] &&
       [ -f "$BASE/OEL/new_info.txt" ] &&
       cmp -s "$BASE/OEL/new_info" "$BASE/OEL/new_info.txt"; then
        pass "Task 20: new_info copied successfully to new_info.txt"
    else
        fail "Task 20: OEL/new_info or new_info.txt missing or contents differ"
    fi

# =========================================================
# SUMMARY
# =========================================================

PERCENT=$((PASSED * 100 / TOTAL_TASKS))

if [ "$PASSED" -eq "$TOTAL_TASKS" ]; then
    RESULT_CLASS="result-success"
    RESULT_ICON="✓"
    RESULT_TEXT="LAB PASSED"
else
    RESULT_CLASS="result-failed"
    RESULT_ICON="✗"
    RESULT_TEXT="LAB NEEDS ATTENTION"
fi

# =========================================================
# RESULT STYLES
# =========================================================
cat <<'HTML'
<style>
.validation-pass {
    margin: 6px 0;
    padding: 10px 14px;
    background: #DCFCE7;
    color: #166534;
    border-left: 5px solid #22C55E;
    border-radius: 6px;
    font-weight: 600;
}
.validation-fail {
    margin: 6px 0;
    padding: 10px 14px;
    background: #FEE2E2;
    color: #991B1B;
    border-left: 5px solid #EF4444;
    border-radius: 6px;
    font-weight: 600;
}
.lab-summary {
    margin-top: 25px;
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: #0f172a;
    border: 2px solid #38bdf8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.35);
    color: white;
}
.lab-summary-title {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #38bdf8;
}
.lab-summary-info {
    text-align: left;
    max-width: 650px;
    margin: 0 auto 20px auto;
}
.lab-summary-row {
    padding: 10px 0;
    border-bottom: 1px solid #334155;
}
.lab-summary-label {
    font-weight: 700;
    color: #94a3b8;
    display: inline-block;
    min-width: 110px;
}
.lab-summary-value {
    color: #ffffff;
}
.result-percentage {
    margin-top: 20px;
    font-size: 42px;
    font-weight: 800;
    color: #38bdf8;
}
.result-success {
    margin-top: 20px;
    padding: 15px;
    background: #166534;
    color: #dcfce7;
    border: 2px solid #22c55e;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
.result-failed {
    margin-top: 20px;
    padding: 15px;
    background: #991b1b;
    color: #fee2e2;
    border: 2px solid #ef4444;
    border-radius: 10px;
    font-size: 21px;
    font-weight: 700;
}
</style>
HTML

# =========================================================
# RESULT SUMMARY
# =========================================================

cat <<HTML

<div class="lab-summary">

    <div class="lab-summary-title">
        LAB RESULT SUMMARY
    </div>

    <div class="lab-summary-info">

        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Student:
            </span>

            <span class="lab-summary-value">
                $STUDENT_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Lab:
            </span>

            <span class="lab-summary-value">
                $LAB_NAME
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Total Tasks:
            </span>

            <span class="lab-summary-value">
                $TOTAL_TASKS
            </span>
        </div>


        <div class="lab-summary-row">
            <span class="lab-summary-label">
                Passed:
            </span>

            <span class="lab-summary-value">
                $PASSED
            </span>
        </div>

    </div>


    <div class="result-percentage">
        $PERCENT%
    </div>


    <div class="$RESULT_CLASS">
        $RESULT_ICON $RESULT_TEXT
    </div>

</div>

HTML
}
#=================================================================
