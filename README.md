# Systems Hacker Neovim Setup — Usage Guide

This guide covers how to use every feature in this Neovim configuration for systems programming in C, Rust, and Python.

---

## Table of Contents

- [First Launch](#first-launch)
- [Leader Key](#leader-key)
- [File Navigation](#file-navigation)
- [Search](#search)
- [LSP (Code Intelligence)](#lsp-code-intelligence)
- [Autocomplete](#autocomplete)
- [Formatting](#formatting)
- [Debugging (C / Rust)](#debugging-c--rust)
- [Git](#git)
- [Terminal Multiplexer (tmux)](#terminal-multiplexer-tmux)
- [Keymap Reference](#keymap-reference)
- [Troubleshooting](#troubleshooting)

---

## First Launch

Open Neovim and sync all plugins:

```bash
nvim
```

Inside Neovim, run:

```vim
:Lazy sync
```

This installs and updates all plugins. Wait for it to finish, then restart Neovim.

---

## Leader Key

The **leader key** is `Space`. All custom keymaps start with it.

The **local leader** is `,`.

When this guide says `<leader>`, press `Space`.

---

## File Navigation

### File Explorer (nvim-tree)

| Action | Key |
|--------|-----|
| Toggle file explorer | `<leader>e` |

Inside the explorer:
- `Enter` — open file
- `a` — create new file
- `d` — delete file
- `r` — rename file
- `q` — close explorer

### Fuzzy Finder (Telescope)

| Action | Key |
|--------|-----|
| Find files by name | `<leader>ff` |
| Search text in all files | `<leader>fg` |

Inside Telescope:
- Type to filter results
- `Enter` — open selected file
- `Ctrl+n` / `Ctrl+p` — move up/down
- `Esc` — close

---

## Search

### Search across a project

```
<leader>fg
```

This uses `ripgrep` under the hood. Type your search term and results appear live.

### Search for a file

```
<leader>ff
```

Uses `fd` for fast file discovery. Start typing any part of the filename.

---

## LSP (Code Intelligence)

LSP servers are configured for three languages:

| Language | Server |
|----------|--------|
| C / C++ | `clangd` |
| Rust | `rust-analyzer` |
| Python | `pyright` |

### What LSP gives you

- **Go to definition** — `gd` (cursor on a symbol, press `gd`)
- **Go to declaration** — `gD`
- **Hover documentation** — `K` (press `K` over a function/type)
- **Signature help** — `Ctrl+k` (in insert mode)
- **Rename symbol** — `grn`
- **Code actions** — `gra`
- **References** — `grr`
- **Diagnostics (errors/warnings)** — shown inline automatically

### C/C++ workflow

Make sure you have a `compile_commands.json` in your project root. Generate one with:

```bash
# Using Make
bear -- make

# Using CMake
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
ln -s build/compile_commands.json .
```

Then open any `.c` or `.h` file — `clangd` will start automatically.

### Rust workflow

Just open any file in a Cargo project (a directory with `Cargo.toml`). `rust-analyzer` starts automatically.

### Python workflow

Open any `.py` file. `pyright` starts automatically. For best results, use a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

---

## Autocomplete

Autocomplete pops up automatically as you type (powered by `nvim-cmp` + LSP).

| Action | Key |
|--------|-----|
| Trigger completion manually | `Ctrl+Space` |
| Confirm selection | `Enter` |
| Navigate suggestions | `Ctrl+n` / `Ctrl+p` |

---

## Formatting

Files are **auto-formatted on save**. The formatters are:

| Language | Formatter |
|----------|-----------|
| C / C++ | `clang-format` |
| Rust | `rustfmt` |
| Python | `black` |
| Lua | `stylua` |

### Manual format

```
<leader>cf
```

### Customizing C/C++ format

Create a `.clang-format` file in your project root:

```yaml
BasedOnStyle: LLVM
IndentWidth: 4
ColumnLimit: 80
```

### Customizing Rust format

Create `rustfmt.toml` in your project root:

```toml
edition = "2021"
tab_spaces = 4
```

---

## Debugging (C / Rust)

The debugger uses `lldb-dap` (LLVM's debug adapter) through `nvim-dap`.

### Step 1: Compile with debug symbols

**C:**
```bash
clang -g -O0 main.c -o main
```

**Rust:**
```bash
cargo build
```
(Debug symbols are included by default in debug builds.)

### Step 2: Set breakpoints

Open the source file in Neovim and place your cursor on the line where you want to break, then:

```
<leader>db
```

A red dot appears in the gutter. Press `<leader>db` again to remove it.

### Step 3: Start the debugger

```
<leader>dc
```

You'll be prompted for the path to the executable:
- For C: enter something like `./main`
- For Rust: enter something like `./target/debug/myproject`

### Step 4: Debug controls

| Action | Key |
|--------|-----|
| Continue / Start | `<leader>dc` |
| Step over (next line) | `<leader>do` |
| Step into (enter function) | `<leader>di` |
| Toggle breakpoint | `<leader>db` |
| Open REPL | `<leader>dr` |
| Toggle debug UI | `<leader>dt` |

### The Debug UI

When debugging starts, `nvim-dap-ui` opens automatically showing:
- **Variables** — local and watch variables
- **Call stack** — current function call chain
- **Breakpoints** — list of all breakpoints
- **REPL** — evaluate expressions live

Toggle it manually with `<leader>dt`.

### Full C debug example

```bash
# Terminal: compile
clang -g -O0 main.c -o main
```

```
# Neovim:
1. Open main.c
2. Go to a line, press <leader>db (set breakpoint)
3. Press <leader>dc (start debugger)
4. Enter: ./main
5. Execution stops at breakpoint
6. Press <leader>do to step, <leader>di to go into functions
7. Check variables in the debug UI panel
```

### Full Rust debug example

```bash
# Terminal: compile
cargo build
```

```
# Neovim:
1. Open src/main.rs
2. Set breakpoint: <leader>db
3. Start debugger: <leader>dc
4. Enter: ./target/debug/projectname
5. Step through code with <leader>do and <leader>di
```

---

## Git

### Lazygit (terminal UI)

From inside Neovim:

```
<leader>gg
```

This opens `lazygit` — a full terminal UI for Git. Inside lazygit:
- `Space` — stage/unstage file
- `c` — commit
- `P` — push
- `p` — pull
- `q` — quit back to Neovim

### Basic Git from terminal

```bash
git add .
git commit -m "message"
git push
```

---

## Terminal Multiplexer (tmux)

tmux lets you split your terminal into panes and keep sessions alive.
A custom `~/.tmux.conf` is included — the prefix is `Tab` and all bindings are Mac/Vim friendly.

### Start a new session

```bash
tmux new -s dev
```

### Key bindings (prefix is Tab)

Press `Tab` first, release, then press the second key.

**Splits:**

| Action | Keys |
|--------|------|
| Split below | `Tab -` |
| Split right | `Tab \|` |

**Pane navigation (vim-style):**

| Action | Keys |
|--------|------|
| Move left | `Tab h` |
| Move down | `Tab j` |
| Move up | `Tab k` |
| Move right | `Tab l` |

**Pane resizing (repeatable):**

| Action | Keys |
|--------|------|
| Resize left | `Tab H` |
| Resize down | `Tab J` |
| Resize up | `Tab K` |
| Resize right | `Tab L` |

**Windows:**

| Action | Keys |
|--------|------|
| New window | `Tab c` |
| Next window | `Tab n` |
| Previous window | `Tab p` |

**Sessions:**

| Action | Keys |
|--------|------|
| Detach session | `Tab d` |
| List sessions | `tmux ls` |
| Reattach | `tmux attach -t dev` |

**Copy mode (vim-style):**

| Action | Keys |
|--------|------|
| Enter copy mode | `Tab v` |
| Start selection | `v` (in copy mode) |
| Copy to clipboard | `y` (in copy mode) |

**Other:**

| Action | Keys |
|--------|------|
| Close pane | `Tab x` |
| Close window | `Tab X` |
| Reload config | `Tab r` |
| Send actual Tab key | `Tab Tab` |

Mouse is enabled — you can click panes, resize by dragging borders, and scroll.

### Recommended layout

```
+------------------+------------------+
|                  |                  |
|    Neovim        |    Terminal      |
|                  |    (build/run)   |
|                  |                  |
+------------------+------------------+
```

```bash
tmux new -s dev
# Opens in first pane — start Neovim
nvim .
# Tab | to split right, use that pane for compiling/running
```

---

## Keymap Reference

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text) |
| `<leader>w` | Save file |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start / continue debug |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dr` | Open debug REPL |
| `<leader>dt` | Toggle debug UI |
| `<leader>cf` | Format file |
| `<leader>gg` | Open lazygit |
| `gd` | Go to definition (LSP) |
| `gD` | Go to declaration (LSP) |
| `K` | Hover docs (LSP) |
| `grn` | Rename symbol (LSP) |
| `gra` | Code actions (LSP) |
| `grr` | Find references (LSP) |

---

## Troubleshooting

### Plugins not loading

```vim
:Lazy sync
```

Then restart Neovim.

### LSP not starting

Check health:

```vim
:checkhealth lsp
```

Make sure the language server is installed and in your PATH:

```bash
which clangd
which rust-analyzer
which pyright
```

### Debugger not working

Verify `lldb-dap` is accessible:

```bash
/opt/homebrew/opt/llvm/bin/lldb-dap --version
```

Make sure you compiled with debug symbols (`-g` flag for C).

### Treesitter errors

Update parsers:

```vim
:TSUpdate
```

### Check overall health

```vim
:checkhealth
```

---

## Installed Stack

| Component | Tool |
|-----------|------|
| Editor | Neovim 0.11+ |
| Plugin manager | lazy.nvim |
| Theme | catppuccin |
| File explorer | nvim-tree |
| Fuzzy finder | telescope + ripgrep + fd |
| Syntax | treesitter |
| LSP | clangd, rust-analyzer, pyright |
| Autocomplete | nvim-cmp |
| Debugger | nvim-dap + lldb-dap |
| Formatter | conform.nvim (clang-format, rustfmt, black, stylua) |
| Status line | lualine |
| Git | lazygit |
| Terminal | tmux |
