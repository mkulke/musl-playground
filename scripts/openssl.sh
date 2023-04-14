#!/bin/bash

set -eou pipefail

MUSL_INCLUDE="${MUSL_HOME}/include"
mkdir -p "$MUSL_INCLUDE"
ln -s /usr/include/linux "${MUSL_INCLUDE}/linux"
ln -s /usr/include/x86_64-linux-gnu/asm "${MUSL_INCLUDE}/asm"
ln -s /usr/include/asm-generic "${MUSL_INCLUDE}/asm-generic"

function finish {
  rm -rf "${MUSL_INCLUDE}/"{asm,asm-generic,linux}
}
trap finish EXIT

curl -fL "https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1t/openssl-${OPENSSL_VERSION}.tar.gz" | tar xz
cd "openssl-${OPENSSL_VERSION}"

CC=musl-gcc ./Configure \
  no-tests \
  no-shared \
  no-zlib \
  --prefix="$MUSL_HOME" linux-x86_64
make depend
C_INCLUDE_PATH="$MUSL_INCLUDE" make -j$(nproc)
make install_sw
