# This function expects to be run in temporary build directory
download_sources() {
    for link in ${PKG_SRC_URL}; do
        curl -O $link
    done
}


setup_dist_dir() {
    mkdir -pv dist/{scripts,data}
}


setup_metadata() {
    cat <<EOF > dist/metadata
{
    "name":"${PKG_NAME}",
    "version":"${PKG_VERSION}",
    "dependencies:"${PKG_DEPENDENCIES}",
    "make_dependencies":"${PKG_MAKE_DEPENDENCIES}"
}
EOF
}


start_building() {
    PKG_BUILD_DIR="/tmp/lpkm/build/${PKG_NAME}-${PKG_VERSION}"
    rm -rf $PKG_BUILD_DIR
    mkdir -pv $PKG_BUILD_DIR
    pushd ${PKG_BUILD_DIR}
        setup_dist_dir
        setup_metadata
        DESTDIR="$PKG_BUILD_DIR/dist/data"

        pre_build
        build_package
        post_build
        
        do_install
    popd

    cp pre-inst.sh post-inst.sh pre-rm.sh post-rm.sh ${PKG_BUILD_DIR}/dist/scripts
    pushd ${PKG_BUILD_DIR}/dist
            fakeroot tar -czvpf ../${PKG_NAME}-${PKG_VERSION}.lpkm *
            cp ../${PKG_NAME}-${PKG_VERSION}.lpkm $OUT_DIR -vf
    popd
}

