FROM golang:1.26-alpine@sha256:0178a641fbb4858c5f1b48e34bdaabe0350a330a1b1149aabd498d0699ff5fb2 AS builder

ARG UPSTREAM_REF=HEAD

# Keep git unpinned because the base image is digest-pinned, while Alpine
# package revisions can rotate between scheduled rebuilds.
# hadolint ignore=DL3018
RUN apk add --no-cache git

WORKDIR /build

RUN if [ "$UPSTREAM_REF" != "HEAD" ]; then \
      git clone --depth 1 --branch "$UPSTREAM_REF" https://github.com/google/go-jsonnet.git .; \
    else \
      git clone --depth 1 https://github.com/google/go-jsonnet.git .; \
    fi

# Build all binaries with optimisations for minimal size:
# - CGO_ENABLED=0: Disable CGO for static binaries (no external C dependencies)
# - GOOS=linux: Target Linux platform
# - -ldflags="-s -w": Strip debug symbols (-s) and DWARF tables (-w) to reduce binary size
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet ./cmd/jsonnet \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnetfmt ./cmd/jsonnetfmt \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet-lint ./cmd/jsonnet-lint \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet-deps ./cmd/jsonnet-deps

FROM gcr.io/distroless/static-debian12@sha256:61b7ccecebc7c474a531717de80a94709d20547cdcdaf740c25876f2a8e38b44

COPY --from=builder /build/jsonnet* /usr/local/bin/

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/jsonnet"]
CMD ["--help"]
