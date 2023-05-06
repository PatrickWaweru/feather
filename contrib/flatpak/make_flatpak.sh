#!/usr/bin/env bash
set -ex

get_store_path() {
    find gnu/store -maxdepth 1 -type d -name "*$1*" | sort | head -n 1
}

cd /flatpak

# Create build dir
mkdir build
cd build

mkdir export
mkdir files
mkdir var

# Copy the metadata file
cp /feather/contrib/flatpak/metadata .

# Populate var
cd var

mkdir lib
mkdir tmp
ln -s /run run

cd ..

# Extract guix pack
cd files
tar xf /pack .

# Get store paths
GUIX_BASH_STATIC=$(get_store_path "bash-static")
GUIX_COREUTILS=$(get_store_path "coreutils-minimal")
GUIX_GLIBC=$(get_store_path "glibc")
GUIX_PROFILE=$(get_store_path "profile")

GLIBC_VERSION="${GUIX_GLIBC##*-}"

# Patch ln
LN_PATH="${GUIX_COREUTILS}/bin/ln"

chmod 655 "${LN_PATH}"

patchelf --set-rpath "/app/${GUIX_GLIBC}/lib" "${LN_PATH}"
patchelf --set-interpreter "/app/${GUIX_GLIBC}/lib/ld-linux-x86-64.so.2" "${LN_PATH}"

# Fonts
# fontconfig looks in /app/share/fonts
ln -s "${GUIX_PROFILE}/share" share

chmod 555 "${LN_PATH}"

# create startup.sh
cat << EOF > startup.sh
#!/app/${GUIX_BASH_STATIC}/bin/bash
/app/${LN_PATH} -s /app/gnu /gnu
export PATH="/${GUIX_PROFILE}/bin"
mkdir -p /etc/ssl
# Qt expects certs to be here, see: qtbase/src/network/ssl/qsslsocket.cpp
ln -s /${GUIX_PROFILE}/etc/ssl/certs /etc/ssl/certs
mkdir -p /run/current-system/locale/${GLIBC_VERSION}
ln -s /${GUIX_PROFILE}/lib/locale/${GLIBC_VERSION}/en_US.UTF-8 /run/current-system/locale/${GLIBC_VERSION}
feather
EOF

chmod 555 startup.sh