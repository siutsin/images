FROM golang:1.25-alpine@sha256:660f0b83cf50091e3777e4730ccc0e63e83fea2c420c872af5c60cb357dcafb2 AS builder

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

FROM gcr.io/distroless/static-debian12@sha256:cd64bec9cec257044ce3a8dd3620cf83b387920100332f2b041f19c4d2febf93

COPY --from=builder /build/jsonnet* /usr/local/bin/

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/jsonnet"]
CMD ["--help"]
