FROM node:24-alpine@sha256:ebfe2f90462722a7a4de65e91990e97fe0d401c70e0e762c5b53302f905ec1c1 AS deps
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY apps/www/package.json ./apps/www/package.json
COPY apps/vscode/package.json ./apps/vscode/package.json
COPY packages/jsoncrack-react/package.json ./packages/jsoncrack-react/package.json
RUN corepack enable pnpm && pnpm install --frozen-lockfile

FROM node:24-alpine@sha256:ebfe2f90462722a7a4de65e91990e97fe0d401c70e0e762c5b53302f905ec1c1 AS builder
WORKDIR /app
COPY --from=deps /app /app
COPY . .
RUN corepack enable pnpm && pnpm run build:www

FROM nginxinc/nginx-unprivileged:stable-alpine@sha256:f5116ed4606f3eb015dd4a8e28cb9b351476dc0ad4bc6e9f93b19cec130cdf03 AS production
WORKDIR /app
COPY --from=builder /app/apps/www/out /app
COPY apps/www/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
