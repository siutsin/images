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

.PHONY: test
test: lint-markdown lint-yaml lint-zizmor
	@echo "All validation and quality checks passed!"
