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

  echo "Ensuring directory '{{ target_dir }}' exists..."
  mkdir -p {{ target_dir }}

  echo "Injecting dotfiles..."
  if [ -d "{{ target_dir }}/kitty" ]; then
    if [ ! -L "{{ target_dir }}/kitty" ]; then
      echo "Backing up {{ target_dir }}/kitty to {{ target_dir }}/kitty.bak"
      mv {{ target_dir }}/kitty {{ target_dir }}/kitty.bak
    else
      echo "{{ target_dir }}/kitty is a symlink, not backing up"
      ls -l "{{ target_dir }}/kitty"
    fi
  fi

  echo "Symlinking kitty config"
  ln -sf  {{ jwd }}/kitty {{ target_dir }}/kitty

  if [ -d "{{ target_dir }}/nvim" ]; then
    if [ ! -L "{{ target_dir }}/nvim" ]; then
      echo "Backing up {{ target_dir }}/nvim to {{ target_dir }}/nvim.bak"
      mv {{ target_dir }}/nvim {{ target_dir }}/nvim.bak
    else
      echo "{{ target_dir }}/nvim is a symlink, not backing up"
      ls -l "{{ target_dir }}/nvim"
    fi
  fi

  echo "Symlinking nvim config"
  ln -sf  {{ jwd }}/nvim {{ target_dir }}/nvim

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

