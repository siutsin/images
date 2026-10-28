FROM golang:1.27.3-alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS builder

# Matches the version pin in build.yaml, so a manual build produces the
# same source the workflow builds.
ARG UPSTREAM_REF=2a30fdce45cd8abe4cf8d705b656824fd9dd3a0f

# Keep git unpinned because the base image is digest-pinned, while Alpine
# package revisions can rotate between scheduled rebuilds.
# hadolint ignore=DL3018
RUN apk add --no-cache git

WORKDIR /build

RUN git clone https://github.com/squat/generic-device-plugin.git . \
    && git checkout "$UPSTREAM_REF"

# Upstream's lockfile pins google.golang.org/grpc v1.53.0,
# golang.org/x/net v0.7.0 and golang.org/x/text v0.7.0, which carry
# critical and high-severity flaws, and its image was built with
# Go 1.20.2. Bump only those three modules, to the smallest versions
# that fix the findings (x/text v0.42.0 is the version x/net v0.60.0
# requires). The Go 1.27.3 toolchain clears the standard library
# findings. No source changes and no other direct dependency changes;
# the bumps pull their transitive requirements up with them and raise
# the go directive to 1.26.0.
RUN go get google.golang.org/grpc@v1.84.0 golang.org/x/net@v0.60.0 golang.org/x/text@v0.42.0 \
    && go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath \
      -ldflags="-s -w -X github.com/squat/generic-device-plugin/version.Version=$UPSTREAM_REF" \
      -o /out/generic-device-plugin .

FROM gcr.io/distroless/static-debian12@sha256:d75cdd72874d4790092fcb1b058493ecf6bb5bf2b2b897045b00ff01d91843f2

LABEL org.opencontainers.image.source="https://github.com/squat/generic-device-plugin" \
      org.opencontainers.image.description="Generic device plugin for Kubernetes"

COPY --from=builder /out/generic-device-plugin /generic-device-plugin

# The plugin writes sockets into the kubelet device-plugins directory,
# which is root-owned, so it runs as root, as the upstream image does.
ENTRYPOINT ["/generic-device-plugin"]
