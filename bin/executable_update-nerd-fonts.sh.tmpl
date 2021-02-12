#!/usr/bin/env bash
#
# Install latest version of docker compose

set -euo pipefail

REPO=ryanoasis/nerd-fonts
INSTALL_DIR=~/.local/share/fonts
FONTS=( FiraCode Monoid )

tag=$(curl -LsS "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name')
printf "\nUpdating to version $tag\n"

mkdir -p "$INSTALL_DIR" &>/dev/null
pushd "$INSTALL_DIR" &>/dev/null

for font in "${FONTS[@]}"; do

    # download
    curl -LsS "https://github.com/${REPO}/releases/download/${tag}/${font}.zip" --output "${font}.zip"

    # unzip fonts, (excluding windows) overwritting old versions
    unzip -o "${font}.zip" -x \*Windows\*

    # Cleanup
    rm "${font}.zip"

done

popd &>/dev/null


