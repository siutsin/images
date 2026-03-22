# jsoncrack Docker Image

Docker image for [JSON Crack](https://github.com/AykutSarac/jsoncrack.com) – a data visualisation tool for JSON, YAML, XML, CSV, and more.

## Why

This image is built periodically from the upstream repository to provide an up-to-date containerised version served via nginx. It uses the upstream Dockerfile at the repository root directly, so builds may break if the upstream layout changes.

## License

Apache-2.0 (jsoncrack.com) – Compatible with this project's MIT licence

## Usage

```bash
docker run --rm -p 8080:8080 ghcr.io/siutsin/images/jsoncrack
```
