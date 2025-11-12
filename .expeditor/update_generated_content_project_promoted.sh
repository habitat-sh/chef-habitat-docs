#!/bin/bash

set -eoux pipefail

###
# Manage Habitat generated documentation
###

# Habitat has two generated files (habitat_cli.md and service_templates.md) that
# are made during the release pipeline.
# Those two pages are generated and then pushed up to
# https://packages.chef.io/files/stable/habitat/latest/generated-documentation.tar.gz

# To add these files to this documentation, this script uses curl to pull down the
# generated-documentation.tar.gz file, and then extract and overwrite the existing pages in this repo.

# See:
# - https://github.com/habitat-sh/habitat/pull/7993
# - https://github.com/habitat-sh/chef-habitat-docs/blob/main/content/reference/habitat_cli.md
# - https://github.com/habitat-sh/chef-habitat-docs/blob/main/content/reference/service_templates.md

# Define variables

product_key="habitat"
manifest="https://packages.chef.io/files/${EXPEDITOR_TARGET_CHANNEL}/habitat/latest/manifest.json"
git_sha="$(curl -s $manifest | jq -r -c ".sha")"

# Checkout a new branch

branch="expeditor/update_docs_${product_key}_${git_sha}"
git checkout -b "$branch"

###
# Manage Habitat generated pages
###

# Habitat has two generated files (habitat_cli.md and service_templates.md) that
# are made during the release pipeline.
# Those two pages are generated and then pushed up to
# https://packages.chef.io/files/stable/habitat/latest/generated-documentation.tar.gz

# To add these files to chef-web-docs and doc.chef.io, this script uses curl to pull down the
# generated-documentation.tar.gz file, and then overwrite the blank pages pulled
# in by Hugo from github.com/habitat-sh/habitat

# See:
# - https://github.com/habitat-sh/habitat/pull/7993
# - https://github.com/chef/chef-web-docs/blob/main/content/habitat/habitat_cli.md
# - https://github.com/chef/chef-web-docs/blob/main/content/habitat/service_templates.md

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
