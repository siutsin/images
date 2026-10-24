FROM golang:1.27.3-alpine@sha256:b8c9b82affbbb82a020bbcf998dad2ba9516944ac7e883524642a481a9505e9c AS builder

# Matches the version pin in build.yaml, so a manual build produces the
# same source the workflow builds.
ARG UPSTREAM_REF=1.2.37

# Keep git unpinned because the base image is digest-pinned, while Alpine
# package revisions can rotate between scheduled rebuilds.
# hadolint ignore=DL3018
RUN apk add --no-cache git

WORKDIR /build

RUN git clone --depth 1 --branch "$UPSTREAM_REF" https://github.com/Threadfin/Threadfin.git .

# Upstream's lockfile pins golang.org/x/net v0.32.0 and golang.org/x/text
# v0.21.0, which carry known high-severity flaws. Bump only those two
# modules, to the smallest versions that fix them (x/text v0.42.0 is the
# version x/net v0.60.0 requires). No other direct dependency changes;
# x/net pulls x/sys up with it and raises the go directive to 1.26.0.
RUN go get golang.org/x/net@v0.60.0 golang.org/x/text@v0.42.0 \
    && go mod tidy

# -mod=mod ignores upstream's vendor directory, as upstream's own build does.
RUN CGO_ENABLED=0 GOOS=linux go build -mod=mod -ldflags="-s -w" -trimpath -o /out/threadfin threadfin.go

# Threadfin locates ffmpeg by running "which"; the distroless runtime has
# none, so build the minimal stand-in from the which/ sources.
WORKDIR /whichsrc
COPY which/ ./
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -trimpath -o /out/which . \
    && mkdir -p /out/config \
    && touch /out/dockerenv

FROM mwader/static-ffmpeg:9.0.2-1@sha256:f5d100184884eb3e82b0eb14bb5ebf98da99826ac824989720297fb9ef21c822 AS ffmpeg

FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab

LABEL org.opencontainers.image.source="https://github.com/Threadfin/Threadfin" \
      org.opencontainers.image.description="Threadfin M3U proxy for Jellyfin Live TV"

COPY --from=builder /out/threadfin /usr/local/bin/threadfin
COPY --from=builder /out/which /usr/local/bin/which
COPY --from=ffmpeg /ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg /ffprobe /usr/local/bin/ffprobe
COPY --from=builder --chown=65532:65532 /out/config /config

# containerd does not create /.dockerenv. Threadfin checks for it when
# seeding the default for its self-update setting (off in a container),
# so the image ships the marker itself. A saved settings file could turn
# the setting back on, but the binary is root-owned and the container
# user is nonroot, so a self-update cannot replace it either way.
COPY --from=builder /out/dockerenv /.dockerenv

VOLUME ["/config"]
EXPOSE 34400

ENTRYPOINT ["/usr/local/bin/threadfin"]
CMD ["-config", "/config", "-port", "34400", "-bind", "0.0.0.0"]
