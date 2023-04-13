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

curl -fLO "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
tar xzf "openssl-${OPENSSL_VERSION}.tar.gz"
cd "openssl-${OPENSSL_VERSION}"

CC=musl-gcc ./Configure no-shared no-zlib -fPIC --prefix="$MUSL_HOME" linux-x86_64
make depend
C_INCLUDE_PATH="$MUSL_INCLUDE" make
make install
