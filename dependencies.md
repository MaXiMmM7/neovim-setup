# Neovim Dependencies

This document lists the external tools used by the Neovim config in this
directory, what each tool is used for, and how to install them on Ubuntu-like
and Fedora-like systems.

Use the distro-specific scripts in this directory for a mostly automatic setup:

- `./install_dependencies_ubuntu.sh`
- `./install_dependencies_fedora.sh`

## Validation In Neovim

For syntax validation and diagnostics, the config now uses both LSP and
`nvim-lint`.

- `json`: `jsonls` plus `json_tool`
- `yaml` / `yml`: `yamlls` plus `yamllint`
- `xml`: `lemminx` plus `xmllint`

For CMake editing, the config uses:

- `cmake`: `neocmake` for LSP/linting plus `gersemi` for formatting

Useful keys already configured:

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
| `python3`, `python3-pip` | Python tooling and `json.tool` validation | apt / dnf | Yes |
| `pylint` | Python linting | pip | Yes for Python |
| `black`, `isort` | Python formatting | pip | Yes for Python |
| `gersemi` | CMake formatting through conform.nvim | pip | Yes for CMake |
| `yamllint` | YAML linting | pip | Yes for YAML |
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

Note: this config hardcodes `/usr/bin/clangd` for C/C++, so a system-installed
`clangd` is still required even though Mason also tracks `clangd`.

For CMake specifically, `neocmake` provides completions, navigation, hover,
rename, and diagnostics, while `gersemi` is the primary formatter used by
`<leader>f`.

## Ubuntu-Like Install Commands

System packages:

```bash
sudo apt update
sudo apt install -y \
  git curl wget unzip tar gzip \
  fzf ripgrep \
  build-essential \
  cmake \
  clangd clang-format cppcheck \
  libxml2-utils \
  python3 python3-pip \
  nodejs npm \
  cargo
```

Python tools:

```bash
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi
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
  "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx" \
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
  clang-tools-extra cppcheck \
  libxml2 \
  python3 python3-pip \
  nodejs npm \
  cargo
```

Python tools:

```bash
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pylint black isort yamllint gersemi
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
  "+MasonInstall clangd neocmake lua_ls ty postgres_lsp jsonls yamlls lemminx" \
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
