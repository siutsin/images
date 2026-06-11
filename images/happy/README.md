# happy Docker Image

Docker image for the self-hosted [Happy server](https://github.com/slopus/happy)
published as the `happy-server-self-host` npm package.

This image bakes the npm package into the container at build time, uses a
distroless Node.js runtime, runs as UID/GID `1000`, stores PGlite data under
`/data`, and defaults to running database migrations before starting
`happy-server serve`.

## Upstream

- Package: `happy-server-self-host`
- Source: <https://github.com/slopus/happy>
- Strategy: latest npm package version
- Licence: MIT

## Usage

```bash
docker run --rm -p 3005:3005 \
  -e HANDY_MASTER_SECRET=<your-secret> \
  -e PUBLIC_URL=http://localhost:3005 \
  -v happy-data:/data \
  ghcr.io/siutsin/images/happy:latest
```

To run `happy-server` commands directly:

```bash
docker run --rm ghcr.io/siutsin/images/happy:latest --help
docker run --rm -v happy-data:/data ghcr.io/siutsin/images/happy:latest migrate
```

## Configuration

| Variable              | Default                 | Description                         |
|-----------------------|-------------------------|-------------------------------------|
| `HANDY_MASTER_SECRET` |                         | Required by `happy-server serve`    |
| `PUBLIC_URL`          | `http://localhost:3005` | Public URL used in generated links  |
| `PORT`                | `3005`                  | HTTP port inside the container      |
| `DATA_DIR`            | `/data`                 | Base persistent data directory      |
| `PGLITE_DIR`          | `/data/pglite`          | PGlite database directory           |
