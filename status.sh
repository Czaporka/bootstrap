RED="\033[31m"
RED_BOLD="\033[31;1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

find target/ -type f | while read rendered; do
    installed=${rendered/target\//~/.}
    if [[ ! -f ${installed} ]]; then
        echo -e "${RED}[Not installed]: ${installed}${RESET}"
        continue
    fi
    diff -q ${installed} ${rendered} > /dev/null
    case $? in
    0) echo -e "${GREEN}[Up to date   ]: ${installed}${RESET}" ;;
    1) echo -e "${YELLOW}[Differs      ]: ${installed}${RESET}" ;;
    2) echo -e "${RED_BOLD}[   ERROR   ]:${installed}${RESET}" ;;
    esac
done
exit 0
