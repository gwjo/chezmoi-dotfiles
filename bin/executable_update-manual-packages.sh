#!/usr/bin/env bash
#
# Upgrade manually installed packages
#

set -euo pipefail

github_latest_release() {
  local extra=()
  if [[ -n $GITHUB_ACCESS_TOKEN ]] ; then
    extra=(-u gwjo:$GITHUB_ACCESS_TOKEN)
  fi
  curl ${extra[@]} -LsS "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

github_release_dir() {
  echo "https://github.com/$1/releases/download/$2"
}

github_raw_dir() {
  echo "https://raw.githubusercontent.com/$1/$2/"
}


install_docker_compose() {
  local version=$(github_latest_release "docker/compose")
  local installed=$(docker-compose version --short || true)

  if [[ "$version" != "$installed" ]] ; then
    sudo curl -LsS "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    curl -LsS "https://raw.githubusercontent.com/docker/compose/$version/contrib/completion/bash/docker-compose" -o ~/.local/share/bash-completion/completions/docker-compose

    printf "docker-compose $version installed\n"
  else
    printf "Latest docker-compose ($version) already installed\n"
  fi
}

install_exa() {
  local repo="ogham/exa"
  local version=$(github_latest_release "$repo")
  local installed=$(exa --version || true)

  if [[ "$version" != "${installed:4}" ]] ; then

    local tmp=$(mktemp -d)

    curl -LsS "$(github_release_dir "$repo" "$version")/exa-linux-x86_64-${version:1}.zip" -o "$tmp/exa.zip"
    unzip -p "$tmp/exa.zip"  | sudo tee /usr/local/bin/exa >/dev/null
    sudo chmod +x /usr/local/bin/exa
    rm "$tmp/exa.zip"

    sudo curl -LsS "$(github_raw_dir $repo $version)/contrib/completions.bash" -o ~/.local/share/bash-completion/completions/exa
    sudo curl -LsS "$(github_raw_dir $repo $version)/contrib/man/exa.1" -o /usr/local/share/man/man1/exa.1

    printf "exa $version installed\n"
  else
    printf "Latest exa ($version) already installed\n"
  fi
}

## Install
install_docker_compose
install_exa
