FROM ubuntu:20.04

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
  pkg-config \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /build
COPY ./scripts/*.sh /build/
WORKDIR /build
RUN ./openssl.sh
RUN ./tpm2-tss.sh

RUN curl https://sh.rustup.rs -sSf \
  | sh -s -- -y --default-toolchain stable --profile minimal --no-modify-path
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add x86_64-unknown-linux-musl

ENV PKG_CONFIG_PATH=$MUSL_HOME/lib/pkgconfig \
  PKG_CONFIG_ALLOW_CROSS=true \
  PKG_CONFIG_ALL_STATIC=true
