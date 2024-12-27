set shell := ["/bin/bash", "-c"]

jwd := justfile_directory()
cwd := invocation_directory()
home_dir := home_directory()

target_dir := home_dir / ".config"

alias brew := install

_default:
  @just --list

# Installs packages and config
bootstrap: install config

# Install packages from Brewfile
install:
  echo "Installing from brew..."
  brew bundle install --file={{ jwd }}/Brewfile

# Add dotfile config
config:
  #!/usr/bin/env bash

  set -euo pipefail
  # set -o xtrace # Debug

  link_config() {
    local config_name=$1

    echo "Configuring ${config_name}"
    if [ -d "{{ target_dir }}/${config_name}" ]; then
      if [ ! -L "{{ target_dir }}/${config_name}" ]; then
        echo "Backing up {{ target_dir }}/${config_name} to {{ target_dir }}/${config_name}.bak"
        mv {{ target_dir }}/${config_name} {{ target_dir }}/${config_name}.bak
      else
        echo "{{ target_dir }}/${config_name} is a symlink, not backing up"
        ls -l "{{ target_dir }}/${config_name}"
      fi
    fi

    echo "Symlinking ${config_name} config"
    ln -sf  {{ jwd }}/${config_name} {{ target_dir }}/${config_name}
  }

  echo "Ensuring directory '{{ target_dir }}' exists..."
  mkdir -p {{ target_dir }}

  echo "Injecting dotfiles..."

  link_config "ghostty"
  link_config "kitty"
  link_config "nvim"

  touch {{ home_dir }}/.gitconfig
  if [ -z "$(grep 'path = {{ jwd }}/.gitconfig' '{{ home_dir }}/.gitconfig')" ]; then
    echo "Adding git config..."
    cat <<EOF >>{{ home_dir }}/.gitconfig

  [include]
    path = {{ jwd }}/.gitconfig
  EOF
  else
    echo "Git config already present, skipping..."
  fi

  echo "Setting global .gitignore"
  git config --global core.excludesFile '{{ jwd }}/.gitignore'

  echo "Done!"

