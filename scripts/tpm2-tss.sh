#!/bin/bash

set -eou pipefail

MUSL_INCLUDE="${MUSL_HOME}/include"
mkdir -p "$MUSL_INCLUDE"
ln -s /usr/include/linux "${MUSL_INCLUDE}/linux"

function finish {
  rm -rf "${MUSL_INCLUDE}/linux"
}
trap finish EXIT

curl -fL "https://github.com/tpm2-software/tpm2-tss/releases/download/${TPM2_TSS_VERSION}/tpm2-tss-${TPM2_TSS_VERSION}.tar.gz" | tar xz
cd "tpm2-tss-${TPM2_TSS_VERSION}"

CC=musl-gcc CPPFLAGS=-I$MUSL_HOME/include ./configure \
  --prefix="$MUSL_HOME" \
  --disable-doxygen-doc \
  --enable-shared=no
make -j$(nproc)
make install
