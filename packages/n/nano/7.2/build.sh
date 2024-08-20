PKG_NAME=nano
PKG_VERSION="7.2"
PKG_SRC_URL=https://www.nano-editor.org/dist/v7/nano-${PKG_VERSION}.tar.xz
PKG_DEPENDENCIES="libc libncurses"
PKG_MAKE_DEPENDENCIES=



pre_build() {
    download_sources

    tar xf nano-${PKG_VERSION}.tar.xz
}


build_package() {
    pushd nano-${PKG_VERSION}
        ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-7.2 &&
        make
    popd
}


post_build() {
    :
}


do_install() {
    pushd nano-${PKG_VERSION}
        fakeroot make install DESTDIR=$DESTDIR
        fakeroot install -v -m644 doc/{nano.html,sample.nanorc} ${DESTDIR}/usr/share/doc/nano-7.2
        fakeroot mkdir $DESTDIR/etc
        fakeroot cat <<EOF > ${DESTDIR}/etc/nanorc
set autoindent
set constantshow
set fill 72
set historylog
set multibuffer
set nohelp
set positionlog
set quickblank
set regexp
EOF
    popd
}
