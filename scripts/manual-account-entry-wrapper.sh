#!/bin/bash

# ============================================================
# LINOOP Manual Account Entry Wrappers
# ============================================================
#
# Creates:
#
#   /usr/local/bin/passwd-entry
#   /usr/local/bin/group-entry
#
# Purpose:
#   Allow students to learn and practice the fields of:
#
#       /etc/passwd
#       /etc/group
#
# WITHOUT allowing:
#
#   - UID 0 accounts
#   - system/service accounts
#   - modification of existing entries
#   - deletion of entries
#   - direct /etc/shadow access
#   - arbitrary editors with sudo
#
# passwd-entry is APPEND ONLY.
# group-entry is APPEND ONLY.
#
# Passwords are managed separately with:
#
#       sudo passwd username
#
# ============================================================

set -e

LIBEXEC="/usr/local/libexec/linoop"
BIN="/usr/local/bin"

REAL_MKDIR="/usr/bin/mkdir"
REAL_CHOWN="/usr/bin/chown"
REAL_CHMOD="/usr/bin/chmod"
REAL_CAT="/usr/bin/cat"

# ------------------------------------------------------------
# Root check
# ------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this installer as root."
    exit 1
fi

# Create directories using REAL system commands
"$REAL_MKDIR" -p "$LIBEXEC"
"$REAL_MKDIR" -p "$BIN"

"$REAL_CHOWN" root:root "$LIBEXEC" "$BIN"

"$REAL_CHMOD" 755 "$LIBEXEC" "$BIN"


# ============================================================
# passwd-entry
# ============================================================

cat > "$LIBEXEC/passwd-entry" <<'EOF'
#!/bin/bash

# ============================================================
# LINOOP Manual /etc/passwd Entry
# ============================================================

PASSWD_FILE="/etc/passwd"

USERNAME_REGEX='^[a-z_][a-z0-9._-]*[$]?$'
SHELL_REGEX='^/(bin|sbin)/[a-zA-Z0-9._+-]+$'

echo
echo "=============================================="
echo " LINOOP Manual /etc/passwd Entry"
echo "=============================================="
echo

echo "You will create ONE normal local user."
echo
echo "Required format:"
echo
echo "username:x:UID:GID:GECOS:/home/username:/bin/bash"
echo
echo "The password field will automatically be set to 'x'."
echo "Use 'sudo passwd username' to set the password."
echo

# ------------------------------------------------------------
# Username
# ------------------------------------------------------------

read -r -p "Username: " USERNAME

if [[ ! "$USERNAME" =~ $USERNAME_REGEX ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ "$USERNAME" = "root" ]; then
    echo "ERROR: root user cannot be created."
    exit 1
fi

if getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User '$USERNAME' already exists."
    exit 1
fi

# ------------------------------------------------------------
# UID
# ------------------------------------------------------------

read -r -p "UID: " UID

if [[ ! "$UID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: UID must be numeric."
    exit 1
fi

if [ "$UID" -lt 1000 ]; then
    echo "ERROR: UID must be 1000 or greater."
    echo "System/service UIDs are not permitted."
    exit 1
fi

if [ "$UID" -gt 60000 ]; then
    echo "ERROR: UID is outside the permitted range."
    exit 1
fi

if getent passwd "$UID" >/dev/null 2>&1; then
    echo "ERROR: UID '$UID' is already in use."
    exit 1
fi

# ------------------------------------------------------------
# GID
# ------------------------------------------------------------

read -r -p "GID: " GID

if [[ ! "$GID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: GID must be numeric."
    exit 1
fi

if [ "$GID" -lt 1000 ]; then
    echo "ERROR: GID must be 1000 or greater."
    echo "System/service groups are not permitted."
    exit 1
fi

if [ "$GID" -gt 60000 ]; then
    echo "ERROR: GID is outside the permitted range."
    exit 1
fi

# ------------------------------------------------------------
# Check GID exists
# ------------------------------------------------------------

if getent group "$GID" >/dev/null 2>&1; then
    echo
    echo "WARNING: GID '$GID' already exists."
    echo
    getent group "$GID"
    echo
    read -r -p "Use this existing GID? [y/N]: " ANSWER

    case "$ANSWER" in
        y|Y)
            ;;
        *)
            echo "Entry creation cancelled."
            exit 1
            ;;
    esac
fi

# ------------------------------------------------------------
# GECOS
# ------------------------------------------------------------

read -r -p "GECOS/comment: " GECOS

# Prevent characters that could corrupt /etc/passwd.
if [[ "$GECOS" == *:* || "$GECOS" == *$'\n'* ]]; then
    echo "ERROR: GECOS cannot contain ':' or newline characters."
    exit 1
fi

# ------------------------------------------------------------
# Home directory
# ------------------------------------------------------------

read -r -p "Home directory [/home/$USERNAME]: " HOME_DIR

if [ -z "$HOME_DIR" ]; then
    HOME_DIR="/home/$USERNAME"
fi

if [ "$HOME_DIR" != "/home/$USERNAME" ]; then
    echo "ERROR: Home directory must be:"
    echo "       /home/$USERNAME"
    exit 1
fi

# ------------------------------------------------------------
# Login shell
# ------------------------------------------------------------

read -r -p "Login shell [/bin/bash]: " SHELL

if [ -z "$SHELL" ]; then
    SHELL="/bin/bash"
fi

case "$SHELL" in
    /bin/bash)
        ;;
    /bin/sh)
        ;;
    /bin/dash)
        ;;
    /bin/zsh)
        ;;
    /bin/ksh)
        ;;
    /sbin/nologin)
        ;;
    *)
        echo "ERROR: Login shell is not permitted."
        echo
        echo "Allowed shells:"
        echo "  /bin/bash"
        echo "  /bin/sh"
        echo "  /bin/dash"
        echo "  /bin/zsh"
        echo "  /bin/ksh"
        echo "  /sbin/nologin"
        exit 1
        ;;
esac

if [ ! -x "$SHELL" ]; then
    echo "ERROR: Shell '$SHELL' does not exist or is not executable."
    exit 1
fi

# ------------------------------------------------------------
# Final validation
# ------------------------------------------------------------

echo
echo "----------------------------------------------"
echo "Review /etc/passwd entry"
echo "----------------------------------------------"
echo
echo "Username : $USERNAME"
echo "Password : x"
echo "UID      : $UID"
echo "GID      : $GID"
echo "GECOS    : $GECOS"
echo "Home     : $HOME_DIR"
echo "Shell    : $SHELL"
echo
echo "Entry:"
echo "$USERNAME:x:$UID:$GID:$GECOS:$HOME_DIR:$SHELL"
echo

read -r -p "Add this entry to /etc/passwd? [y/N]: " ANSWER

case "$ANSWER" in
    y|Y)
        ;;
    *)
        echo "Entry creation cancelled."
        exit 0
        ;;
esac

# ------------------------------------------------------------
# Final race/duplicate checks
# ------------------------------------------------------------

if getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User was created by another process."
    exit 1
fi

if getent passwd "$UID" >/dev/null 2>&1; then
    echo "ERROR: UID was assigned by another process."
    exit 1
fi

# ------------------------------------------------------------
# Append entry
# ------------------------------------------------------------

printf '%s\n' "$USERNAME:x:$UID:$GID:$GECOS:$HOME_DIR:$SHELL" >> "$PASSWD_FILE"

echo
echo "SUCCESS: User entry added to /etc/passwd."
echo
echo "Verify with:"
echo "  getent passwd $USERNAME"
echo "  id $USERNAME"
echo
echo "Next steps:"
echo "  sudo mkdir $HOME_DIR"
echo "  sudo cp -a /etc/skel/. $HOME_DIR/"
echo "  sudo chown -R $USERNAME:$USERNAME $HOME_DIR"
echo "  sudo chmod 700 $HOME_DIR"
echo "  sudo passwd $USERNAME"
echo "  sudo su - $USERNAME"
echo

exit 0
EOF


"$REAL_CHMOD" 755 "$LIBEXEC/passwd-entry"
"$REAL_CHOWN" root:root "$LIBEXEC/passwd-entry"

# ============================================================
# group-entry
# ============================================================

cat > "$LIBEXEC/group-entry" <<'EOF'
#!/bin/bash

# ============================================================
# LINOOP Manual /etc/group Entry
# ============================================================

GROUP_FILE="/etc/group"

GROUP_REGEX='^[a-z_][a-z0-9._-]*[$]?$'
USERNAME_REGEX='^[a-z_][a-z0-9._-]*[$]?$'

echo
echo "=============================================="
echo " LINOOP Manual /etc/group Entry"
echo "=============================================="
echo

echo "You will create ONE normal local group."
echo
echo "Required format:"
echo
echo "groupname:x:GID:user1,user2"
echo

# ------------------------------------------------------------
# Group name
# ------------------------------------------------------------

read -r -p "Group name: " GROUPNAME

if [[ ! "$GROUPNAME" =~ $GROUP_REGEX ]]; then
    echo "ERROR: Invalid group name."
    exit 1
fi

case "$GROUPNAME" in
    root|wheel|adm|bin|daemon|sys|tty|disk|mail|operator|users|sudo)
        echo "ERROR: Reserved/privileged group is not allowed."
        exit 1
        ;;
esac

if getent group "$GROUPNAME" >/dev/null 2>&1; then
    echo "ERROR: Group '$GROUPNAME' already exists."
    exit 1
fi

# ------------------------------------------------------------
# GID
# ------------------------------------------------------------

read -r -p "GID: " GID

if [[ ! "$GID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: GID must be numeric."
    exit 1
fi

if [ "$GID" -lt 1000 ]; then
    echo "ERROR: GID must be 1000 or greater."
    echo "System/service groups are not permitted."
    exit 1
fi

if [ "$GID" -gt 60000 ]; then
    echo "ERROR: GID is outside the permitted range."
    exit 1
fi

if getent group "$GID" >/dev/null 2>&1; then
    echo "ERROR: GID '$GID' is already in use."
    exit 1
fi

# ------------------------------------------------------------
# Group members
# ------------------------------------------------------------

echo
echo "Enter usernames separated by commas."
echo "Leave blank if the group has no supplementary members."
echo

read -r -p "Members: " MEMBERS

if [ -n "$MEMBERS" ]; then

    IFS=',' read -ra MEMBER_LIST <<< "$MEMBERS"

    for USERNAME in "${MEMBER_LIST[@]}"
    do

        # Remove accidental whitespace.
        USERNAME="${USERNAME//[[:space:]]/}"

        if [[ ! "$USERNAME" =~ $USERNAME_REGEX ]]; then
            echo "ERROR: Invalid username '$USERNAME'."
            exit 1
        fi

        if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
            echo "ERROR: User '$USERNAME' does not exist."
            exit 1
        fi

        UID_VALUE=$(id -u "$USERNAME")

        if [ "$UID_VALUE" -lt 1000 ]; then
            echo "ERROR: System/service user '$USERNAME' cannot be added."
            exit 1
        fi

    done

fi

# ------------------------------------------------------------
# Final validation
# ------------------------------------------------------------

echo
echo "----------------------------------------------"
echo "Review /etc/group entry"
echo "----------------------------------------------"
echo
echo "Group   : $GROUPNAME"
echo "GID     : $GID"
echo "Members : $MEMBERS"
echo
echo "Entry:"
echo "$GROUPNAME:x:$GID:$MEMBERS"
echo

read -r -p "Add this entry to /etc/group? [y/N]: " ANSWER

case "$ANSWER" in
    y|Y)
        ;;
    *)
        echo "Entry creation cancelled."
        exit 0
        ;;
esac

# ------------------------------------------------------------
# Final duplicate checks
# ------------------------------------------------------------

if getent group "$GROUPNAME" >/dev/null 2>&1; then
    echo "ERROR: Group was created by another process."
    exit 1
fi

if getent group "$GID" >/dev/null 2>&1; then
    echo "ERROR: GID was assigned by another process."
    exit 1
fi

# ------------------------------------------------------------
# Append entry
# ------------------------------------------------------------

printf '%s\n' "$GROUPNAME:x:$GID:$MEMBERS" >> "$GROUP_FILE"

echo
echo "SUCCESS: Group entry added to /etc/group."
echo
echo "Verify with:"
echo "  getent group $GROUPNAME"
echo "  grep '^$GROUPNAME:' /etc/group"
echo

exit 0
EOF

"$REAL_CHMOD" 755 "$LIBEXEC/group-entry"
"$REAL_CHOWN" root:root "$LIBEXEC/group-entry"

# ============================================================
# Command launchers
# ============================================================

cat > "$BIN/passwd-entry" <<EOF
#!/bin/bash
exec "$LIBEXEC/passwd-entry" "\$@"
EOF

cat > "$BIN/group-entry" <<EOF
#!/bin/bash
exec "$LIBEXEC/group-entry" "\$@"
EOF

"$REAL_CHMOD" 755 "$BIN/passwd-entry"
"$REAL_CHMOD" 755 "$BIN/group-entry"

"$REAL_CHOWN" root:root "$BIN/passwd-entry"
"$REAL_CHOWN" root:root "$BIN/group-entry"

# ============================================================
# Finished
# ============================================================

echo
echo "=============================================="
echo " Manual account-entry wrappers installed."
echo "=============================================="
echo
echo "Commands:"
echo
echo "  sudo passwd-entry"
echo "  sudo group-entry"
echo
echo "These wrappers are APPEND ONLY."
echo
echo "Students cannot:"
echo "  - create UID 0 users"
echo "  - create system/service users"
echo "  - create privileged groups"
echo "  - modify existing passwd/group entries"
echo "  - delete passwd/group entries"
echo "  - access /etc/shadow directly"
echo "  - use sudo editors on system files"
echo
