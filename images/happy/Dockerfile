FROM node:24-bookworm-slim@sha256:242549cd46785b480c832479a730f4f2a20865d61ea2e404fdb2a5c3d3b73ecf AS package

ARG UPSTREAM_REF=latest

ENV NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_UPDATE_NOTIFIER=false

# The builder needs the OpenSSL CLI/libraries so Prisma generates the query
# engine for the same OpenSSL ABI used by the distroless Node.js runtime.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global --omit=dev "happy-server-self-host@${UPSTREAM_REF}" \
    && npm cache clean --force
WORKDIR /usr/local/lib/node_modules/happy-server-self-host
RUN ./node_modules/.bin/prisma generate --schema=prisma/schema.prisma --generator client \
    && mkdir -p /tmp/happy-data

FROM gcr.io/distroless/nodejs24-debian13:nonroot@sha256:633e1463f02b25e50109325c59cfd373f404169085851b6cd2951bde1aca5623

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
