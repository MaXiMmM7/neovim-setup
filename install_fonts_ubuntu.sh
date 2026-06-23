#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

sudo apt update
sudo apt install -y ca-certificates curl unzip fontconfig fonts-noto-color-emoji

"$script_dir/install_fonts_common.sh"
