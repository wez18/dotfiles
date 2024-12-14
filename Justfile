set shell := ["/bin/bash", "-c"]

jwd := justfile_directory()
cwd := invocation_directory()
home_dir := home_directory()

target_directory := home_dir / ".config"

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

  echo "Ensuring directory '{{ target_directory }}' exists..."
  mkdir -p {{ target_directory }}

  echo "Injecting dotfiles..."
  if [ -d "{{ target_directory }}/kitty" ]; then
    if [ ! -L "{{ target_directory }}/kitty" ]; then
      echo "Backing up {{ target_directory }}/kitty to {{ target_directory}}/kitty.bak"
      mv {{ target_directory }}/kitty {{ target_directory }}/kitty.bak
    else
      echo "{{ target_directory }}/kitty is a symlink, not backing up"
      ls -l "{{ target_directory }}/kitty"
    fi
  fi

  echo "Symlinking kitty config"
  ln -sf  {{ jwd }}/kitty {{ target_directory }}/kitty

  if [ -d "{{ target_directory }}/nvim" ]; then
    if [ ! -L "{{ target_directory }}/nvim" ]; then
      echo "Backing up {{ target_directory }}/nvim to {{ target_directory }}/nvim.bak"
      mv {{ target_directory }}/nvim {{ target_directory }}/nvim.bak
    else
      echo "{{ target_directory }}/nvim is a symlink, not backing up"
      ls -l "{{ target_directory }}/nvim"
    fi
  fi

  echo "Symlinking nvim config"
  ln -sf  {{ jwd }}/nvim {{ target_directory }}/nvim

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

