
bundle:
	npm install

clean_all:
	rm -rf node_modules
	rm -rf resources/
	rm -rf public/
	hugo mod clean

serve: bundle
	hugo server --buildDrafts --noHTTPCache --buildFuture

static: bundle
	hugo --buildDrafts --buildFuture --cleanDestinationDir

metrics: bundle
	hugo --gc --minify --enableGitInfo --templateMetrics --templateMetricsHints

nodrafts: bundle
	hugo server --noHTTPCache --buildFuture

production: bundle
	hugo server --noHTTPCache --environment production

# Override the theme in the _vendor directory and build using locally sourced theme defined in hugo.work file.
# See https://gohugo.io/hugo-modules/use-modules/#module-workspaces
test_theme: bundle
	HUGO_MODULE_WORKSPACE=hugo.work hugo server --buildDrafts --noHTTPCache --buildFuture --ignoreVendorPaths "github.com/chef/chef-docs-theme"

test_theme_static: bundle
	HUGO_MODULE_WORKSPACE=hugo.work hugo --buildDrafts --buildFuture --ignoreVendorPaths "github.com/chef/chef-docs-theme" --cleanDestinationDir

test_branch_deploy: bundle
	hugo server --noHTTPCache --baseURL http://localhost:1313/habitat/version/ -e branch-deploy

serve_ignore_vendor: bundle
	hugo server --buildDrafts --noHTTPCache --buildFuture --ignoreVendorPaths github.com/**

update_theme:
	hugo mod get -u github.com/chef/chef-docs-theme
	rm -rf _vendor node_modules
	hugo mod tidy
	hugo mod vendor
	hugo mod npm pack
	npm install

## See:
## - https://cspell.org/docs/getting-started/
## - https://cspell.org/configuration/
## - and cspell.yaml file.
spellcheck:
	cspell --no-progress "**/*.{md, html, js, yml, yaml, toml, json}"

##
# markdownlint-cli
# See: https://github.com/igorshubovych/markdownlint-cli
##

markdownlint:
	markdownlint "**/*.md" --ignore "node_modules/**" --ignore "public/**" --ignore "_vendor/**" --ignore "archetypes/**" --ignore "resources/**" --ignore "tools/**"

##
# Vale CLI
# See: https://vale.sh/docs
##

vale:
	vale --glob='!{**/habitat_cli.md,**/service_templates.md,node_modules/**/*,archetypes/**/*,**/README.md,tools/**/*}' *

vale_error:
	vale --filter=error.expr --glob='!{**/habitat_cli.md,**/service_templates.md,node_modules/**/*,archetypes/**/*,**/README.md,tools/**/*}' *

##
# Hugo Audit
# See: https://gohugo.io/troubleshooting/audit
##

audit:
	HUGO_MINIFY_TDEWOLFF_HTML_KEEPCOMMENTS=true HUGO_ENABLEMISSINGTRANSLATIONPLACEHOLDERS=true hugo --cleanDestinationDir && grep -inorE "<\!-- raw HTML omitted -->|ZgotmplZ|\[i18n\]|\(<nil>\)|(&lt;nil&gt;)|hahahugo" public/

lint: spellcheck markdownlint

lint_all: audit lint
