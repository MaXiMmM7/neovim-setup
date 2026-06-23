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
| Neovim 0.12+ | current `nvim-treesitter` `main` branch and this config | upstream release on Ubuntu 24.04 | Yes |
| `git` | `lazy.nvim` bootstrap and `gitsigns` features | apt / dnf | Yes |
| `curl`, `wget`, `unzip`, `tar`, `gzip`, `ca-certificates` | download helpers and install scripts | apt / dnf | Yes |
| `fzf` | `fzf-lua` picker backend | apt / dnf | Yes |
| `ripgrep` | `fzf-lua` grep/search commands | apt / dnf | Yes |
| `fd` / `fd-find` | fast file finding for editor tooling | apt / dnf | Recommended |
| C/C++ build toolchain | compile Tree-sitter parsers, build native tooling | apt / dnf | Yes |
| `pkg-config` | native build helper used by some compiled tools | apt / dnf | Recommended |
| `tree-sitter` CLI 0.26.1+ | install and generate Tree-sitter parsers | upstream release on Ubuntu 24.04 | Yes |
| `clangd` | C/C++ LSP | apt / dnf | Yes |
| `clang-format` | C/C++ formatting | apt / dnf | Yes |
| `cppcheck` | C/C++ linting | apt / dnf | Yes |
| `cmake` | CMake project tooling and local configure/build workflows | apt / dnf | Recommended for CMake |
| `jq` | JSON formatting through conform.nvim | apt / dnf | Yes for JSON |
| `python3`, `python3-pip`, `python3-venv`, `python3-pynvim`, `pipx` | Python tooling, Neovim Python client, isolated CLI installs, and `json.tool` validation | apt / dnf | Yes |
| `pylint` | Python linting | pipx / pip | Yes for Python |
| `black`, `isort` | Python formatting | pipx / pip | Yes for Python |
| `gersemi` | CMake formatting through conform.nvim | pipx / pip | Yes for CMake |
| `mdformat`, `mdformat-gfm` | Markdown formatting through conform.nvim | pipx / pip | Yes for Markdown |
| `shellcheck` | Shell linting through nvim-lint | apt / dnf | Yes for shell |
| `shfmt` | Shell formatting through conform.nvim | apt / dnf or release binary | Yes for shell |
| `yamllint` | YAML linting | pipx / pip | Yes for YAML |
| `yamlfmt` | YAML formatting through conform.nvim | release binary | Yes for YAML |
| `libxml2-utils` or `libxml2` | provides `xmllint` for XML linting | apt / dnf | Yes for XML |
| `nodejs`, `npm` | Mason npm-based LSP servers and JS formatters | apt / dnf | Yes |
| `prettier` or `prettierd` | JavaScript formatting | npm | Yes for JS |
| `go` / `golang-go` | Go toolchain used by Go projects and Go linting workflows | apt / dnf | Yes for Go |
| `cargo` | Rust linting entrypoint and Rust tooling | apt / dnf | Yes |
| `rustfmt` | Rust formatting | rustup or distro package | Yes for Rust |
| `stylua` | Lua formatting | release binary / cargo | Yes for Lua |
| `golangci-lint` | Go linting | upstream install script | Yes for Go |
| `wl-clipboard`, `xclip` | clipboard integration on Wayland and X11 | apt / dnf | Recommended |
| Nerd Font | icons in statusline, bufferline, file pickers, markdown render | manual | Recommended |

Ubuntu 24.04 notes:

- Ubuntu 24.04 provides `neovim` 0.9.5, but current `nvim-treesitter` `main`
  requires Neovim 0.12+. The Ubuntu script installs the latest upstream Neovim
  release into `~/.local/opt/nvim` and symlinks `~/.local/bin/nvim` when needed.
- Ubuntu 24.04 provides `tree-sitter-cli` 0.20.x, but current
  `nvim-treesitter` `main` requires `tree-sitter` 0.26.1+. The Ubuntu script
  installs the latest upstream `tree-sitter` binary into `~/.local/bin` when
  needed.
- Ubuntu names the `fd` binary `fdfind`; the Ubuntu script creates a local
  `~/.local/bin/fd` symlink when needed.
- Ubuntu 24.04 blocks direct global/user `pip` installs in many cases, so the
  Ubuntu script installs Python CLI tools with `pipx`.

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
```

Ubuntu 24.04 version-sensitive tools:

```bash
mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"

# Tree-sitter CLI, x86_64 example. Use tree-sitter-linux-arm64.gz on arm64.
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz -o /tmp/tree-sitter.gz
gunzip -c /tmp/tree-sitter.gz > /tmp/tree-sitter
install -m 0755 /tmp/tree-sitter "$HOME/.local/bin/tree-sitter"

# Neovim, x86_64 example. Use nvim-linux-arm64.tar.gz on arm64.
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
tar -xzf /tmp/nvim.tar.gz -C /tmp
rm -rf "$HOME/.local/opt/nvim"
mv /tmp/nvim-linux-x86_64 "$HOME/.local/opt/nvim"
ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
```

Python tools:

```bash
pipx install pylint
pipx install black
pipx install isort
pipx install yamllint
pipx install gersemi
pipx install mdformat
pipx inject mdformat mdformat-gfm
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

Lua formatter:

```bash
# x86_64 example. Use stylua-linux-aarch64.zip on arm64.
curl -fsSL https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip -o /tmp/stylua.zip
unzip -q /tmp/stylua.zip -d /tmp/stylua
install -m 0755 /tmp/stylua/stylua "$HOME/.local/bin/stylua"
```

Rust formatter when `rustup` is available and shadows the distro `rustfmt`:

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
  "+lua require('nvim-treesitter').install({ 'c', 'cpp', 'go', 'bash', 'lua', 'vim', 'vimdoc', 'elixir', 'javascript', 'html', 'python', 'typescript', 'markdown', 'markdown_inline', 'latex', 'yaml', 'cmake' }):wait(300000)" \
  "+lua require('nvim-treesitter').update():wait(300000)" \
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
