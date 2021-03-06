#!/usr/bin/env bash
set -u

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

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

function _link
{
    mkdir -p "$(dirname ${TARGET})"
    ln -s $@ "${SOURCE}" "${TARGET}"
}

# =======================
# Script
# -----------------------
echo "Attempting to install:"
echo "  link       : ${TARGET}"
echo "  pointing to: ${SOURCE}"

if [[ "$(${READLINK} -e ${TARGET})" == "$(${READLINK} -e ${SOURCE})" ]]; then
    # The link is already installed
    echo "Existing link is up to date."; _exit 0

elif [[ -h "${TARGET}" ]]; then
    # There is a link but it points somewhere else
    echo "Overwriting an existing link pointing to: '$(${READLINK} -e ${TARGET})'."
    _link -f && _exit 0 || _exit 103

elif [[ ! -e "${TARGET}" ]]; then
    # There is no link or file
    echo "File/link doesn't exist. Creating link."
    _link && _exit 0 || _exit 104

else
    # There is a file where we want the link
    diff -q "${TARGET}" "${SOURCE}" > /dev/null
    case $? in
    0)
        # The installed file is identical to the rendered one
        echo "Overwriting an identical file with a link."
        _link -f && _exit 0 || _exit 105
        ;;
    1)
        # The installed file is different from the rendered one
        _SUFFIX="$(date '+%Y%m%d%H%M%S')"
        _NEW_TARGET="${TARGET}.${_SUFFIX}"
        echo -n "File ${TARGET} already exists. "
        echo "Renaming original with suffix \".${_SUFFIX}\"."
        mv "${TARGET}" "${_NEW_TARGET}"

        echo "Replacing the original with link."
        _link || _exit 106

        echo "Overwriting the link target with the original."
        mv -f "${_NEW_TARGET}" "$(${READLINK} ${TARGET})" || _exit 107
        ;;
    2)
        _exit 108
        ;;
    esac
fi
