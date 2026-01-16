FROM golang:1.25-alpine@sha256:e6898559d553d81b245eb8eadafcb3ca38ef320a9e26674df59d4f07a4fd0b07 AS builder

RUN apk add --no-cache git

WORKDIR /build

RUN git clone https://github.com/google/go-jsonnet.git .

# Build all binaries with optimisations for minimal size:
# - CGO_ENABLED=0: Disable CGO for static binaries (no external C dependencies)
# - GOOS=linux: Target Linux platform
# - -ldflags="-s -w": Strip debug symbols (-s) and DWARF tables (-w) to reduce binary size
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet ./cmd/jsonnet
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnetfmt ./cmd/jsonnetfmt
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet-lint ./cmd/jsonnet-lint
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o jsonnet-deps ./cmd/jsonnet-deps

FROM gcr.io/distroless/static-debian12@sha256:4b2a093ef4649bccd586625090a3c668b254cfe180dee54f4c94f3e9bd7e381e

COPY --from=builder /build/jsonnet* /usr/local/bin/

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/jsonnet"]
CMD ["--help"]
