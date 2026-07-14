FROM node:24-trixie-slim@sha256:ae91dcc111a68c9d2d81ff2a17bda61be126426176fde6fe7d08ab13b7f50573 AS package

ARG UPSTREAM_REF=latest

ENV NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_UPDATE_NOTIFIER=false

# The builder uses Debian 13, matching the distroless runtime's OpenSSL ABI.
# Keep the package unpinned because the base image is digest-pinned, while
# Debian package revisions can rotate between scheduled rebuilds.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global --omit=dev "happy-server-self-host@${UPSTREAM_REF}" \
    && npm cache clean --force
WORKDIR /usr/local/lib/node_modules/happy-server-self-host
RUN ./node_modules/.bin/prisma generate --schema=prisma/schema.prisma --generator client \
    && mkdir -p /tmp/happy-data

FROM gcr.io/distroless/nodejs24-debian13:nonroot@sha256:70a2c12a0d76018b54d7bd01c5e3677632eeed9f890ba318d6db55fc54cf3baa

LABEL org.opencontainers.image.source="https://github.com/slopus/happy" \
      org.opencontainers.image.description="Self-hosted Happy server"

ENV NODE_ENV=production \
    DB_PROVIDER=pglite \
    DATA_DIR=/data \
    PGLITE_DIR=/data/pglite \
    HOST=0.0.0.0 \
    PORT=3005

COPY --chown=1000:1000 --from=package /usr/local/lib/node_modules/happy-server-self-host /usr/local/lib/node_modules/happy-server-self-host
COPY --chown=1000:1000 --from=package /tmp/happy-data /data
COPY --chown=1000:1000 docker-entrypoint.cjs /usr/local/bin/docker-entrypoint.cjs

USER 1000:1000
WORKDIR /data

VOLUME ["/data"]
EXPOSE 3005

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD ["/nodejs/bin/node", "-e", "fetch('http://127.0.0.1:' + (process.env.PORT || '3005') + '/health').then((res) => process.exit(res.ok ? 0 : 1)).catch(() => process.exit(1))"]

ENTRYPOINT ["/nodejs/bin/node", "/usr/local/bin/docker-entrypoint.cjs"]
CMD ["serve"]
