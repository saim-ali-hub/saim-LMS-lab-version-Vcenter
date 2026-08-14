#!/bin/bash
# Lab 206 - Operation Broken Shell : final case check
# Students run:  bash /tmp/crime_scene/check_case.sh

CASE="$HOME/case_206"
PASS=0
TOTAL=8

ok()   { printf '  [PASS] %s\n' "$1"; PASS=$((PASS+1)); }
fail() { printf '  [FIX ] %s\n' "$1"; }

echo ""
echo "=========== CASE 206 - FINAL INSPECTION ==========="

# 1. Case file exists
if [ -d "$CASE" ]; then
    ok "Case file directory case_206 exists"
else
    fail "Missing ~/case_206 directory (mkdir case_206 in your home)"
fi

# 2. Structure
if [ -d "$CASE/evidence" ] && [ -d "$CASE/suspects" ] && [ -d "$CASE/reports" ] && [ -d "$CASE/notes/archive" ]; then
    ok "Full directory structure (evidence, suspects, reports, notes/archive)"
else
    fail "Directory structure incomplete - need evidence, suspects, reports, notes/archive"
fi

# 3. Chain of custody recorded
if [ -s "$CASE/evidence/chain_of_custody.txt" ]; then
    ok "Chain of custody documented (chain_of_custody.txt has content)"
else
    fail "evidence/chain_of_custody.txt missing or empty"
fi

# 4. Evidence collected
if [ -f "$CASE/evidence/access_log.txt" ] && [ -f "$CASE/suspects/suspects.txt" ]; then
    ok "Evidence collected (access_log.txt + suspects.txt copied)"
else
    fail "Evidence not fully copied into evidence/ and suspects/"
fi

# 5. Backups made
if [ -f "$CASE/notes/archive/access_log_backup.txt" ] && [ -d "$CASE/notes/archive/evidence_backup" ]; then
    ok "Backups created in notes/archive"
else
    fail "Missing access_log_backup.txt or evidence_backup dir in notes/archive"
fi

# 6. Extract of the incriminating lines
if [ -s "$CASE/reports/evidence_extract.txt" ]; then
    ok "Evidence extract report created"
else
    fail "reports/evidence_extract.txt missing or empty (use grep with > and >>)"
fi

# 7. Final report names the intruder
if grep -qi "shadowfox" "$CASE/reports/case_206_SOLVED.txt" 2>/dev/null; then
    ok "Final report names the intruder - correct suspect identified!"
else
    fail "reports/case_206_SOLVED.txt missing, or does not name the intruder"
fi

# 8. Case sealed: 700 on the case directory
perms=$(stat -c '%a' "$CASE" 2>/dev/null)
if [ "$perms" = "700" ]; then
    ok "Case file sealed (permissions 700 - owner only)"
else
    fail "Case not sealed - run: chmod -R 700 ~/case_206 (currently: ${perms:-none})"
fi

echo "---------------------------------------------------"
echo "  SCORE: $PASS / $TOTAL"
echo "==================================================="

if [ "$PASS" -eq "$TOTAL" ]; then
cat << 'BANNER'

   _____          _____ ______    _____ _      ____   _____ ______ _____
  / ____|   /\   / ____|  ____|  / ____| |    / __ \ / ____|  ____|  __ \
 | |       /  \ | (___ | |__    | |    | |   | |  | | (___ | |__  | |  | |
 | |      / /\ \ \___ \|  __|   | |    | |   | |  | |\___ \|  __| | |  | |
 | |____ / ____ \ ____) | |____ | |____| |___| |__| |____) | |____| |__| |
  \_____/_/    \_\_____/|______| \_____|______\____/|_____/|______|_____/

        The intruder was SHADOWFOX -- Victor Vale, ex-sysadmin.
        Outstanding work, Investigator. You used real Linux
        skills to crack a real case:

        navigation - file management - grep analysis -
        redirection - permissions

              *** YOU ARE NOW A CERTIFIED LINUX DETECTIVE ***
BANNER
else
    echo ""
    echo "  Almost there! Fix the [FIX] items above and run me again:"
    echo "  bash /tmp/crime_scene/check_case.sh"
fi
echo ""
