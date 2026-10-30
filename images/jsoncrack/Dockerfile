# The deps and builder stages run on the build platform because only the
# static export ships in the final image.
# hadolint ignore=DL3029
FROM --platform=$BUILDPLATFORM node:26-alpine@sha256:c6ad9e9c1d80f6eb607c26b4b0a132ff7a2344fad1c78ea3baa2a7d4c8de6d94 AS deps
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY apps/www/package.json ./apps/www/package.json
COPY apps/vscode/package.json ./apps/vscode/package.json
COPY packages/jsoncrack-react/package.json ./packages/jsoncrack-react/package.json
RUN corepack enable pnpm && pnpm install --frozen-lockfile

# hadolint ignore=DL3029
FROM --platform=$BUILDPLATFORM node:26-alpine@sha256:c6ad9e9c1d80f6eb607c26b4b0a132ff7a2344fad1c78ea3baa2a7d4c8de6d94 AS builder
WORKDIR /app
COPY --from=deps /app /app
COPY . .
RUN corepack enable pnpm && pnpm run build:www

FROM nginxinc/nginx-unprivileged:stable-alpine@sha256:f5116ed4606f3eb015dd4a8e28cb9b351476dc0ad4bc6e9f93b19cec130cdf03 AS production

USER 0

# Keep the CA packages unpinned because Alpine package revisions rotate
# between scheduled rebuilds. The upgrade moves the bundle to the fixed
# 20261020 release, which drops the compromised emSign roots.
# hadolint ignore=DL3018
RUN apk add --no-cache --upgrade ca-certificates ca-certificates-bundle

USER 101

WORKDIR /app
COPY --from=builder /app/apps/www/out /app
COPY apps/www/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
