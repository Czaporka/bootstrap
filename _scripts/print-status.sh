#!/usr/bin/env bash
set -u

A="${1/.sh/}"  # installed, i.e. present in ~/...
B="${2}"       # rendered, i.e. present in ./target/...

C_NOT_INSTALLED="\033[90m"
C_ERROR="\033[91;1m"
C_UP_TO_DATE="\033[32m"
C_DIFFERS="\033[31m"
RESET="\033[0m"

if [[ ! -f ${A} ]]; then
    echo -e "${C_NOT_INSTALLED}[Not installed]: ${A}${RESET}"
    exit 0
fi
diff -q ${A} ${B} > /dev/null
case $? in
0) echo -e "${C_UP_TO_DATE}[Up to date   ]: ${A}${RESET}" ;;
1) echo -e "${C_DIFFERS}[Differs      ]: ${A}${RESET}" ;;
2) echo -e "${C_ERROR}[    ERROR    ]: ${A}${RESET}" ;;
esac

exit 0
