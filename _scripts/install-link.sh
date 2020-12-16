#!/usr/bin/env bash
set -u

# =======================
# Script arguments
# -----------------------
SOURCE="$(realpath $1)"  # e.g. ./target/.../utility.sh
TARGET="${2/.sh/}"       # e.g. ~/.../utility

# =======================
# Constants
# -----------------------
RED="\033[31;1m"
GREEN="\033[32;1m"
RESET="\033[0m"

# =======================
# Functions
# -----------------------
function _exit
{
    case $1 in
    0) echo -e "${GREEN}...Success!${RESET}";;
    *) echo -e "${RED}...Failure!${RESET}";;
    esac
    exit $1
}

# =======================
# Script
# -----------------------
echo "Attempting to install:"
echo "  link       : ${TARGET}"
echo "  pointing to: ${SOURCE}"

if [[ "$(readlink ${TARGET})" == "${SOURCE}" ]]; then
    echo "Existing link is up to date."; _exit 0
elif [[ -h "${TARGET}" ]]; then
    echo "Overwriting an existing link pointing to: '$(readlink ${TARGET})'."
    ln -sf "${SOURCE}" "${TARGET}" && _exit 0 || _exit 103
elif [[ ! -e "${TARGET}" ]]; then
    echo "File/link doesn't exist. Creating..."
    ln -s "${SOURCE}" "${TARGET}" && _exit 0 || _exit 104
else
    diff -q "${TARGET}" "${SOURCE}" > /dev/null
    case $? in
    0)
        # This kinda no longer makes sense since switching to symlinks.
        # The case will only be hit... never?
        echo "${TARGET}: Already up to date."; _exit 0
        ;;
    1)
        _SUFFIX="$(date '+%Y%m%d%H%M%S')"
        _NEW_TARGET="${TARGET}.${_SUFFIX}"
        echo -n "File ${TARGET} already exists. "
        echo "Renaming original with suffix \".${_SUFFIX}\"."
        mv "${TARGET}" "${_NEW_TARGET}"

        ln -s "${SOURCE}" "${TARGET}" && _exit 0 || _exit 105
        ;;
    2)
        _exit 102
        ;;
    esac
fi
