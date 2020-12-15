#!/usr/bin/env bash
set -u

SOURCE="${1}"       # rendered, i.e. present in ./target/...
TARGET="${2/.sh/}"  # installed, i.e. present in ~/...

function _install
{
    if [[ -f "${TARGET}" ]]; then
        _SUFFIX="$(date '+%Y%m%d%H%M%S')"
        _NEW_TARGET="${TARGET}.${_SUFFIX}"
        echo "Target ${TARGET} already installed. Renaming original with suffix \".${_SUFFIX}\"."
        mv ${TARGET} ${_NEW_TARGET}
    fi
    cp ${SOURCE} ${TARGET}
}

if [[ ! -f ${TARGET} ]]; then
    _install
    exit 0
else
    diff -q ${TARGET} ${SOURCE} > /dev/null
    case $? in
    0)
        echo "${TARGET}: Already up to date."
        break
        ;;
    1)
        _install
        break
        ;;
    2)
        exit 2
        ;;
    esac
fi

exit 0
