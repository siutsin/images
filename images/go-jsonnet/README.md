# go-jsonnet Docker Image

Docker image for [go-jsonnet](https://github.com/google/go-jsonnet) - Go implementation of Jsonnet.

## Why

The official go-jsonnet repository doesn't provide Docker images, and bitnami/jsonnet is no longer available, so this provides a containerised version.

## License

Apache-2.0 (go-jsonnet) - Compatible with this project's MIT license

## Usage

```bash
docker run --rm -v $(pwd):/workspace go-jsonnet jsonnet example.jsonnet
```
