# Neovim Dependencies

This document lists the external tools used by the Neovim config in this
directory, what each tool is used for, and how to install them on Ubuntu-like,
Fedora-like, and Oracle Linux 9 systems.

Use the distro-specific scripts in this directory for a mostly automatic setup:

- `./install_dependencies_ubuntu.sh`
- `./install_dependencies_fedora.sh`
- `./install_dependencies_oracle_linux_9.sh`

## Validation In Neovim

For syntax validation and diagnostics, the config now uses both LSP and
`nvim-lint`.

- `json`: `jsonls` plus `json_tool`
- `yaml` / `yml`: `yamlls` plus `yamllint`
- `xml`: `lemminx` plus `xmllint`

For CMake editing, the config uses:

- `cmake`: `neocmake` for LSP/linting plus `gersemi` for formatting

For shell editing, the config uses:

- `sh` / `bash`: `bashls` for LSP, `shellcheck` for linting, and `shfmt` for formatting

For formatting, the config uses:

- `json`: `jq`
- `yaml` / `yml`: `yamlfmt`
- `markdown` / `md`: `mdformat` plus `mdformat-gfm`
- `xml`: `xmllint`

Useful keys already configured:

- `<leader>f`: format the current file or selected range
- `<leader>l`: trigger linting for the current file
- `<leader>d`: show diagnostics for the current line
- `[d`: previous diagnostic
- `]d`: next diagnostic
- `<leader>D`: fuzzy-find buffer diagnostics

## Dependency List

| Dependency | Used For | Install Method | Required |
| --- | --- | --- | --- |
| `git` | `lazy.nvim` bootstrap and `gitsigns` features | apt / dnf | Yes |
| `curl`, `wget`, `unzip`, `tar`, `gzip` | download helpers and install scripts | apt / dnf | Yes |
| `fzf` | `fzf-lua` picker backend | apt / dnf | Yes |
| `ripgrep` | `fzf-lua` grep/search commands | apt / dnf | Yes |
| C/C++ build toolchain | compile Tree-sitter parsers, build native tooling | apt / dnf | Yes |
| `clangd` | C/C++ LSP | apt / dnf | Yes |
| `clang-format` | C/C++ formatting | apt / dnf | Yes |
| `cppcheck` | C/C++ linting | apt / dnf | Yes |
| `cmake` | CMake project tooling and local configure/build workflows | apt / dnf | Recommended for CMake |
| `jq` | JSON formatting through conform.nvim | apt / dnf | Yes for JSON |
| `python3`, `python3-pip` | Python tooling and `json.tool` validation | apt / dnf | Yes |
| `pylint` | Python linting | pip | Yes for Python |
| `black`, `isort` | Python formatting | pip | Yes for Python |
| `gersemi` | CMake formatting through conform.nvim | pip | Yes for CMake |
| `mdformat`, `mdformat-gfm` | Markdown formatting through conform.nvim | pip | Yes for Markdown |
| `shellcheck` | Shell linting through nvim-lint | apt / dnf | Yes for shell |
| `shfmt` | Shell formatting through conform.nvim | apt / dnf or release binary | Yes for shell |
| `yamllint` | YAML linting | pip | Yes for YAML |
| `yamlfmt` | YAML formatting through conform.nvim | release binary | Yes for YAML |
| `libxml2-utils` or `libxml2` | provides `xmllint` for XML linting | apt / dnf | Yes for XML |
| `nodejs`, `npm` | Mason npm-based LSP servers and JS formatters | apt / dnf | Yes |
| `prettier` or `prettierd` | JavaScript formatting | npm | Yes for JS |
| `cargo` | Rust linting entrypoint and Rust-based tool installs | apt / dnf | Yes |
| `rustfmt` | Rust formatting | rustup or distro package | Yes for Rust |
| `stylua` | Lua formatting | cargo | Yes for Lua |
| `golangci-lint` | Go linting | upstream install script | Yes for Go |
| Nerd Font | icons in statusline, bufferline, file pickers, markdown render | manual | Recommended |

## Mason-Managed LSP Servers

These are installed by Neovim through Mason, not by `apt` / `dnf` directly:

- `clangd`
- `neocmake`
- `lua_ls`
- `ty`
- `postgres_lsp`
- `jsonls`
- `yamlls`
- `lemminx`
- `bashls`

Note: this config hardcodes `/usr/bin/clangd` for C/C++, so a system-installed
`clangd` is still required even though Mason also tracks `clangd`.

For CMake specifically, `neocmake` provides completions, navigation, hover,
rename, and diagnostics, while `gersemi` is the primary formatter used by
`<leader>f`.

For shell scripts, `bashls` provides LSP features, `shellcheck` provides the
main diagnostics, and `shfmt` is the formatter used by `<leader>f`.

## Ubuntu-Like Install Commands

System packages:

```bash
sudo apt update
sudo apt install -y \
  git curl wget unzip tar gzip \
  fzf ripgrep \
  build-essential \
  cmake \
  jq \
  shellcheck shfmt \
  clangd clang-format cppcheck \
  libxml2-utils \
  python3 python3-pip \
  nodejs npm \
  cargo
```

Python tools:

```bash
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi mdformat mdformat-gfm
```

YAML formatter:

```bash
mkdir -p "$HOME/.local/bin"
yamlfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/google/yamlfmt/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
yamlfmt_version_no_v="${yamlfmt_version#v}"
curl -fsSL "https://github.com/google/yamlfmt/releases/download/${yamlfmt_version}/yamlfmt_${yamlfmt_version_no_v}_Linux_x86_64.tar.gz" -o /tmp/yamlfmt.tar.gz
tar -xzf /tmp/yamlfmt.tar.gz -C /tmp
install -m 0755 /tmp/yamlfmt "$HOME/.local/bin/yamlfmt"
```

Node tools:

```bash
sudo npm install -g prettier prettierd
```

Rust tools:

```bash
cargo install --locked stylua
```

Optional Rust formatter when `rustup` is available:

```bash
rustup component add rustfmt
```

Go linter:

```bash
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
  | sh -s -- -b "$HOME/.local/bin" latest
```

Neovim-managed tools:

```bash
nvim --headless \
  "+Lazy! sync" \
  "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx bashls" \
  "+TSUpdate" \
  "+qa"
```

## Fedora-Like Install Commands

System packages:

```bash
sudo dnf install -y \
  git curl wget unzip tar gzip \
  fzf ripgrep \
  gcc gcc-c++ make \
  cmake \
  jq \
  shellcheck shfmt \
  clang-tools-extra cppcheck \
  libxml2 \
  python3 python3-pip \
  nodejs npm \
  cargo
```

Python tools:

```bash
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi mdformat mdformat-gfm
```

YAML formatter:

```bash
mkdir -p "$HOME/.local/bin"
yamlfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/google/yamlfmt/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
yamlfmt_version_no_v="${yamlfmt_version#v}"
curl -fsSL "https://github.com/google/yamlfmt/releases/download/${yamlfmt_version}/yamlfmt_${yamlfmt_version_no_v}_Linux_x86_64.tar.gz" -o /tmp/yamlfmt.tar.gz
tar -xzf /tmp/yamlfmt.tar.gz -C /tmp
install -m 0755 /tmp/yamlfmt "$HOME/.local/bin/yamlfmt"
```

Node tools:

```bash
sudo npm install -g prettier prettierd
```

Rust tools:

```bash
cargo install --locked stylua
```

Optional Rust formatter when `rustup` is available:

```bash
rustup component add rustfmt
```

Go linter:

```bash
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
  | sh -s -- -b "$HOME/.local/bin" latest
```

Neovim-managed tools:

```bash
nvim --headless \
  "+Lazy! sync" \
  "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx bashls" \
  "+TSUpdate" \
  "+qa"
```

## Oracle Linux 9 Install Commands

Oracle Linux 9 needs Oracle's EPEL compatibility package first so packages like
`fzf`, `ripgrep`, `cppcheck`, and `shellcheck` are available through `dnf`.

System packages:

```bash
sudo dnf install -y oracle-epel-release-el9
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
```

Python tools:

```bash
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi mdformat mdformat-gfm
```

YAML formatter:

```bash
mkdir -p "$HOME/.local/bin"
yamlfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/google/yamlfmt/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
yamlfmt_version_no_v="${yamlfmt_version#v}"
curl -fsSL "https://github.com/google/yamlfmt/releases/download/${yamlfmt_version}/yamlfmt_${yamlfmt_version_no_v}_Linux_x86_64.tar.gz" -o /tmp/yamlfmt.tar.gz
tar -xzf /tmp/yamlfmt.tar.gz -C /tmp
install -m 0755 /tmp/yamlfmt "$HOME/.local/bin/yamlfmt"
```

Shell formatter:

```bash
mkdir -p "$HOME/.local/bin"
shfmt_version="$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen('https://api.github.com/repos/mvdan/sh/releases/latest', timeout=20) as response:
    print(json.load(response)['tag_name'])
PY
)"
curl -fsSL "https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_linux_amd64" -o /tmp/shfmt
install -m 0755 /tmp/shfmt "$HOME/.local/bin/shfmt"
```

Node tools:

```bash
sudo npm install -g prettier prettierd
```

Rust tools:

```bash
cargo install --locked stylua
```

Optional Rust formatter when `rustup` is available:

```bash
rustup component add rustfmt
```

Go linter:

```bash
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
  | sh -s -- -b "$HOME/.local/bin" latest
```

Neovim-managed tools:

```bash
nvim --headless \
  "+Lazy! sync" \
  "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx bashls" \
  "+TSUpdate" \
  "+qa"
```

## Manual Step: Nerd Font

This config uses icon-heavy plugins, so a Nerd Font is recommended.

Examples:

- IntelOneMono Nerd Font
- JetBrainsMono Nerd Font

Install the font manually through your desktop environment or preferred font
management tool, then configure your terminal to use it.
