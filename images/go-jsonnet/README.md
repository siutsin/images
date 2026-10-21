# go-jsonnet Docker Image

Docker image for [go-jsonnet](https://github.com/google/go-jsonnet) - Go implementation of Jsonnet.

## Why

The official go-jsonnet repository doesn't provide Docker images, and bitnami/jsonnet is no longer available, so this provides a containerised version.

The builder uses Go 1.27.3, which blocks the compromised eMudhra intermediate CA certificates (CVE-2026-111943).

## License

Apache-2.0 (go-jsonnet) - Compatible with this project's MIT licence

## Usage

```bash
docker run --rm -v $(pwd):/workspace ghcr.io/siutsin/images/go-jsonnet example.jsonnet
```
