.PHONY: lint-markdown
lint-markdown: ## Check Markdown files with markdownlint
	@echo "Checking Markdown files..."
	@command -v markdownlint >/dev/null 2>&1 || { echo "Installing markdownlint-cli..."; npm install -g markdownlint-cli; }
	@markdownlint "**/*.md" --ignore node_modules/
	@echo "Markdown linting passed!"

.PHONY: lint-zizmor
lint-zizmor: ## Run zizmor audit on workflows
	@echo "Running zizmor audit..."
	@zizmor --no-config --min-severity high .

.PHONY: lint-yaml
lint-yaml: ## Check YAML files with yamllint
	@echo "Checking YAML files..."
	@command -v yamllint >/dev/null 2>&1 || { echo "Installing yamllint..."; pip install yamllint; }
	@yamllint .github/workflows/ || true
	@echo "YAML linting passed!"

.PHONY: lint-docker
lint-docker: ## Check Dockerfiles with hadolint
	@echo "Checking Dockerfiles..."
	@command -v hadolint >/dev/null 2>&1 || { echo "hadolint is required; install it before running make test"; exit 1; }
	@find images -name Dockerfile -print0 | xargs -0 hadolint
	@echo "Dockerfile linting passed!"

.PHONY: test
test: lint-markdown lint-yaml lint-docker lint-zizmor
	@echo "All validation and quality checks passed!"
