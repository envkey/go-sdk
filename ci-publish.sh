#!/bin/bash

version=${1?missing param 1 version}
branch=${2?missing param 2 branch}

echo $version $branch

THIS_DIR=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
PUBLIC_GO_MOD_REPO=$(
  cd "$THIS_DIR/../../../../go-sdk"
  pwd -P
)
# assume the repo exists
cd $PUBLIC_GO_MOD_REPO || "did you git clone go-sdk mirror?"
pwd

ENVKEYFETCH_VERSION=$(cat $THIS_DIR/../../../releases/envkeyfetch/envkeyfetch-version.txt)
echo "Using envkey-fetch $ENVKEYFETCH_VERSION"

git checkout -b "$branch" || git checkout "$branch"
git branch

rm -rf ./*

# files to move over
cp -r $THIS_DIR/* ./
# go modules
rm ./go.mod
mv ./go.mod.public ./go.mod
go mod download

git add -A
git commit -m "Release v${version}"
git tag -m "v${version}" "v$version"
git push origin --tags "$branch"