set shell := ["/bin/bash", "-c"]

jwd := justfile_directory()
cwd := invocation_directory()
home_dir := home_directory()

target_directory := home_dir / ".config"

_default:
  @just --list

# Bootstraps laptop with dotfile configuration
bootstrap:
  #!/usr/bin/env bash

  set -euo pipefail
  set -o xtrace

  echo "Creating directory..."
  mkdir -p {{ target_directory }}

  echo "Installing from brew..."
  brew bundle install --file={{ jwd }}/Brewfile

  echo "Injecting dotfiles..."
  if [ -d "{{ target_directory }}/kitty" ]; then
    echo "Deleting {{ target_directory }}/kitty in preparation for symlink"
    rm -rf {{ target_directory }}/kitty
  fi

  echo "Symlinking kitty config"
  ln -sf  {{ jwd }}/kitty {{ target_directory }}/kitty

  if [ -d "{{ target_directory }}/nvim" ]; then
    echo "Deleting {{ target_directory }}/nvim in preparation for symlink"
    rm -rf {{ target_directory }}/nvim
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

_post_bootstrap:
  #!/usr/bin/env bash

  cat <<EOF
  Installation finished!

  Things you still need to do:

  EOF
