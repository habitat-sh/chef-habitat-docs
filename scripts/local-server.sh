#!/bin/bash

set -eoux pipefail

###
# Local deploy preview using Netlify CLI
# https://docs.netlify.com/cli/get-started/
# Run 'netlify dev'
###

npm ci
npm ls

make bundle
hugo server -b localhost:1313
