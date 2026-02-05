# Neovim Is All You Need

## Introduction

This project provides a **minimalist, dependency-free Neovim configuration** for systems programming (C/C++, Rust).

Unlike modern "batteries-included" distributions, this setup **rejects package managers** (like lazy.nvim or packer) in favor of **Git Submodules** and native `runtimepath` management. It is designed to give the user full control over the editor environment.

> ⚠️ **Toolchain Requirement**
> This configuration is strictly optimized for the **LLVM Ecosystem**.
> It enforces `clang` for building and `lldb` for debugging to ensure 100% compatibility with `clangd`.

---

## Setup & Requirements

- **OS**: Linux / macOS
- **Editor**: Neovim 0.11.0+
- **Toolchain**: LLVM (`clang`, `clang++`, `lldb`)
- **Build System**: CMake or Makefiles(with compilation-database generator like bear for indexing.)

---

## Overview

Workflow:

1. Clone the repository to the config directory
2. Initialize Git submodules (plugins)
3. Run `sh install_codelldb.sh`.
4. Configure the project using Clang
5. Generate `compile_commands.json`
6. Develop with full LSP & DAP support

---

## 1. Installation

This repository replaces your `~/.config/nvim`.

### Clone & Initialize
Since plugins are managed as submodules, you must clone recursively or initialize them after cloning.

```bash
# Clone to local config
git clone [https://github.com/UsQuake/neovim_is_all_you_need](https://github.com/UsQuake/neovim_is_all_you_need) ~/.config/nvim

# Initialize and fetch all plugins (submodules)
cd ~/.config/nvim
git submodule update --init --recursive

# 4. Install CodeLLDB Adapter (No sudo required)
sh install_codelldb.sh
```

---

## 2. The Toolchain Philosophy (Why LLVM?)

This setup intentionally avoids mixing GCC with `clangd`.

### The Problem: GCC + Clangd
Using `clangd` (LSP) while building with GCC often leads to:
1.  **Header Parsing Errors**: `clangd` fails to understand GCC-specific system header paths.
2.  **Flag Mismatches**: GCC flags that are invalid in Clang cause false-positive diagnostics.
3.  **Broken Intellisense**: The editor shows errors even if the code compiles fine.

### The Solution: "Build with Clang, Debug with LLDB"
By forcing the build pipeline to use Clang, the `compile_commands.json` becomes native to the LSP server.
- **LSP**: `clangd` reads flags intended for `clang`, ensuring 100% accurate diagnostics.
- **Debugger**: Binaries built with Clang contain DWARF info best understood by `lldb`. This config uses `nvim-dap` configured for `codelldb`/`lldb`.

---

## 3. Project Configuration

To make this setup work, you **must** generate the compilation database using Clang.

### CMake Example
Do not use `gcc`. Explicitly set the compilers to `clang` and `clang++`.

```bash
# Generate build files with Clang
cmake -S . -B build \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1

# Link the compilation database to root
ln -sf build/compile_commands.json .
```

### Option B: Makefile (via Bear)
If you use raw `Makefiles`, use [Bear](https://github.com/rizsotto/Bear) to intercept build commands.

```bash
# 1. Clean previous build
make clean

# 2. Generate compile_commands.json using Bear
# Note: Ensure your Makefile uses clang/clang++ (e.g., CC=clang CXX=clang++)
bear -- make
```

## Directory Structure

Plugins are located in the native Neovim pack directory, loaded automatically on startup.

```text
~/.config/nvim/
├── init.lua
├── install_codelldb.sh  # Downloader script
├── codelldb/            # (Generated) Debugger binary (Ignored by Git)
├── lua/
│   ├── config/      # Keymaps, Options
│   └── plugins/     # LSP & DAP Setup
└── pack/plugins/start/
    ├── nvim-treesitter
    ├── nvim-dap
    ├── nvim-dap-ui
    ├── nvim-nio
    └── nvim-dap-virtual-text
```

## References

- Neovim Git Submodule Guide
  https://github.com/neovim/neovim
- Clangd Installation & Setup
  https://clangd.llvm.org/
- Bear (Build EAR)
  https://github.com/rizsotto/Bear
- Microsoft Debug Adapter Protocol
  https://microsoft.github.io/debug-adapter-protocol/
