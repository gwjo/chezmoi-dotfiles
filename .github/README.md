# Dotfiles #

Managed with [twpayne/chezmoi](https://github.com/twpayne/chezmoi).


## Instructions

1. Update tmux tpm plugin:

```shell
curl -s -L -o tpm-master.tar.gz https://github.com/tmux-plugins/tpm/archive/master.tar.gz
chezmoi import --strip-components 1 --destination ~/.tmux/plugins/tpm tpm-master.tar.gz
```
