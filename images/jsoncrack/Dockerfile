FROM node:24-alpine AS deps
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY apps/www/package.json ./apps/www/package.json
COPY apps/vscode/package.json ./apps/vscode/package.json
COPY packages/jsoncrack-react/package.json ./packages/jsoncrack-react/package.json
RUN corepack enable pnpm && pnpm install --frozen-lockfile

FROM node:24-alpine AS builder
WORKDIR /app
COPY --from=deps /app /app
COPY . .
RUN corepack enable pnpm && pnpm run build:www

FROM nginxinc/nginx-unprivileged:stable AS production
WORKDIR /app
COPY --from=builder /app/apps/www/out /app
COPY apps/www/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
