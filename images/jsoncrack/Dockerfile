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

FROM nginxinc/nginx-unprivileged:stable@sha256:d715f7a85cdfea820fec743ea5aee8a22f91e00ff310ad6275d2638112d8cf8d AS production
WORKDIR /app
COPY --from=builder /app/apps/www/out /app
COPY apps/www/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
