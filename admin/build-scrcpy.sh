#!/bin/bash
set -euo pipefail
: "${SUITE:?noble or trixie}"
case "$SUITE" in noble|trixie) ;; *) exit 2;; esac
cd /inputs
sha256sum -c <<'HASHES'
a24b996ac23d0f674d3237c00b39a97829d8acbe9e1657a6c216fd51ea488ee5  scrcpy-5.0.1.tar.gz
c4b08b950bd29d83caae0ab8d884298d27046a9d30700fb42841c50992665c90  SDL-3.4.18.tar.gz
764eb6f79811d5211fe9df341120882ba9994c7a61b897d7bf3fb662e53bc536  scrcpy-server
HASHES
mkdir -p /build /output
cd /build
tar -xzf /inputs/SDL-3.4.18.tar.gz
tar -xzf /inputs/scrcpy-5.0.1.tar.gz
cmake -S SDL-release-3.4.18 -B sdl-build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/scrcpy-manager -DSDL_TESTS=OFF -DSDL_TEST_LIBRARY=OFF -DSDL_STATIC=OFF -DSDL_SHARED=ON -DSDL_WAYLAND=OFF -DSDL_PIPEWIRE=OFF
cmake --build sdl-build --parallel 4
cmake --install sdl-build
export PKG_CONFIG_PATH=/usr/lib/scrcpy-manager/pkgconfig
meson setup scrcpy-build scrcpy-5.0.1 --prefix=/usr --buildtype=release -Dprebuilt_server=/inputs/scrcpy-server -Dc_link_args=-Wl,-rpath,/usr/lib/scrcpy-manager
ninja -C scrcpy-build -j4
stage=/build/package
DESTDIR="$stage" ninja -C scrcpy-build install
mkdir -p "$stage/usr/lib/scrcpy-manager" "$stage/usr/share/doc/scrcpy/SDL" "$stage/DEBIAN" debian
cp -a /usr/lib/scrcpy-manager/libSDL3.so.0* "$stage/usr/lib/scrcpy-manager/"
cp scrcpy-5.0.1/LICENSE "$stage/usr/share/doc/scrcpy/copyright"
cp SDL-release-3.4.18/LICENSE.txt "$stage/usr/share/doc/scrcpy/SDL/"
# SDL ships licenses for bundled permissive dependencies; preserve all of them.
(cd SDL-release-3.4.18 && find src -type f \( -iname '*license*' -o -iname '*copying*' \) -exec cp --parents '{}' "$stage/usr/share/doc/scrcpy/SDL/" \;)
cp -a /inputs/SDL-notices "$stage/usr/share/doc/scrcpy/SDL/attributions"
cat > debian/control <<'CONTROL'
Source: scrcpy
Section: utils
Priority: optional
Maintainer: Tomasz Golaszewski <tomaasz@users.noreply.github.com>

Package: scrcpy
Architecture: amd64
Description: Android screen mirroring
CONTROL
printf 'libSDL3 0 scrcpy (>= 5.0.1)\n' > debian/shlibs.local
native_deps=$(dpkg-shlibdeps -O -xscrcpy -l"$stage/usr/lib/scrcpy-manager" -e"$stage/usr/bin/scrcpy" -e"$stage/usr/lib/scrcpy-manager/libSDL3.so.0" | sed -n 's/^shlibs:Depends=//p')
test -n "$native_deps"
cat > "$stage/DEBIAN/control" <<CONTROL
Package: scrcpy
Version: 5.0.1-1sm1
Architecture: amd64
Maintainer: Tomasz Golaszewski <tomaasz@users.noreply.github.com>
Section: utils
Priority: optional
Depends: $native_deps, adb, libasound2t64, libpulse0, libudev1, libdbus-1-3, libx11-6, libxext6, libxrandr2, libxcursor1, libxi6, libxfixes3, libxss1, libxtst6, libgl1
Replaces: scrcpy-server (<< 5.0.1-1sm1)
Breaks: scrcpy-server (<< 5.0.1-1sm1)
Homepage: https://github.com/Genymobile/scrcpy
Description: Android screen mirroring with SDL3 for scrcpy Manager
 Upstream scrcpy 5.0.1 with a matching Android server and private SDL3.
 Built for $SUITE using the distribution's dynamic FFmpeg libraries.
 Sources and original notices accompany the scrcpy Manager APT repository.
CONTROL
# Don't start ADB or any GUI as root during packaging.
"$stage/usr/bin/scrcpy" --version
ldd "$stage/usr/bin/scrcpy" > /output/scrcpy-ldd.txt
if grep -q 'not found' /output/scrcpy-ldd.txt; then exit 1; fi
mkdir -p /output
strip "$stage/usr/bin/scrcpy" "$stage/usr/lib/scrcpy-manager/"libSDL3.so.0.*
dpkg-deb --root-owner-group --build -Zxz "$stage" /output/scrcpy_5.0.1-1sm1_amd64.deb
cp "$stage/DEBIAN/control" /output/control.txt
