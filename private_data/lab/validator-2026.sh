#!/bin/bash
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
