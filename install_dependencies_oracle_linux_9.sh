#!/usr/bin/env bash

set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Oracle Linux 9 keeps some packages this config uses in Oracle's EPEL
# compatibility repository, so bootstrap that first.
sudo dnf install -y oracle-epel-release-el9

# System packages used by this Neovim config:
# - git: lazy.nvim bootstrap and gitsigns integration
# - curl/wget/unzip/tar/gzip: download helpers for external tools and scripts
# - fzf/ripgrep: fzf-lua picker backend and grep-based searching
# - gcc/g++/make: compiler toolchain for Tree-sitter parser builds
# - cmake: core CMake project tooling used alongside the CMake LSP/formatter
# - jq: JSON formatting through conform.nvim
# - shellcheck: shell linting through nvim-lint
# - clang-tools-extra/clang-format/cppcheck: C and C++ LSP, formatting, and linting
# - libxml2: provides xmllint for XML syntax validation and formatting
# - python3/python3-pip: Python tooling and json.tool validation support
# - nodejs/npm: Mason npm-based language servers (including bashls) and prettier/prettierd
# - cargo: Rust linting entrypoint and Rust-based formatter installation
sudo dnf install -y \
  git curl wget unzip tar gzip \
  fzf ripgrep \
  gcc gcc-c++ make \
  cmake \
  jq \
  shellcheck \
  clang-tools-extra clang-format cppcheck \
  libxml2 \
  python3 python3-pip \
  nodejs npm \
  cargo

# Python tools used by the config:
# - pylint: Python linting through nvim-lint
# - black/isort: Python formatting through conform.nvim
# - gersemi: CMake formatting through conform.nvim
# - mdformat/mdformat-gfm: Markdown formatting through conform.nvim
# - yamllint: YAML syntax validation through nvim-lint
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi mdformat mdformat-gfm

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

# shfmt is the shell formatter used by conform.nvim. Install the upstream
# release binary because it is not consistently packaged for Oracle Linux 9.
if ! command -v shfmt >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  arch="$(uname -m)"
  case "$arch" in
    x86_64)
      shfmt_arch="amd64"
      ;;
    aarch64|arm64)
      shfmt_arch="arm64"
      ;;
    *)
      shfmt_arch=""
      printf 'Unsupported architecture for shfmt auto-install: %s\n' "$arch"
      ;;
  esac

  if [ -n "$shfmt_arch" ]; then
    shfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/mvdan/sh/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
    curl -fsSL "https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_linux_${shfmt_arch}" -o "$tmpdir/shfmt"
    install -m 0755 "$tmpdir/shfmt" "$HOME/.local/bin/shfmt"
  fi

  rm -rf "$tmpdir"
fi

# Node-based formatters used by conform.nvim for JavaScript.
sudo npm install -g prettier prettierd

# Rust-based formatter used by conform.nvim for Lua files.
if ! command -v stylua >/dev/null 2>&1; then
  cargo install --locked stylua
fi

# Go linter used by nvim-lint. The upstream script is more reliable than
# distro package names across Oracle Linux releases.
if ! command -v golangci-lint >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
    | sh -s -- -b "$HOME/.local/bin" latest
fi

# rustfmt is used by conform.nvim for Rust formatting. Install it when rustup
# is available; otherwise leave a note because some systems provide it as a
# separate distro package instead.
if command -v rustup >/dev/null 2>&1; then
  rustup component add rustfmt
else
  printf 'rustup not found; install rustfmt separately if you edit Rust files.\n'
fi

# Install or update Neovim-managed tools:
# - Lazy sync installs/update plugins first
# - Mason installs the LSP servers referenced by this config
# - TSUpdate refreshes Tree-sitter parsers used for syntax highlighting/rendering
if command -v nvim >/dev/null 2>&1; then
  nvim --headless \
    "+Lazy! sync" \
    "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx bashls" \
    "+TSUpdate" \
    "+qa"
else
  printf 'nvim not found; skipping Lazy/Mason/Tree-sitter setup.\n'
fi

# This config looks best with a Nerd Font, but font installation is left manual
# because it depends on the terminal emulator and desktop environment.
printf 'Done. If icons look wrong, install a Nerd Font and select it in your terminal.\n'
