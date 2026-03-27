# AGENTS instructions

## Development

- Build images: `docker build -t <image-name> ./images/<image-name>/`
- Test images: `docker run --rm <image-name> --help`
- Run validation: `make test` (markdownlint, zizmor, editorconfig)
- Always run `make test` after changes and before merging
- Update documentation for any Docker image changes

## Adding a new image

- Create `images/<name>/Dockerfile`
- Create `images/<name>/build.yaml` with four fields:
  `upstream` (git URL), `strategy` (e.g. `latest-tag`),
  `context` (build context path), `dockerfile` (Dockerfile path)
- The build workflow detects new directories automatically

## Registry

- Images are published to `ghcr.io/siutsin/images/<name>`
- GHCR package names are repo-scoped: `images/<name>`

## CI workflows

| Workflow                      | Trigger                  | Purpose                         |
|-------------------------------|--------------------------|---------------------------------|
| `build-images.yaml`           | push, schedule, dispatch | Build and publish Docker images |
| `delete-untagged-images.yaml` | schedule, dispatch       | Clean old GHCR versions         |
| `test.yaml`                   | push, PR                 | Run linters and validation      |
| `zizmor.yaml`                 | push, PR                 | Audit GitHub Actions workflows  |

## Git workflow

- Create branches: `git checkout -b feature/<description>`
- Commit scope format: `type(scope): [<image-name>] description`
- Scopes: ci, docker, docs, etc.

## Pull requests

- Title format: `type(scope): [<image-name>] <description>`
- Merge only through PRs after review
