#!/bin/bash
# ==================================================
# Create a virtual environment in current directory,
#   activate it and install packages into it.
# --------------------------------------------------

set -u

# https://stackoverflow.com/a/17841619/14222267
function join-by
{
    local d=$1; shift
    local f=$1; shift
    printf %s "$f" "${@/#/$d}"
}

DEVELOPMENT=false
DEV_PACKAGES=(
    coverage
    flake8
    ipython
    pycodestyle
    pytest
)
ENV_NAME=.env
FORCE=false
PYTHON=python3
read -r -d "" HELP <<EOF
Usage: make-env [OPTIONS] [PACKAGES]
Example: make-env
Example: make-env -n=my_env -d --force
Options:
  -d, --development   : install additional packages for development: $(join-by ", " "${DEV_PACKAGES[@]}")
  -f, --force         : re-create the environment if it already exists
  -n, --name=NAME     : give the environment a custom name instead of the default: ${ENV_NAME}
  -p, --python=PYTHON : use a custom Python interpreter instead of the default: ${PYTHON}
  -h, --help          : display this help message and exit
EOF

OPTS=$(getopt -o dhfn:p: --long development,help,force,name,python: -n make-env -- "$@")
if [[ $? != 0 ]]
then
    echo "Error: Could not parse opts." >&2
    exit 1
fi

eval set -- "${OPTS}"

while true
do
    case "$1" in
        -d|--development) DEVELOPMENT=true; shift;;
        -f|--force)       FORCE=true; shift;;
        -h|--help)        echo "$HELP" && exit 0;;
        -n|--name)        ENV_NAME="${2}"; shift; shift;;
        -p|--python)      PYTHON="${2}"; shift; shift;;
        --)               shift; break ;;
        *) break ;;
    esac
done

# remove the existing virtual environment
[[ "${FORCE}" == true ]] && rm -rf "${ENV_NAME}"

# create the virtual environment
[[ ! -d "${ENV_NAME}" ]] && "$PYTHON" -m venv "${ENV_NAME}"

# activate the virtual environment
source "${ENV_NAME}/bin/activate"

# install the packages
PIP_INSTALL_ARGS=()
[[ -f "requirements.txt" ]] && PIP_INSTALL_ARGS+=( -r requirements.txt )
PIP_INSTALL_ARGS+=("$@")
[[ "${DEVELOPMENT}" == true ]] && PIP_INSTALL_ARGS+=( "${DEV_PACKAGES[@]}" )
python -m pip install "${PIP_INSTALL_ARGS[@]}"
