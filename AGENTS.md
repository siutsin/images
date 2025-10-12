# AGENTS instructions

## Development

- Build images: `docker build -t <image-name> ./images/<image-name>/`
- Test images: `docker run --rm <image-name> --help`
- Run validation: `make test` (markdownlint, zizmor, editorconfig)
- Always run `make test` after changes and before merging

## Code and documentation standards

- Use British English throughout ("colour" not "color")
- Use British datetime format (DD/MM/YYYY or DD Month YYYY)
- Apply British English to: code comments, function names, variables, documentation, commits, PRs
- No emojis in any text (code, documentation, commits, or PRs)
- Update documentation for any Docker image changes

## Git workflow

- **NEVER push to master** - use feature branches only
- Create branches: `git checkout -b feature/<description>`
- Rebase before commits: `git fetch origin && git rebase origin/master`
- Use conventional commits: `type(scope): [<image-name>] description` (scope: ci, docker, docs, etc.)

## Pull requests

- Title format: `type(scope): [<image-name>] <description>` (conventional commits)
- Create PRs: `gh pr create --title "type(scope): [<image-name>] <description>" --body "<description>" --web`
- Merge only through PRs after review
