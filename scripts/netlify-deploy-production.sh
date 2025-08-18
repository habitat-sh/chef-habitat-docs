#!/bin/bash

set -eoux pipefail

###
# Generate Netlify build previews
###

DART_SASS_VERSION="1.81.0"
DESTINATION="./public"

echo Release version: Current
echo Destination: $DESTINATION
echo Branch: $HEAD
echo Deploy URL: $DEPLOY_PRIME_URL

# Hugo requires dart-sass
# https://gohugo.io/functions/resources/tocss/#netlify

curl -LJO https://github.com/sass/dart-sass/releases/download/$DART_SASS_VERSION/dart-sass-$DART_SASS_VERSION-linux-x64.tar.gz
tar -xf dart-sass-$DART_SASS_VERSION-linux-x64.tar.gz
rm dart-sass-$DART_SASS_VERSION-linux-x64.tar.gz
export PATH=/opt/build/repo/dart-sass:$PATH

npm install
npm ls

hugo --gc --minify --enableGitInfo --destination $DESTINATION --baseURL $DEPLOY_PRIME_URL
