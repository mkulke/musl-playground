# Musl Playground

The Dockerfile illustrates how to  utilize Musl to build statically linked Rust binaries. This can be tricky w/ transitive c dependencies (e.g. app => tpm lib => crypto lib).

## Build libraries and application

```bash
docker build -t builder .
```

## Retrieve App

Verify it's statically linked:

```bash
docker run -it builder ldd target/x86_64-unknown-linux-musl/release/mgns
	statically linked
```

Copy binary:

```bash
mkdir output
docker run -it -v $PWD/output:/output builder cp target/x86_64-unknown-linux-musl/release/mgns /output
```
