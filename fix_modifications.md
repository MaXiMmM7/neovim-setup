## 1. `cppcheck`

> [!WARNING]
> **Problem**
>
> `cppcheck` reported `Include file: <iostream> not found` with the diagnostic
> ID `missingIncludeSystem`, even though the program compiled and ran
> correctly.
>
> This message was informational noise, not a real compiler failure, because
> `cppcheck` does not parse the C++ standard library the same way as the actual
> compiler toolchain.

> [!TIP]
> **Fix**
>
> `/home/max/.config/nvim/lua/preconf/lazy_plugins/linter.lua` was updated so
> Neovim runs `cppcheck` with `--suppress=missingIncludeSystem`.
>
> That removes the false standard-library include warning while still keeping
> useful `warning`, `style`, and `performance` diagnostics.

## 2. `clangd`

> [!WARNING]
> **Problem**
>
> `clangd` had no `compile_commands.json` for standalone `.cpp` files, so it
> used a fallback command based on `clang` instead of the real system compiler.
>
> On this machine, the system C++ compiler is `/usr/bin/c++`, which resolves to
> GCC 13.3.0, but raw `clang` auto-detected the newest installed GCC toolchain
> and selected GCC 14.
>
> That failed because the fallback `clang` setup did not line up with the
> actual system C++ standard library in use, so `<iostream>` was not resolved
> and many `std::...` symbols became false diagnostics inside Neovim.

> [!TIP]
> **Fix**
>
> `/home/max/.config/clangd/config.yaml` was created with
> `CompileFlags: Compiler: /usr/bin/c++`.
>
> `/home/max/.config/nvim/lua/preconf/setup_plugins.lua` was also updated to
> start `clangd` with `--enable-config` and an expanded `--query-driver` list,
> so `clangd` now follows the real system compiler and extracts the correct GCC
> 13 include paths.
