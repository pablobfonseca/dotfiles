# @pablobfonseca's dotfiles

> If I had eight hours to chop down a tree, I'd spend six sharpening my axe --
> Abraham Lincoln

## What's Inside

| Category | Tool | Config |
|----------|------|--------|
| **Shell** | zsh + starship prompt | `zsh/`, `starship/` |
| **Editor** | Neovim (lazy.nvim) | `nvim/` |
| **Terminal** | Ghostty, Alacritty, WezTerm | `ghostty/`, `alacritty/`, `wezterm/` |
| **Multiplexer** | tmux + tpm | `tmux/`, `tmuxinator/` |
| **Window Manager** | AeroSpace | `aerospace/` |
| **Git** | git + lazygit + delta | `git/`, `lazygit/` |
| **AI** | Claude Code, Codex | `claude/`, `codex/` |
| **macOS** | Hammerspoon, Karabiner | `hammerspoon/`, `karabiner/` |
| **File Manager** | yazi | `yazi/` |
| **Utilities** | bat, btop, atuin, fzf | `bat/`, `btop/`, `atuin/` |
| **Packages** | Homebrew Bundle | `homebrew/Brewfile` |
| **Scripts** | tmux helpers, Obsidian, utils | `scripts/` |
| **Stream Deck** | DevDeck | `devdeck/` |

## Theme

**Cyberpunk Storm** across the stack:

- Neovim, tmux, Ghostty, starship prompt, Claude Code powerline
- Alacritty, WezTerm, lazygit use **Tokyo Night** as secondary theme
- Fonts: **IosevkaTerm Nerd Font** (terminals) / **JetBrainsMono Nerd Font** (Alacritty)

## Neovim

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

**Key plugins:** telescope.nvim, oil.nvim, mason.nvim, conform.nvim, nvim-cmp, gitsigns.nvim, vim-fugitive, nvim-dap (Go debugging), lualine.nvim, which-key.nvim, obsidian.nvim, kulala.nvim (REST client)

**LSP:** TypeScript, Go, Python, Lua, Swift via Mason

## tmux

Prefix: `C-a` | Vi mode | [Cyberpunk theme](https://github.com/pablobfonseca/cyberpunk-theme)

**Key bindings:**
- `C-g` lazygit | `C-f` file picker | `M-g` scratch terminal
- `C-M-h/l` window navigation
- tmux-sessionx for session picker, tmux-floax for floating windows

## Claude Code

22 specialized agents (language + role-based), 13 plugins (4 LSP servers, superpowers, frontend-design, dev-browser, ast-grep, reflexion), auto-format hooks for TypeScript.

## Codex

Best-practice Codex setup with global `AGENTS.md`, conservative CLI defaults, focused reusable skills, GitHub plugin enabled, and narrow custom agents for review-oriented work.

## Shell

zsh with fzf (fd + bat previews), atuin for history sync, zoxide for navigation. Language tooling: Go, Node (nvm), Ruby (rvm), Python, Rust, Flutter.

## Install

Using the [dotfiles-installer](https://github.com/pablobfonseca/dotfiles-installer) CLI (Go):

```sh
# Install everything
dotfiles-installer install

# Interactive mode — pick which tools to set up
dotfiles-installer install -i

# Install a specific tool
dotfiles-installer install nvim

# Check what's installed
dotfiles-installer status

# Preview without executing
dotfiles-installer install -n
```

The installer clones this repo to `~/.dotfiles`, creates symlinks to `~/.config/` and `~/`, and optionally runs `brew bundle` for dependencies.

**Managed tools:** Homebrew, Neovim, zsh, git, tmux, starship, Ghostty, Karabiner, Cyberpunk Theme
