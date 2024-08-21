#!/bin/bash
set -e -u


source scripts/utils.sh

OUT_DIR="$(pwd)/out"


command_line() {
    if [ "$1" == "all" ]; then
        echo "Building all...."
        mkdir -pv $OUT_DIR

        for index in packages/*; do
            if [ -d "$index" ]; then
                for package in ${index}/*; do
                echo "${package}"
                    pushd ${package}/latest
                        source build.sh
                        start_building
                    popd
                done
            fi
        done
    fi
}

command_line $1
