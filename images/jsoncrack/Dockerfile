FROM node:lts-alpine AS base

# Stage 1: Install dependencies
FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm install --frozen-lockfile

# Stage 2: Build the application
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Replace next/font/google imports with local font stubs to avoid fetching
# fonts from Google at build time. The QEMU-emulated arm64 build environment
# cannot reliably reach external hosts, causing the build to hang or fail.
RUN sed -i \
  's|import { Inter } from "next/font/google";|const Inter = () => ({ style: { fontFamily: "Inter, sans-serif" } });|' \
  src/layout/PageLayout/index.tsx && \
  sed -i \
  's|import { Oxygen } from "next/font/google";|const Oxygen = () => ({ style: { fontFamily: "Oxygen, sans-serif" } });|' \
  src/layout/Landing/HeroSection.tsx

RUN corepack enable pnpm && pnpm run build

# Stage 3: Production image
FROM nginxinc/nginx-unprivileged:stable AS production
WORKDIR /app
COPY --from=builder /app/out /app
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
