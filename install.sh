#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"

link_file() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
  fi

  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

link_file "$REPO_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"
link_file "$REPO_DIR/bash/.bash_aliases" "$HOME_DIR/.bash_aliases"
link_file "$REPO_DIR/shell/.profile" "$HOME_DIR/.profile"
link_file "$REPO_DIR/git/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$REPO_DIR/git/.gitignore_global" "$HOME_DIR/.gitignore_global"

echo "done"
