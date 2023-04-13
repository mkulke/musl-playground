#!/bin/bash

set -eou pipefail

MUSL_INCLUDE="${MUSL_HOME}/include"
mkdir -p "$MUSL_INCLUDE"
ln -s /usr/include/linux "${MUSL_INCLUDE}/linux"

function finish {
  rm -rf "${MUSL_INCLUDE}/linux"
}
trap finish EXIT

curl -fLO "https://github.com/tpm2-software/tpm2-tss/releases/download/${TPM2_TSS_VERSION}/tpm2-tss-${TPM2_TSS_VERSION}.tar.gz"
tar xzf "tpm2-tss-${TPM2_TSS_VERSION}.tar.gz"
cd "tpm2-tss-${TPM2_TSS_VERSION}"

CC=musl-gcc \
CPPFLAGS=-I$MUSL_HOME/include \
PKG_CONFIG_PATH=$MUSL_HOME/lib/pkgconfig \
./configure --prefix="$MUSL_HOME" --disable-doxygen-doc --enable-shared=no
make
make install
