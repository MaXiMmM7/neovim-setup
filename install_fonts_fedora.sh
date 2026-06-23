#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

sudo dnf install -y ca-certificates curl unzip fontconfig google-noto-color-emoji-fonts

"$script_dir/install_fonts_common.sh"
