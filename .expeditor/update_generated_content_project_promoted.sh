#!/bin/bash

set -eoux pipefail

###
# Manage Habitat generated pages
###

# Habitat has two generated files (habitat_cli.md and service_templates.md) that
# are made during the release pipeline.
# Those two pages are generated and then pushed up to
# https://packages.chef.io/files/stable/habitat/latest/generated-documentation.tar.gz

# This script fetches these files and adds them to a PR against the main branch
# so that the documentation site is kept up to date with the latest Habitat release.

# See:
# - https://github.com/habitat-sh/habitat/pull/7993
# - https://github.com/chef/chef-web-docs/blob/main/content/habitat/habitat_cli.md
# - https://github.com/chef/chef-web-docs/blob/main/content/habitat/service_templates.md
# - https://github.com/habitat-sh/habitat/blob/main/.expeditor/scripts/release_habitat/update_documentation.sh
# - https://github.com/habitat-sh/habitat/blob/main/.expeditor/scripts/release_habitat/generate-cli-docs.js
# - https://github.com/habitat-sh/habitat/blob/main/.expeditor/scripts/release_habitat/generate-template-reference.js
# - https://github.com/habitat-sh/habitat/blob/main/.expeditor/scripts/finish_release/update_api_docs.sh

# Define variables

product_key="habitat"
manifest="https://packages.chef.io/files/${EXPEDITOR_TARGET_CHANNEL}/habitat/latest/manifest.json"
git_sha="$(curl -s $manifest | jq -r -c ".sha")"

# Checkout a new branch

branch="expeditor/update_docs_${product_key}_${git_sha}"
git checkout -b "$branch"

# Download and extract the generated documentation files

curl --silent --output generated-documentation.tar.gz https://packages.chef.io/files/${EXPEDITOR_TARGET_CHANNEL}/habitat/latest/generated-documentation.tar.gz
tar xvzf generated-documentation.tar.gz --strip-components 1 -C content/reference
rm generated-documentation.tar.gz

# Submit a pull request

git add .

# Give a friendly message for the commit and make sure it's noted for any future
# audit of our codebase that no DCO sign-off is needed for this sort of PR since
# it contains no intellectual property

dco_safe_git_commit "Bump $product_key docs content to latest $EXPEDITOR_TARGET_CHANNEL release ($git_sha)."

open_pull_request

# Get back to main and cleanup the leftovers - any changed files left over at
# the end of this script will get committed to main.

git checkout -
git branch -D "$branch"
