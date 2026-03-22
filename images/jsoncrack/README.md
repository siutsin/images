# jsoncrack Docker Image

Docker image for [JSON Crack](https://github.com/AykutSarac/jsoncrack.com) – a data visualisation tool for JSON, YAML, XML, CSV, and more.

## Why

This image is built periodically from the upstream repository to provide an up-to-date containerised version served via nginx. It uses a custom Dockerfile that patches `next/font/google` imports to avoid fetching fonts at build time, which fails under QEMU emulation for multi-platform builds.

## License

Apache-2.0 (jsoncrack.com) – Compatible with this project's MIT licence

## Usage

```bash
docker run --rm -p 8080:8080 ghcr.io/siutsin/images/jsoncrack
```
