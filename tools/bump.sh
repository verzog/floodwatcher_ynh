#!/bin/bash
# Point manifest.toml at a new Flood Watcher release: sets the version (resetting the package
# revision to ~ynh1), the source URL and its SHA-256 checksum.
#
# Usage: ./tools/bump.sh 0.17.1          (the code repository must already have the tag v0.17.1)
#        ./tools/bump.sh 0.17.1 2        (same code, package revision ~ynh2)
set -euo pipefail

version="${1:?Usage: $0 <version> [package revision]}"
revision="${2:-1}"
if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ && "$revision" =~ ^[0-9]+$ ]]; then
    echo "The version must look like 0.17.1 and the revision like 1." >&2
    exit 1
fi
url="https://github.com/verzog/floodwatcher/archive/refs/tags/v${version}.tar.gz"
manifest="$(dirname "$0")/../manifest.toml"

echo "Downloading $url ..."
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$url" -o "$tmp"
sum="$(sha256sum "$tmp" | cut -d' ' -f1)"

sed -i -E \
    -e "s|^version = \".*\"|version = \"${version}~ynh${revision}\"|" \
    -e "s|^(    url = )\".*\"|\1\"${url}\"|" \
    -e "s|^(    sha256 = )\".*\"|\1\"${sum}\"|" \
    "$manifest"

echo "manifest.toml now points at v${version} (sha256 ${sum}). Check it with: git diff"
