# AGENTS instructions

## Scope

- When working in any subfolder, read that subfolder's `AGENTS.md` first if it
  exists.
- Do not revert unrelated local changes.

## Docker images

- Images live under `images/<name>/`.
- Prefer baking application dependencies into the image at build time instead
  of installing packages during container startup or Kubernetes init
  containers.
- Prefer minimal final runtime images, such as distroless, when the
  application can run without a shell, package manager, or debugging tools.
- Update image documentation when Docker image behavior changes.

Each image must include:

- a local `Dockerfile`, unless `build.yaml` intentionally points at an
  upstream Dockerfile
- `build.yaml` with:
  - `upstream`: git URL or npm package name
  - `strategy`: `latest-tag` for latest non-prerelease Git tag, or
    `npm-latest` for latest npm package version
  - `context`: build context path
  - `dockerfile`: Dockerfile path

## Commands

- Build local-context images:
  `docker build -t <image-name> -f images/<image-name>/Dockerfile images/<image-name>/`
- Smoke test with the image-specific command in its README. For CLI-style
  images this is usually `--help`; for services, check the HTTP endpoint.
- Validate: `make test`

Run `make test` after changes. If local tooling needs a path override, state
that in the final response.

## Quality

- Any lint ignore or suppression must include an inline explanation for why it
  is necessary.
- Registry names are `ghcr.io/siutsin/images/<name>`.
