FROM ubuntu:20.04 as c-builder

ARG OPENSSL_VERSION=1.1.1t
ARG TPM2_TSS_VERSION=2.3.3

ENV DEBIAN_FRONTEND=noninteractive
ENV MUSL_HOME=/opt/musl

RUN apt-get update && apt-get install -yq \
  build-essential \
  curl \
  linux-libc-dev \
  musl-dev \
  musl-tools \
  pkg-config

ENV PKG_CONFIG_PATH="${MUSL_HOME}/lib/pkgconfig"

RUN mkdir /build
COPY ./scripts/*.sh /build/
WORKDIR /build
RUN ./openssl.sh
RUN ./tpm2-tss.sh

FROM rust:1.68.2-slim

ENV MUSL_HOME=/opt/musl
COPY --from=c-builder $MUSL_HOME $MUSL_HOME

RUN rustup target add x86_64-unknown-linux-musl
ENV PKG_CONFIG_PATH=$MUSL_HOME/lib/pkgconfig \
  PKG_CONFIG_ALLOW_CROSS=true \
  PKG_CONFIG_ALL_STATIC=true

RUN apt-get update && apt-get install -yq \
  curl \
  musl-tools \
  pkg-config

RUN mkdir -p /src/.cargo
RUN curl -fL https://github.com/mkulke/az-snp-vtpm/tarball/main \
  | tar xz --strip-components 1 -C /src
WORKDIR /src
RUN cargo build \
  --release \
  --bin mgns \
  --no-default-features \
  --target x86_64-unknown-linux-musl \
  --features attest
