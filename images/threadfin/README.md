# Threadfin Docker Image

Docker image for [Threadfin](https://github.com/Threadfin/Threadfin) - an
M3U proxy for Jellyfin Live TV, published as
`ghcr.io/siutsin/images/threadfin`.

## Why

Upstream's published image is stale: version 1.2.37 was built on
2025-09-11 with Go 1.23.12 and a dated Ubuntu package snapshot, and a
Trivy scan on 2026-10-24 found 1 critical and 40 high-severity flaws in
it, every one with a published fix. Rather than wait for upstream to
rebuild, this image rebuilds the same upstream version from source:

- Built with Go 1.27.3, which clears the standard library flaws.
- `golang.org/x/net` and `golang.org/x/text` are bumped to the smallest
  fixed versions (v0.60.0 and v0.42.0, the latter being the version
  x/net v0.60.0 requires). No other direct dependency changes; the
  bumps are explicit in the Dockerfile.
- The version is pinned in `build.yaml`. Upstream's tag list defeats the
  usual latest-tag resolution, and 1.2.37 is the newest release upstream
  publishes an image for.

## What is in the image

- The Threadfin binary, on a distroless static base, running as the
  `nonroot` user (UID 65532). No shell, no package manager.
- Static `ffmpeg` and `ffprobe` builds (from
  [mwader/static-ffmpeg](https://github.com/mwader/static-ffmpeg)), for
  Threadfin's optional ffmpeg buffer and stream probing.
- A minimal `which` program (sources in `which/`). Threadfin locates
  ffmpeg by running `which ffmpeg`; distroless ships none.
- An empty `/.dockerenv` marker. containerd does not create that file,
  and Threadfin checks for it when seeding the default for its
  self-update setting, off in a container. A saved settings file could
  turn the setting back on, but the binary is root-owned and the
  container user is nonroot, so a self-update cannot replace it either
  way. Updates arrive by rebuilding this image.
- Configuration lives in `/config` (declared as a volume). Streams and
  temporary files use `/tmp`, so the root filesystem can stay read-only
  with `/config` and `/tmp` mounted writable.

VLC, which upstream bundles as an alternative buffer, is deliberately
left out: the ffmpeg buffer covers the same need with far less surface.

## Usage

```bash
docker run --rm -p 34400:34400 -v threadfin-config:/config \
  ghcr.io/siutsin/images/threadfin:1.2.37
```

Then open `http://localhost:34400` for setup.

## Licence

MIT (Threadfin). The bundled ffmpeg builds are GPL-licensed; see the
FFmpeg project for details.
