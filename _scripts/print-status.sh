#!/usr/bin/env bash
set -u

A="${1/.sh/}"  # installed, i.e. present in ~/...
B="${2}"       # rendered, i.e. present in ./target/...

RED="\033[31m"
RED_BOLD="\033[31;1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

if [[ ! -f ${A} ]]; then
    echo -e "${RED}[Not installed]: ${A}${RESET}"
    exit 0
fi
diff -q ${A} ${B} > /dev/null
case $? in
0) echo -e "${GREEN}[Up to date   ]: ${A}${RESET}" ;;
1) echo -e "${YELLOW}[Differs      ]: ${A}${RESET}" ;;
2) echo -e "${RED_BOLD}[    ERROR    ]: ${A}${RESET}" ;;
esac

exit 0
