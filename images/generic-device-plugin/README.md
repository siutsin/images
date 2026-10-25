# Generic Device Plugin Docker Image

Docker image for the [generic device
plugin](https://github.com/squat/generic-device-plugin), a Kubernetes
device plugin that exposes host devices (such as `/dev/dri` render
nodes) to pods. Published as
`ghcr.io/siutsin/images/generic-device-plugin`.

## Why

Upstream built the image for this commit in 2023 with Go 1.20.2 and
does not rebuild old commits, so no image of this source with the
fixes exists. A Trivy scan on 2026-10-25 found 5 critical
and 50 high-severity flaws in it, in the Go standard library, gRPC,
`golang.org/x/net` and `golang.org/x/text`, every one with a
published fix. Rather than
wait for upstream to rebuild, this image rebuilds the same upstream
commit from source:

- Built with Go 1.27.3, which clears the standard library flaws.
- `google.golang.org/grpc`, `golang.org/x/net` and
  `golang.org/x/text` are bumped to the smallest fixed versions
  (v1.84.0, v0.60.0 and v0.42.0). The bumps are explicit in the
  Dockerfile. No upstream source changes and no other direct
  dependency changes; the bumps pull their transitive requirements
  up with them and raise the go directive to 1.26.0.
- The version is pinned in `build.yaml` to the exact upstream commit
  the cluster runs, because upstream's newest tag is older than the
  deployed source.

## What is in the image

- The single static plugin binary at `/generic-device-plugin`, on a
  distroless static base. No shell, no package manager.
- The entrypoint is the plugin binary, as in the upstream image.
- The plugin runs as root: it writes sockets into the kubelet
  device-plugins directory, which is root-owned. Upstream's image
  runs as root for the same reason.

## Usage

The plugin runs as a DaemonSet on GPU nodes. It takes the device
definitions as arguments:

```bash
docker run --rm \
  ghcr.io/siutsin/images/generic-device-plugin:2a30fdce45cd8abe4cf8d705b656824fd9dd3a0f --help
```

## Licence

Apache-2.0 (upstream licence).
