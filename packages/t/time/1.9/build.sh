PKG_NAME=time
PKG_VERSION="1.9"
PKG_SRC_URL="https://ftp.gnu.org/gnu/time/time-${PKG_VERSION}.tar.gz"
PKG_DEPENDENCIES=libc
PKG_MAKE_DEPENDENCIES=



pre_build() {
    download_sources

    tar xf time-${PKG_VERSION}.tar.gz
}


build_package() {
    pushd time-${PKG_VERSION}
        ./configure --prefix=/usr
        make
    popd
}


post_build() {
    :
}


do_install() {
    pushd time-${PKG_VERSION}
        fakeroot make install DESTDIR=$DESTDIR
    popd
}
