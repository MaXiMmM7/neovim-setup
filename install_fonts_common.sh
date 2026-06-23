#!/usr/bin/env bash

set -euo pipefail

NERD_FONT_NAME="${NERD_FONT_NAME:-IntelOneMono}"
NERD_FONT_VERSION="${NERD_FONT_VERSION:-latest}"
FONT_ROOT="${FONT_ROOT:-$HOME/.local/share/fonts}"
FONT_DIR="$FONT_ROOT/NerdFonts/$NERD_FONT_NAME"
SYMBOLS_DIR="$FONT_ROOT/NerdFonts/NerdFontsSymbolsOnly"

font_archive_url() {
  local font_name="$1"
  local version_path="latest/download"

  if [ "$NERD_FONT_VERSION" != "latest" ]; then
    version_path="download/$NERD_FONT_VERSION"
  fi

  printf 'https://github.com/ryanoasis/nerd-fonts/releases/%s/%s.zip\n' "$version_path" "$font_name"
}

install_font_archive() {
  local font_name="$1"
  local dest_dir="$2"
  local tmpdir
  local archive

  tmpdir="$(mktemp -d)"
  archive="$tmpdir/$font_name.zip"

  printf 'Installing %s Nerd Font files into %s\n' "$font_name" "$dest_dir"
  curl -fsSL "$(font_archive_url "$font_name")" -o "$archive"
  rm -rf "$dest_dir"
  mkdir -p "$dest_dir"
  unzip -q "$archive" -d "$dest_dir"
  rm -rf "$tmpdir"
}

font_family_installed() {
  local font_pattern="$1"

  command -v fc-match >/dev/null 2>&1 && fc-match "$font_pattern" | grep -qi "$font_pattern"
}

install_nerd_fonts() {
  mkdir -p "$FONT_ROOT/NerdFonts"

  if ! font_family_installed "$NERD_FONT_NAME Nerd Font Mono"; then
    install_font_archive "$NERD_FONT_NAME" "$FONT_DIR"
  else
    printf '%s Nerd Font Mono is already visible to fontconfig.\n' "$NERD_FONT_NAME"
  fi

  if ! font_family_installed "Symbols Nerd Font Mono"; then
    install_font_archive "NerdFontsSymbolsOnly" "$SYMBOLS_DIR"
  else
    printf 'Symbols Nerd Font Mono is already visible to fontconfig.\n'
  fi

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_ROOT"
  else
    printf 'fc-cache not found; install fontconfig and refresh the font cache manually.\n'
  fi
}

print_font_status() {
  printf '\nFont setup complete.\n'
  printf 'Set your terminal font to: %s Nerd Font Mono\n' "$NERD_FONT_NAME"

  if command -v fc-match >/dev/null 2>&1; then
    printf '\nfontconfig matches:\n'
    fc-match "$NERD_FONT_NAME Nerd Font Mono" || true
    fc-match "Symbols Nerd Font Mono" || true
  fi

  printf '\nRestart already-open terminals after changing the terminal font.\n'
}

install_nerd_fonts
print_font_status
