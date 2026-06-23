#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

sudo dnf install -y oracle-epel-release-el9
sudo dnf install -y ca-certificates curl unzip fontconfig
sudo dnf install -y google-noto-color-emoji-fonts || printf 'Emoji font package not available; continuing with Nerd Font setup.\n'

"$script_dir/install_fonts_common.sh"
