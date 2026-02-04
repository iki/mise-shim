# mise-shim<!-- omit in toc -->

Executable Windows shim for [mise](https://mise.jdx.dev) tools.

Fully usable prove-of-concept, ready for use in local dev env.

Based on [@daief](https://github.com/daief) solution for [node shim issues](https://github.com/jdx/mise/discussions/4773#discussioncomment-13304766)

## Content<!-- omit in toc -->

- [Purpose](#purpose)
- [How It Works](#how-it-works)
- [Getting Started](#getting-started)
- [Build the shim](#build-the-shim)
- [Usage](#usage)
- [Technical Details](#technical-details)
- [License](#license)

## Purpose

Current cmd/bash shims in mise have several issues:

- Globally installed bun packages [need](https://github.com/jdx/mise/discussions/5521#discussioncomment-15691333) `bun.exe` in PATH
- Spawning tools like Node from JavaScript has to be updated with [`{ shell: true }`](https://github.com/jdx/mise/discussions/4773#discussioncomment-15098195) to work with cmd/bash shims
- Calling tools from cmd scripts has to be updated to use `call` to work with cmd/bash shims, otherwise the script will exit after the tool is called
- There may be many other cases where the tool executables are expected to be in PATH, which is their default installation mode

Executable shims are battle tested practice on Windows. They are used for example by [Bun](https://github.com/oven-sh/bun/blob/main/src/install/windows-shim/bun_shim_impl.zig), [Volta](https://github.com/volta-cli/volta/issues/1135#issuecomment-1016790857), and [Chocolatey](https://docs.chocolatey.org/en-us/features/shim/).

## How It Works

The shim uses its own filename (without `.exe`) to determine which tool to execute:

1. When you run `node.exe`, the shim detects it should run `node`
2. It invokes `mise x -- node <args>` to execute the tool in mise's environment
3. All command-line arguments and exit codes are forwarded transparently

## Getting Started

1. **Install [Rust](https://www.rust-lang.org/tools/install) and [UPX](https://upx.github.io) via mise**:

   ```cmd
   mise use -g rust upx
   ```

2. **Install [Visual Studio C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)**:

   **Option A: Using [Chocolatey](https://community.chocolatey.org/packages/visualstudio2026-workload-vctools)** (recommended):

   ```cmd
   choco install visualstudio2022-workload-vctools --package-parameters "--includeRecommended"
   ```

   **Option B: Manual installation**:
   - Download from: https://aka.ms/vs/stable/vs_BuildTools.exe
   - Run the installer and select "Desktop development with C++"

## Build the shim

Run the [`build.cmd`](./build.cmd) script:

```cmd
build.cmd
```

Build script will perform the following steps:

1. Initialize the Visual Studio build environment using [vc.cmd](./vc.cmd)
2. Compile the Rust code in size-optimized portable [release mode](./Cargo.toml)
3. Compress the executable with [UPX](https://upx.github.io)
4. Output the final `mise-shim.exe`

## Usage

Run the [`reshim.cmd`](./reshim.cmd) script to create executable shims for all mise tools:

```cmd
reshim.cmd
```

After rebuild, use `-f` option to update existing executable shims:

```cmd
reshim.cmd -f
```

Use `-h` option for help:

```
Usage: reshim [options] [shims-path=%LocalAppData%\mise\shims]

Copy executable shim `mise-shim.exe` to .exe shim in mise shim-path
for all .cmd shims that do not already have .exe shim there

Remove all existing .exe shims in mise shim-path
that do not have matching .cmd shim there (were uninstalled)

Options:
  -f       Overwrite existing .exe shims. Use after rebuild.
  -h       Show this help and exit
```

## Technical Details

- **Language**: Rust
- **Target**: Windows only (`x86_64-pc-windows-msvc`)
- **Size**: 84 KB, which could be improved, [Bun shims](https://github.com/oven-sh/bun/blob/main/src/install/windows-shim/bun_shim_impl.zig) have 15 KB (7 KB compressed)

## License

MIT License, see [`LICENSE.md`](./LICENSE.md) for details.
