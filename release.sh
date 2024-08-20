#!/bin/bash

set -e -u

echo '{
    "packages": {

    }
}' | jq '.' > release.json

function make_release() {
    for index in packages/*; do
        if [ -d "$index" ]; then
            for __package in ${index}/*; do
                jq ".packages.$(basename ${__package}) = {}" release.json | sponge release.json
                for __package__versions in ${__package}/*; do
                    if [ $(basename ${__package__versions}) == "latest" ]; then
                        pushd $__package__versions > /dev/null
                            source build.sh
                        popd > /dev/null
                        jq ".packages.${PKG_NAME}.latest = \"${PKG_VERSION}\"" release.json | sponge release.json
                    else
                        pushd $__package__versions > /dev/null
                            source build.sh
                        popd > /dev/null
                        jq ".packages.${PKG_NAME}.\"${PKG_VERSION}\" = {}" release.json | sponge release.json
                        jq ".packages.${PKG_NAME}.\"${PKG_VERSION}\".deps = \"${PKG_DEPENDENCIES}\"" release.json | sponge release.json
                    fi
                done
            done
        fi
    done
}

make_release
