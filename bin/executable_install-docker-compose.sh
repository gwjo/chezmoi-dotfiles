#!/usr/bin/env bash
#
# Install latest version of docker compose

set -euo pipefail

version=$(curl -LsS https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
installed=$(docker-compose version --short || true)

if [[ "$version" != "$installed" ]] ; then
  sudo curl -LsS "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  curl -LsS "https://raw.githubusercontent.com/docker/compose/$version/contrib/completion/bash/docker-compose" -o ~/.local/share/bash-completion/completions/docker-compose

  printf "docker-compose $version installed\n"
else
  printf "Latest docker-compose ($version) already installed\n"
fi

