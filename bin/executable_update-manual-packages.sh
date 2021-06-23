#!/usr/bin/env bash
#
# Upgrade manually installed packages
#

set -euo pipefail

github_latest_release() {
  local extra=()
  if [[ -n ${GITHUB_ACCESS_TOKEN-} ]] ; then
    extra=(-u gwjo:$GITHUB_ACCESS_TOKEN)
  fi
  curl ${extra[@]} -LsS "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

github_release_dir() {
  echo "https://github.com/$1/releases/download/$2"
}

github_raw_dir() {
  echo "https://raw.githubusercontent.com/$1/$2"
}

github_install_deb() {
  local tmp=$(mktemp -d)

  curl -LsS "$(github_release_dir "$1" "$2")/$3" -o "$tmp/$3"
  sudo dpkg -i "$tmp/$3" >/dev/null
  rm -rf "$tmp"
}

install_bat() {
  local repo="sharkdp/bat"
  local version=$(github_latest_release "$repo")  # v0.17.1
  local installed=$(bat --version 2>/dev/null || true)        # bat 0.17.1

  if [[ "${version:1}" != "${installed:4}"
        && -n $version ]] ; then
    github_install_deb "$repo" "$version" "bat_${version:1}_amd64.deb"
  fi

  printf "bat \t\t${version:1}\t(${installed:4})\n"
}

install_delta() {
  local repo="barnumbirr/delta-debian"
  local version=$(github_latest_release "$repo")          # 0.6.0-1
  local installed=$(delta --version 2>/dev/null || true)  # delta 0.6.0

  if [[ "${version:0:-2}" != "${installed:6}"
        && -n $version ]] ; then
    github_install_deb "$repo" "$version" "delta-diff_${version}_amd64_debian_buster.deb"

  fi

  printf "delta-diff \t${version:0:-2}\t(${installed:6})\n"

}
install_docker_compose() {
  local repo="docker/compose"
  local version=$(github_latest_release "$repo")
  local installed=$(docker-compose version --short 2>/dev/null || true)

  if [[ "$version" != "$installed"
        && -n $version ]] ; then
    sudo curl -LsS "$(github_release_dir "$repo" "$version")/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    curl -LsS "$(github_raw_dir "$repo" "$version")/contrib/completion/bash/docker-compose" -o ~/.local/share/bash-completion/completions/docker-compose

  fi

  printf "docker-compose \t$version\t($installed)\n"
}


install_exa() {
  local repo="ogham/exa"
  local version=$(github_latest_release "$repo")        # v0.9.0
  local installed=$(exa --version 2>/dev/null || true)  # exa v0.9.0

  if [[ "$version" != "${installed:4}"
        && -n $version ]] ; then

    local tmp=$(mktemp -d)

    curl -LsS "$(github_release_dir "$repo" "$version")/exa-linux-x86_64-${version}.zip" -o "$tmp/exa.zip"
    unzip -p "$tmp/exa.zip" bin/exa | sudo tee /usr/local/bin/exa >/dev/null
    sudo chmod +x /usr/local/bin/exa

    unzip -p "$tmp/exa.zip" completions/exa.bash | tee ~/.local/share/bash-completion/completions/exa.bash
    unzip -p "$tmp/exa.zip" man/exa.1 | sudo tee /usr/local/share/man/man1/exa.1
    rm -rf "$tmp"
  fi

  printf "exa \t\t${version:1} \t(${installed:5})\n"
}

install_hyperfine() {
  local repo="sharkdp/hyperfine"
  local version=$(github_latest_release "$repo")              # v1.11.0
  local installed=$(hyperfine --version 2>/dev/null || true)  # hyperfine 1.11.0

  if [[ "${version:1}" != "${installed:10}"
        && -n $version ]] ; then
    github_install_deb "$repo" "$version" "hyperfine_${version:1}_amd64.deb"
  fi

  printf "hyperfine \t${version:1}\t(${installed:10})\n"
}

install_fd() {
  local repo="sharkdp/fd"
  local version=$(github_latest_release "$repo")       # v8.2.1
  local installed=$(fd --version 2>/dev/null || true)  # fd 8.2.1

  if [[ "${version:1}" != "${installed:3}"
        && -n $version ]] ; then
    github_install_deb "$repo" "$version" "fd_${version:1}_amd64.deb"
  fi

  printf "fd \t\t${version:1}\t(${installed:3})\n"
}

install_pet() {
  local repo="knqyf263/pet"
  local version=$(github_latest_release "$repo")      # v0.3.6
  local installed=$(pet version 2>/dev/null || true)  # pet version 0.3.6

  if [[ "${version:1}" != "${installed:12}"
        && -n $version ]] ; then
    github_install_deb "$repo" "$version" "pet_${version:1}_linux_amd64.deb"
  fi

  printf "pet \t\t${version:1}\t(${installed:12})\n"
}

install_zoxide() {
  local repo="ajeetdsouza/zoxide"
  local version=$(github_latest_release "$repo")           # v0.5.0
  local installed=$(zoxide --version 2>/dev/null || true)  # zoxide v0.5.0

  if [[ "${version:1}" != "${installed:8}"
        && -n $version ]] ; then

    local tmp=$(mktemp -d)
    local tar="$tmp/zoxide.tar.gz"
    local bin="zoxide-x86_64-unknown-linux-musl/zoxide"

    curl -LsS "$(github_release_dir "$repo" "$version")/zoxide-x86_64-unknown-linux-musl.tar.gz" -o "$tar"
    tar xzf "$tar" "$bin" -O | sudo tee /usr/local/bin/zoxide >/dev/null
    sudo chmod +x /usr/local/bin/zoxide

    rm -rf "$tmp"
  fi

  printf "zoxide \t\t${version:1}\t(${installed:8})\n"
}


## Install
install_bat
install_delta
install_docker_compose
install_exa
install_fd
install_hyperfine
install_pet
install_zoxide

