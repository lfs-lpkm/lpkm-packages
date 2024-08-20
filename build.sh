#!/bin/bash
set -e


source scripts/utils.sh

OUT_DIR="$(pwd)/out"
mkdir -pv $OUT_DIR

command_line() {
    if [ "$1" == "all" ]; then
        echo "Building all...."

        for index in packages/*; do
            if [ -d "$index" ]; then
                for __package in ${index}/*; do
                echo "${__package}"
                    pushd ${__package}/latest
                        source build.sh
                        start_building
                    popd
                done
            fi
        done
    fi
}

command_line $1
