#!/bin/bash

set -e -u

echo '{
    "packages": {

    }
}' | jq '.' > release.json

function make_release() {
    for index in packages/*; do
        if [ -d "$index" ]; then
            for packages in ${index}/*; do
                jq ".packages.$(basename ${packages}) = {}" release.json | sponge release.json
                for versions in ${packages}/*; do
                    if [ $(basename ${versions}) == "latest" ]; then
                        pushd $versions > /dev/null
                            source build.sh
                        popd > /dev/null
                        jq ".packages.${PKG_NAME}.latest = \"${PKG_VERSION}\"" release.json | sponge release.json
                    else
                        pushd $versions > /dev/null
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
