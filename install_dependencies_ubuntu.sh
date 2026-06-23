#!/usr/bin/env bash

set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"

version_ge() {
  local actual="$1"
  local required="$2"

  [ "$(printf '%s\n%s\n' "$required" "$actual" | sort -V | head -n 1)" = "$required" ]
}

tool_version() {
  "$1" --version 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+)+' | head -n 1 || true
}

tool_version_ge() {
  local tool="$1"
  local required="$2"
  local actual

  if ! command -v "$tool" >/dev/null 2>&1; then
    return 1
  fi

  actual="$(tool_version "$tool")"
  [ -n "$actual" ] && version_ge "$actual" "$required"
}

install_tree_sitter_cli() {
  local minimum_version="0.26.1"
  local arch
  local asset
  local tmpdir

  if tool_version_ge tree-sitter "$minimum_version"; then
    return
  fi

  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)
      asset="tree-sitter-linux-x64.gz"
      ;;
    aarch64|arm64)
      asset="tree-sitter-linux-arm64.gz"
      ;;
    *)
      printf 'Unsupported architecture for Tree-sitter CLI auto-install: %s\n' "$arch"
      return
      ;;
  esac

  printf 'Installing latest upstream Tree-sitter CLI to %s\n' "$HOME/.local/bin/tree-sitter"
  tmpdir="$(mktemp -d)"
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/${asset}" -o "$tmpdir/tree-sitter.gz"
  gunzip -c "$tmpdir/tree-sitter.gz" >"$tmpdir/tree-sitter"
  install -m 0755 "$tmpdir/tree-sitter" "$HOME/.local/bin/tree-sitter"
  rm -rf "$tmpdir"
  hash -r
}

install_neovim_release() {
  local minimum_version="0.12.0"
  local arch
  local nvim_arch
  local tmpdir

  if tool_version_ge nvim "$minimum_version"; then
    return
  fi

  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)
      nvim_arch="x86_64"
      ;;
    aarch64|arm64)
      nvim_arch="arm64"
      ;;
    *)
      printf 'Unsupported architecture for Neovim auto-install: %s\n' "$arch"
      return
      ;;
  esac

  printf 'Installing latest upstream Neovim to %s\n' "$HOME/.local/opt/nvim"
  tmpdir="$(mktemp -d)"
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" -o "$tmpdir/nvim.tar.gz"
  tar -xzf "$tmpdir/nvim.tar.gz" -C "$tmpdir"
  rm -rf "$HOME/.local/opt/nvim"
  mv "$tmpdir/nvim-linux-${nvim_arch}" "$HOME/.local/opt/nvim"
  ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
  rm -rf "$tmpdir"
  hash -r
}

install_stylua() {
  local arch
  local asset
  local tmpdir

  if command -v stylua >/dev/null 2>&1; then
    return
  fi

  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)
      asset="stylua-linux-x86_64.zip"
      ;;
    aarch64|arm64)
      asset="stylua-linux-aarch64.zip"
      ;;
    *)
      printf 'Unsupported architecture for StyLua auto-install: %s\n' "$arch"
      return
      ;;
  esac

  printf 'Installing latest upstream StyLua to %s\n' "$HOME/.local/bin/stylua"
  tmpdir="$(mktemp -d)"
  curl -fsSL "https://github.com/JohnnyMorganz/StyLua/releases/latest/download/${asset}" -o "$tmpdir/stylua.zip"
  unzip -q "$tmpdir/stylua.zip" -d "$tmpdir/stylua"
  install -m 0755 "$tmpdir/stylua/stylua" "$HOME/.local/bin/stylua"
  rm -rf "$tmpdir"
  hash -r
}

pipx_install_or_upgrade() {
  local package="$1"

  pipx install "$package" || pipx upgrade "$package"
}

# System packages used by this Neovim config:
# - git: lazy.nvim bootstrap and gitsigns integration
# - curl/wget/unzip/tar/gzip/ca-certificates: download helpers for external tools and scripts
# - fzf/ripgrep/fd-find: fzf-lua picker backend and grep/file searching
# - build-essential/pkg-config: compiler toolchain for Tree-sitter parser builds
# - tree-sitter-cli: distro fallback; upgraded below when Ubuntu's package is too old
# - cmake: core CMake project tooling used alongside the CMake LSP/formatter
# - jq: JSON formatting through conform.nvim
# - shellcheck/shfmt: shell linting and formatting through nvim-lint/conform.nvim
# - clangd/clang-format/cppcheck: C and C++ LSP, formatting, and linting
# - libxml2-utils: provides xmllint for XML syntax validation
# - python3/python3-pip/python3-venv/python3-pynvim/pipx: Python tooling and isolated CLI installs
# - nodejs/npm: Mason npm-based language servers (including bashls) and prettier/prettierd
# - cargo/rustfmt: Rust linting and formatting entrypoints
# - golang-go: Go toolchain used by Go linters and Go projects
# - wl-clipboard/xclip: clipboard integration on Wayland/X11 terminals
sudo apt update
sudo apt install -y software-properties-common ca-certificates
sudo add-apt-repository -y universe
sudo apt update
sudo apt install -y \
  git curl wget unzip tar gzip ca-certificates \
  fzf ripgrep fd-find \
  build-essential pkg-config \
  tree-sitter-cli \
  cmake \
  jq \
  shellcheck shfmt \
  clangd clang-format cppcheck \
  libxml2-utils \
  python3 python3-pip python3-venv python3-pynvim pipx \
  nodejs npm \
  cargo rustfmt \
  golang-go \
  wl-clipboard xclip

# Ubuntu 24.04 ships tree-sitter-cli 0.20.x, but current nvim-treesitter main
# requires 0.26.1+. Install the upstream CLI first in PATH when apt is too old.
install_tree_sitter_cli

# Ubuntu 24.04 ships Neovim 0.9.5, while current nvim-treesitter main requires
# Neovim 0.12+. Install the upstream release first in PATH when apt is too old.
install_neovim_release

# Ubuntu names the fd binary fdfind. Many editor tools expect fd.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1 && [ ! -e "$HOME/.local/bin/fd" ]; then
  ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
  hash -r
fi

# Python tools used by the config:
# - pylint: Python linting through nvim-lint
# - black/isort: Python formatting through conform.nvim
# - gersemi: CMake formatting through conform.nvim
# - mdformat/mdformat-gfm: Markdown formatting through conform.nvim
# - yamllint: YAML syntax validation through nvim-lint
pipx_install_or_upgrade pylint
pipx_install_or_upgrade black
pipx_install_or_upgrade isort
pipx_install_or_upgrade yamllint
pipx_install_or_upgrade gersemi
pipx_install_or_upgrade mdformat
pipx inject mdformat mdformat-gfm || pipx runpip mdformat install --upgrade mdformat-gfm

# yamlfmt is the YAML formatter used by conform.nvim. Install the upstream
# static release binary because distro packages are inconsistent.
if ! command -v yamlfmt >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  arch="$(uname -m)"
  case "$arch" in
    x86_64)
      yamlfmt_arch="x86_64"
      ;;
    aarch64|arm64)
      yamlfmt_arch="arm64"
      ;;
    *)
      yamlfmt_arch=""
      printf 'Unsupported architecture for yamlfmt auto-install: %s\n' "$arch"
      ;;
  esac

  if [ -n "$yamlfmt_arch" ]; then
    yamlfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/google/yamlfmt/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
    yamlfmt_version_no_v="${yamlfmt_version#v}"
    curl -fsSL "https://github.com/google/yamlfmt/releases/download/${yamlfmt_version}/yamlfmt_${yamlfmt_version_no_v}_Linux_${yamlfmt_arch}.tar.gz" -o "$tmpdir/yamlfmt.tar.gz"
    tar -xzf "$tmpdir/yamlfmt.tar.gz" -C "$tmpdir"
    install -m 0755 "$tmpdir/yamlfmt" "$HOME/.local/bin/yamlfmt"
  fi

  rm -rf "$tmpdir"
fi

# Node-based formatters used by conform.nvim for JavaScript.
sudo npm install -g prettier prettierd

# Formatter used by conform.nvim for Lua files.
install_stylua

# Go linter used by nvim-lint. The upstream script is more reliable than
# distro package names across Ubuntu releases.
if ! command -v golangci-lint >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
    | sh -s -- -b "$HOME/.local/bin" latest
fi

# rustfmt is used by conform.nvim for Rust formatting. Apt installs a distro
# rustfmt above; if rustup shadows it, make sure that toolchain has rustfmt too.
if command -v rustup >/dev/null 2>&1; then
  rustup component add rustfmt
fi

# Install or update Neovim-managed tools:
# - Lazy sync installs/update plugins first
# - Mason installs the LSP servers referenced by this config
# - nvim-treesitter install/update is forced to wait so first-run setup finishes
if command -v nvim >/dev/null 2>&1; then
  nvim --headless \
    "+Lazy! sync" \
    "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx bashls" \
    "+lua require('nvim-treesitter').install({ 'c', 'cpp', 'go', 'bash', 'lua', 'vim', 'vimdoc', 'elixir', 'javascript', 'html', 'python', 'typescript', 'markdown', 'markdown_inline', 'latex', 'yaml', 'cmake' }):wait(300000)" \
    "+lua require('nvim-treesitter').update():wait(300000)" \
    "+qa"
else
  printf 'nvim not found; skipping Lazy/Mason/Tree-sitter setup.\n'
fi

printf 'Done. For Neovim icons, run ./install_fonts_ubuntu.sh and select IntelOneMono Nerd Font Mono in your terminal.\n'
