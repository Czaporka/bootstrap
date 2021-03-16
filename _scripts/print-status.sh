#!/usr/bin/env bash
set -u

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

A="${1/.sh/}"       # installed, i.e. present in ~/...
B="$(realpath $2)"  # rendered, i.e. present in ./target/...

C_NIN="\033[90m"    # Not Installed
C_NTR="\033[33m"    # Not Tracked
C_ERR="\033[91;1m"  # Error
C_UTD="\033[32m"    # Up To Date
C_DIF="\033[31m"    # Differs
RESET="\033[0m"

if [[ ! -f ${A} ]]; then
    echo -e "${C_NIN}[Not installed]: ${A}${RESET}"
    exit 0
elif [[ -h "${A}" && "$(${READLINK} -e $A)" == "${B}" ]]; then
    echo -e "${C_UTD}[Up to date   ]: ${A}${RESET}"
else
    diff -q ${A} ${B} > /dev/null
    case $? in
    0) echo -e "${C_NTR}[Not tracked  ]: ${A}${RESET}" ;;
    1) echo -e "${C_DIF}[Differs      ]: ${A}${RESET}" ;;
    2) echo -e "${C_ERR}[    ERROR    ]: ${A}${RESET}" ;;
    esac
fi

exit 0
