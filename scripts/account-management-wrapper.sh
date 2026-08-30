#!/bin/bash

# ============================================================
# LINOOP Student Account Management Wrapper Installer
# ============================================================
#
# Controlled sudo wrappers for student Linux account labs.
#
# Supported commands:
#
#   useradd
#   userdel
#   usermod
#   groupadd
#   groupdel
#   groupmod
#   gpasswd
#   passwd
#   chage
#   mkdir
#   cp
#   chown
#   chmod
#   su
#
# Students continue using normal commands:
#
#   sudo useradd new-user
#   sudo groupadd developers
#   sudo mkdir /home/new-user
#   sudo /usr/local/bin/linoop-skel-copy /home/new-user
#   sudo chown -R new-user:new-user /home/new-user
#   sudo chmod 700 /home/new-user
#   sudo passwd new-user
#   sudo su - new-user
#
# Direct editing of:
#   /etc/passwd
#   /etc/group
#   /etc/shadow
#
# is NOT permitted through this wrapper.
#
# ============================================================

set -e

LIBEXEC="/usr/local/libexec/linoop"
BIN="/usr/local/bin"

echo
echo "=============================================="
echo " LINOOP Student Account Wrapper Installer"
echo "=============================================="
echo

# ------------------------------------------------------------
# Check root
# ------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this installer as root."
    exit 1
fi

# ------------------------------------------------------------
# Create directories
# ------------------------------------------------------------

mkdir -p "$LIBEXEC"
mkdir -p "$BIN"

chown root:root "$LIBEXEC" "$BIN"

chmod 755 "$LIBEXEC"
chmod 755 "$BIN"

# ============================================================
# USERADD
# ============================================================

cat > "$LIBEXEC/useradd" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/useradd"

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo useradd <username>"
    exit 1
fi

USERNAME="$1"

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User '$USERNAME' already exists."
    exit 1
fi

case "$USERNAME" in
    root|bin|daemon|adm|lp|sync|shutdown|halt|mail|operator|games|ftp|nobody|dbus|tss|sshd|chrony|apache|named|rpc|rpcuser|nfsnobody|systemd-network|systemd-oom|systemd-resolve|systemd-timesync)
        echo "ERROR: Reserved/system username is not allowed."
        exit 1
        ;;
esac

# Always create a normal user with a home directory.
exec "$REAL" -m "$USERNAME"
EOF

chmod 755 "$LIBEXEC/useradd"


# ============================================================
# USERDEL
# ============================================================

cat > "$LIBEXEC/userdel" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/userdel"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: sudo userdel [-r] <username>"
    exit 1
fi

if [ "$1" = "-r" ]; then
    if [ "$#" -ne 2 ]; then
        echo "Usage: sudo userdel [-r] <username>"
        exit 1
    fi

    USERNAME="$2"
    REMOVE_HOME=1
else
    USERNAME="$1"
    REMOVE_HOME=0
fi

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ "$USERNAME" = "root" ]; then
    echo "ERROR: root cannot be deleted."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User '$USERNAME' does not exist."
    exit 1
fi

UID_VALUE=$(id -u "$USERNAME")

if [ "$UID_VALUE" -lt 1000 ]; then
    echo "ERROR: System accounts cannot be deleted."
    exit 1
fi

if [ "$REMOVE_HOME" -eq 1 ]; then
    exec "$REAL" -r "$USERNAME"
else
    exec "$REAL" "$USERNAME"
fi
EOF

chmod 755 "$LIBEXEC/userdel"


# ============================================================
# USERMOD
# ============================================================

cat > "$LIBEXEC/usermod" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/usermod"

if [ "$#" -lt 2 ]; then
    echo "Usage:"
    echo "  sudo usermod -aG <group> <username>"
    echo "  sudo usermod -L <username>"
    echo "  sudo usermod -U <username>"
    exit 1
fi

case "$1" in

    -aG)

        if [ "$#" -ne 3 ]; then
            echo "Usage: sudo usermod -aG <group> <username>"
            exit 1
        fi

        GROUP="$2"
        USERNAME="$3"

        if [[ ! "$GROUP" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
            echo "ERROR: Invalid group name."
            exit 1
        fi

        if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
            echo "ERROR: Invalid username."
            exit 1
        fi

        if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
            echo "ERROR: User '$USERNAME' does not exist."
            exit 1
        fi

        if ! getent group "$GROUP" >/dev/null 2>&1; then
            echo "ERROR: Group '$GROUP' does not exist."
            exit 1
        fi

        exec "$REAL" -aG "$GROUP" "$USERNAME"
        ;;

    -L|-U)

        if [ "$#" -ne 2 ]; then
            echo "Usage: sudo usermod $1 <username>"
            exit 1
        fi

        USERNAME="$2"

        if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
            echo "ERROR: Invalid username."
            exit 1
        fi

        if [ "$USERNAME" = "root" ]; then
            echo "ERROR: root cannot be modified."
            exit 1
        fi

        if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
            echo "ERROR: User does not exist."
            exit 1
        fi

        exec "$REAL" "$1" "$USERNAME"
        ;;

    *)

        echo "ERROR: This usermod operation is not permitted."
        echo
        echo "Allowed:"
        echo "  sudo usermod -aG <group> <username>"
        echo "  sudo usermod -L <username>"
        echo "  sudo usermod -U <username>"
        exit 1
        ;;

esac
EOF

chmod 755 "$LIBEXEC/usermod"


# ============================================================
# GROUPADD
# ============================================================

cat > "$LIBEXEC/groupadd" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/groupadd"

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo groupadd <groupname>"
    exit 1
fi

GROUP="$1"

if [[ ! "$GROUP" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid group name."
    exit 1
fi

if getent group "$GROUP" >/dev/null 2>&1; then
    echo "ERROR: Group '$GROUP' already exists."
    exit 1
fi

case "$GROUP" in
    root|wheel|adm|bin|daemon|sys|tty|disk|mail|operator|users)
        echo "ERROR: Reserved group name is not allowed."
        exit 1
        ;;
esac

exec "$REAL" "$GROUP"
EOF

chmod 755 "$LIBEXEC/groupadd"


# ============================================================
# GROUPDEL
# ============================================================

cat > "$LIBEXEC/groupdel" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/groupdel"

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo groupdel <groupname>"
    exit 1
fi

GROUP="$1"

if [[ ! "$GROUP" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid group name."
    exit 1
fi

case "$GROUP" in
    root|wheel|adm|bin|daemon|sys|tty|disk|mail|operator|users)
        echo "ERROR: Reserved group cannot be deleted."
        exit 1
        ;;
esac

if ! getent group "$GROUP" >/dev/null 2>&1; then
    echo "ERROR: Group does not exist."
    exit 1
fi

exec "$REAL" "$GROUP"
EOF

chmod 755 "$LIBEXEC/groupdel"


# ============================================================
# GROUPMOD
# ============================================================

cat > "$LIBEXEC/groupmod" <<'EOF'
#!/bin/bash

REAL="/usr/sbin/groupmod"

if [ "$#" -ne 3 ] || [ "$1" != "-n" ]; then
    echo "Usage: sudo groupmod -n <newname> <oldname>"
    exit 1
fi

NEWNAME="$2"
OLDNAME="$3"

if [[ ! "$NEWNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid new group name."
    exit 1
fi

if [[ ! "$OLDNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid old group name."
    exit 1
fi

case "$OLDNAME" in
    root|wheel|adm|bin|daemon|sys|tty|disk|mail|operator|users)
        echo "ERROR: Reserved group cannot be modified."
        exit 1
        ;;
esac

if ! getent group "$OLDNAME" >/dev/null 2>&1; then
    echo "ERROR: Group '$OLDNAME' does not exist."
    exit 1
fi

if getent group "$NEWNAME" >/dev/null 2>&1; then
    echo "ERROR: Group '$NEWNAME' already exists."
    exit 1
fi

exec "$REAL" -n "$NEWNAME" "$OLDNAME"
EOF

chmod 755 "$LIBEXEC/groupmod"


# ============================================================
# GPASSWD
# ============================================================

cat > "$LIBEXEC/gpasswd" <<'EOF'
#!/bin/bash

REAL="/usr/bin/gpasswd"

# Only permit:
#
#   gpasswd -a USER GROUP
#   gpasswd -d USER GROUP
#
# This is enough for normal group membership exercises.

if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "  sudo gpasswd -a <username> <group>"
    echo "  sudo gpasswd -d <username> <group>"
    exit 1
fi

ACTION="$1"
USERNAME="$2"
GROUP="$3"

case "$ACTION" in
    -a|-d)
        ;;
    *)
        echo "ERROR: Only -a and -d are permitted."
        exit 1
        ;;
esac

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [[ ! "$GROUP" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid group name."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User does not exist."
    exit 1
fi

if ! getent group "$GROUP" >/dev/null 2>&1; then
    echo "ERROR: Group does not exist."
    exit 1
fi

exec "$REAL" "$ACTION" "$USERNAME" "$GROUP"
EOF

chmod 755 "$LIBEXEC/gpasswd"


# ============================================================
# PASSWD
# ============================================================

cat > "$LIBEXEC/passwd" <<'EOF'
#!/bin/bash

REAL="/usr/bin/passwd"

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo passwd <username>"
    exit 1
fi

USERNAME="$1"

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ "$USERNAME" = "root" ]; then
    echo "ERROR: Changing the root password is not permitted."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User '$USERNAME' does not exist."
    exit 1
fi

UID_VALUE=$(id -u "$USERNAME")

if [ "$UID_VALUE" -lt 1000 ]; then
    echo "ERROR: System account passwords cannot be changed."
    exit 1
fi

# Password management is intentionally handled by passwd.
# Students never receive direct access to /etc/shadow.

exec "$REAL" "$USERNAME"
EOF

chmod 755 "$LIBEXEC/passwd"


# ============================================================
# CHAGE
# ============================================================

cat > "$LIBEXEC/chage" <<'EOF'
#!/bin/bash

REAL="/usr/bin/chage"

if [ "$#" -lt 2 ]; then
    echo "Usage: sudo chage OPTIONS <username>"
    exit 1
fi

USERNAME="${@: -1}"

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ "$USERNAME" = "root" ]; then
    echo "ERROR: root cannot be modified."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User does not exist."
    exit 1
fi

UID_VALUE=$(id -u "$USERNAME")

if [ "$UID_VALUE" -lt 1000 ]; then
    echo "ERROR: System accounts cannot be modified."
    exit 1
fi

exec "$REAL" "$@"
EOF

chmod 755 "$LIBEXEC/chage"


# ============================================================
# MKDIR
# ============================================================

cat > "$LIBEXEC/mkdir" <<'EOF'
#!/bin/bash

REAL="/usr/bin/mkdir"

# Only allow:
#
#   sudo mkdir /home/USERNAME
#
# No -p, -m, --mode, or arbitrary directories.

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo mkdir /home/<username>"
    exit 1
fi

TARGET="$1"

if [[ "$TARGET" != /home/* ]]; then
    echo "ERROR: mkdir is restricted to /home."
    exit 1
fi

USERNAME="${TARGET#/home/}"

if [[ "$USERNAME" == */* || -z "$USERNAME" ]]; then
    echo "ERROR: Only /home/USERNAME is permitted."
    exit 1
fi

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User does not exist."
    exit 1
fi

if [ -e "$TARGET" ]; then
    echo "ERROR: Directory already exists."
    exit 1
fi

exec "$REAL" "$TARGET"
EOF

chmod 755 "$LIBEXEC/mkdir"


# ============================================================
# CP FROM /etc/skel
# ============================================================

#!/bin/bash

REAL="/usr/bin/cp"

# ============================================================
# LINOOP Restricted /etc/skel Copy
#
# Allowed:
#
#   sudo /usr/local/bin/linoop-skel-copy /home/USERNAME
#
# This allows students to populate a newly created
# user's home directory from /etc/skel.
#
# Normal cp operations remain unrestricted.
# ============================================================

# ------------------------------------------------------------
# Require exactly one argument
# ------------------------------------------------------------

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo /usr/local/bin/linoop-skel-copy /home/USERNAME"
    exit 1
fi

TARGET="$1"

# ------------------------------------------------------------
# Target must be directly under /home
# ------------------------------------------------------------

if [[ "$TARGET" != /home/* ]]; then
    echo "ERROR: Destination must be /home/USERNAME."
    exit 1
fi

USERNAME="${TARGET#/home/}"
USERNAME="${USERNAME%/}"

if [[ "$USERNAME" == */* || -z "$USERNAME" ]]; then
    echo "ERROR: Destination must be /home/USERNAME."
    exit 1
fi

# ------------------------------------------------------------
# Validate username
# ------------------------------------------------------------

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

# ------------------------------------------------------------
# User must exist
# ------------------------------------------------------------

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User '$USERNAME' does not exist."
    exit 1
fi

# ------------------------------------------------------------
# Home directory must exist
# ------------------------------------------------------------

if [ ! -d "/home/$USERNAME" ]; then
    echo "ERROR: Home directory /home/$USERNAME does not exist."
    exit 1
fi

# ------------------------------------------------------------
# Copy /etc/skel
# ------------------------------------------------------------

exec "$REAL" -a /etc/skel/. "/home/$USERNAME/"


# ============================================================
# CHOWN
# ============================================================

cat > "$LIBEXEC/chown" <<'EOF'
#!/bin/bash

REAL="/usr/bin/chown"

# ============================================================
# LINOOP Restricted chown wrapper
#
# Allowed:
#
#   sudo chown USER FILE
#   sudo chown USER:GROUP FILE
#   sudo chown :GROUP FILE
#
# Recursive:
#
#   sudo chown -R USER DIRECTORY
#   sudo chown -R USER:GROUP DIRECTORY
#   sudo chown -R :GROUP DIRECTORY
#
# Target must be inside the calling user's home directory.
# ============================================================

REAL_CHOWN="/bin/chown"

CALLING_USER="${SUDO_USER:-}"

if [ -z "$CALLING_USER" ] || [ "$CALLING_USER" = "root" ]; then
    echo "ERROR: Invalid calling user."
    exit 1
fi

USER_HOME=$(getent passwd "$CALLING_USER" | cut -d: -f6)

if [ -z "$USER_HOME" ] || [ ! -d "$USER_HOME" ]; then
    echo "ERROR: Cannot determine home directory for $CALLING_USER."
    exit 1
fi

REAL_HOME=$(realpath -e "$USER_HOME") || {
    echo "ERROR: Cannot resolve home directory."
    exit 1
}

RECURSIVE=0

while [ "$#" -gt 0 ]; do

    case "$1" in

        -R|--recursive)
            RECURSIVE=1
            shift
            ;;

        --)
            shift
            break
            ;;

        -*)
            echo "ERROR: Option '$1' is not allowed."
            exit 1
            ;;

        *)
            break
            ;;

    esac

done

if [ "$#" -lt 2 ]; then
    echo "Usage:"
    echo "  sudo chown [ -R ] USER FILE..."
    echo "  sudo chown [ -R ] USER:GROUP FILE..."
    echo "  sudo chown [ -R ] :GROUP FILE..."
    exit 1
fi

OWNER_SPEC="$1"
shift

if [[ "$OWNER_SPEC" == :* ]]; then

    OWNER=""
    GROUP="${OWNER_SPEC#:}"

elif [[ "$OWNER_SPEC" == *:* ]]; then

    OWNER="${OWNER_SPEC%%:*}"
    GROUP="${OWNER_SPEC#*:}"

else

    OWNER="$OWNER_SPEC"
    GROUP=""

fi

if [ -z "$OWNER" ] && [ -z "$GROUP" ]; then
    echo "ERROR: Invalid ownership specification."
    exit 1
fi

if [ "$OWNER" = "root" ]; then
    echo "ERROR: Assigning root as the file owner is not permitted."
    exit 1
fi

if [ -n "$OWNER" ]; then

    if ! getent passwd "$OWNER" >/dev/null 2>&1; then
        echo "ERROR: User '$OWNER' does not exist."
        exit 1
    fi

fi

if [ -n "$GROUP" ]; then

    if ! getent group "$GROUP" >/dev/null 2>&1; then
        echo "ERROR: Group '$GROUP' does not exist."
        exit 1
    fi

fi

CHOWN_ARGS=()

if [ "$RECURSIVE" -eq 1 ]; then
    CHOWN_ARGS+=("-R")
fi

CHOWN_ARGS+=("$OWNER_SPEC")

for TARGET in "$@"; do

    # Target must exist
    if [ ! -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "ERROR: Target does not exist:"
        echo "  $TARGET"
        exit 1
    fi

    # Resolve actual path
    REAL_TARGET=$(realpath -e "$TARGET" 2>/dev/null) || {
        echo "ERROR: Cannot resolve target:"
        echo "  $TARGET"
        exit 1
    }

    case "$REAL_TARGET" in

        "$REAL_HOME")
            ;;

        "$REAL_HOME"/*)
            ;;

        *)
            echo "ERROR: Access denied."
            echo
            echo "Your allowed directory:"
            echo "  $REAL_HOME"
            echo
            echo "Requested target:"
            echo "  $TARGET"
            exit 1
            ;;

    esac

done

exec "$REAL_CHOWN" "${CHOWN_ARGS[@]}" "$@"
EOF

chmod 755 "$LIBEXEC/chown"


# ============================================================
# CHMOD
# ============================================================

cat > "$LIBEXEC/chmod" <<'EOF'
#!/bin/bash

REAL="/usr/bin/chmod"

# Supported:
#
#   sudo chmod 700 /home/USERNAME
#   sudo chmod 755 /home/USERNAME
#
# Numeric modes only.

if [ "$#" -ne 2 ]; then
    echo "Usage: sudo chmod MODE /home/USERNAME"
    exit 1
fi

MODE="$1"
TARGET="$2"

if [[ ! "$MODE" =~ ^[0-7]{3,4}$ ]]; then
    echo "ERROR: Only numeric permissions are permitted."
    exit 1
fi

if [[ "$TARGET" != /home/* ]]; then
    echo "ERROR: chmod is restricted to /home."
    exit 1
fi

USERNAME="${TARGET#/home/}"

if [[ "$USERNAME" == */* || -z "$USERNAME" ]]; then
    echo "ERROR: Only /home/USERNAME is permitted."
    exit 1
fi

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ ! -d "$TARGET" ]; then
    echo "ERROR: Directory does not exist."
    exit 1
fi

exec "$REAL" "$@"
EOF

chmod 755 "$LIBEXEC/chmod"


# ============================================================
# SU
# ============================================================

cat > "$LIBEXEC/su" <<'EOF'
#!/bin/bash

REAL="/usr/bin/su"

# Only allow:
#
#   sudo su - USERNAME
#
# Never allow root.

if [ "$#" -ne 2 ] || [ "$1" != "-" ]; then
    echo "Usage: sudo su - <username>"
    exit 1
fi

USERNAME="$2"

if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9._-]{0,31}$ ]]; then
    echo "ERROR: Invalid username."
    exit 1
fi

if [ "$USERNAME" = "root" ]; then
    echo "ERROR: Switching to root is not permitted."
    exit 1
fi

if ! getent passwd "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: User does not exist."
    exit 1
fi

UID_VALUE=$(id -u "$USERNAME")

if [ "$UID_VALUE" -lt 1000 ]; then
    echo "ERROR: Switching to system accounts is not permitted."
    exit 1
fi

exec "$REAL" - "$USERNAME"
EOF

chmod 755 "$LIBEXEC/su"


# ============================================================
# COMMAND LAUNCHERS
# ============================================================

COMMANDS="
useradd
userdel
usermod
groupadd
groupdel
groupmod
gpasswd
passwd
chage
mkdir
cp
chown
chmod
su
"

for CMD in $COMMANDS
do

    cat > "$BIN/$CMD" <<EOF
#!/bin/bash
exec "$LIBEXEC/$CMD" "\$@"
EOF

    chmod 755 "$BIN/$CMD"
    chown root:root "$BIN/$CMD"

done


# ============================================================
# Final permissions
# ============================================================

chown root:root "$LIBEXEC"/*

chmod 755 "$LIBEXEC"/*
chmod 755 "$BIN"/useradd \
          "$BIN"/userdel \
          "$BIN"/usermod \
          "$BIN"/groupadd \
          "$BIN"/groupdel \
          "$BIN"/groupmod \
          "$BIN"/gpasswd \
          "$BIN"/passwd \
          "$BIN"/chage \
          "$BIN"/mkdir \
          "$BIN"/skel-copy \
          "$BIN"/chown \
          "$BIN"/chmod \
          "$BIN"/su


# ============================================================
# Finished
# ============================================================

echo
echo "=============================================="
echo " LINOOP wrappers installed successfully."
echo "=============================================="
echo
echo "Wrapper location:"
echo "  $LIBEXEC"
echo
echo "Student command location:"
echo "  $BIN"
echo
echo "Supported commands:"
echo "  useradd"
echo "  userdel"
echo "  usermod"
echo "  groupadd"
echo "  groupdel"
echo "  groupmod"
echo "  gpasswd"
echo "  passwd"
echo "  chage"
echo "  mkdir"
echo "  cp"
echo "  chown"
echo "  chmod"
echo "  su"
echo
echo "Direct access to /etc/passwd, /etc/group,"
echo "and /etc/shadow is NOT provided."
echo
echo "Next step: configure sudoers to allow"
echo "the /usr/local/bin wrapper commands."
echo
