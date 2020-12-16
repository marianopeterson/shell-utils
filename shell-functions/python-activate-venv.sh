#!/bin/bash

function acti {
    usage() {
        echo "NAME"
        echo "    ${FUNCNAME[1]} -- Activate a python virtual environment"
        echo ""
        echo "SYNOPSIS"
        echo "    ${FUNCNAME[1]} [-h] [VENV_ROOT]"
        echo ""
        echo "DESCRIPTION"
        echo "    -h|--help     Print usage"
        echo "    VENV_ROOT     Path to location of the virtual environment"
        echo "                  e.g., ~/venv/pandas"
        echo "                  default: ./venv"
        echo ""
    }
    if [[ ${1} =~ ^(-h|--help)$ ]]; then
        usage
        return 0
    fi

    local venv_root="./venv"
    if [[ $# -eq 1 ]]; then
        venv_root=$1
    fi

    if [ ! -f "${venv_root}/bin/activate" ]; then
        echo "There is no virtual environment in '${venv_root}'."
        read -p "Would you like to create one? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            virtualenv "${venv_root}"
            echo "Type 'deactivate' to exit the virtual environment."
        else
            return
        fi
    fi
    source "${venv_root}/bin/activate"
}
