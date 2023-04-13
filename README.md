# Musl Playground

The Dockerfile illustrate how we can utilize Musl to build statically linked Rust binaries. This can be tricky w/ transitive c dependencies (e.g. app => tpm lib => crypto lib).

## Build Libraries

```bash
docker build -t builder .
```

## Build App

```bash
docker run -it builder bash
curl -fL https://github.com/mkulke/az-snp-vtpm/tarball/main | tar xz
cd mkulke-az-snp-vtpm-48f37f8
cargo b --target x86_64-unknown-linux-musl
ldd target/x86_64-unknown-linux-musl/debug/snp-vtpm
	statically linked
```
