# @pablobfonseca's dotfiles

> If I had eight hours to chop down a tree, I'd spend six sharpening my axe --
> Abraham Lincoln

## What's Inside

| Category           | Tool                           | Config                               |
| ------------------ | ------------------------------ | ------------------------------------ |
| **Shell**          | zsh + starship prompt          | `zsh/`, `starship/`                  |
| **Editor**         | Neovim (lazy.nvim)             | `nvim/`                              |
| **Terminal**       | Ghostty, Alacritty, WezTerm    | `ghostty/`, `alacritty/`, `wezterm/` |
| **Multiplexer**    | tmux + tpm                     | `tmux/`, `tmuxinator/`               |
| **Window Manager** | AeroSpace                      | `aerospace/`                         |
| **Git**            | git + lazygit + delta          | `git/`, `lazygit/`                   |
| **AI**             | Claude Code, Codex, Gemini CLI | `claude/`, `codex/`, `gemini/`       |
| **macOS**          | Hammerspoon, Karabiner         | `hammerspoon/`, `karabiner/`         |
| **File Manager**   | yazi                           | `yazi/`                              |
| **Utilities**      | bat, btop, atuin, fzf          | `bat/`, `btop/`, `atuin/`            |
| **Packages**       | Homebrew Bundle                | `homebrew/Brewfile`                  |
| **Scripts**        | tmux helpers, Obsidian, utils  | `scripts/`                           |
| **Stream Deck**    | DevDeck                        | `devdeck/`                           |

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

22 specialized agents (language + role-based), 13 plugins (4 LSP servers, superpowers, frontend-design, dev-browser, ast-grep, reflexion), auto-format hooks for TypeScript. `claude/hooks/survival-list.sh` runs on `PreCompact` and on `SessionStart` after a compaction: in an `/implement-plan` session it tells the summary what to keep and prints the plan, the open task, the branch, the PR and the plan's stop-and-ask list into the new context; `claude/hooks/check-survival.sh` is its test.

User-scope MCP servers live in `~/.claude.json` (runtime state, not versioned). On a new machine:

```bash
claude mcp add --scope user metabase --transport http https://metabase.tribemap.ai/api/metabase-mcp
claude mcp add --scope user chrome-devtools -- npx chrome-devtools-mcp@latest
```

The status line runs `claude-cyberpunk-powerline` from `~/.local/bin` rather than through `npx`, so install it once per machine (and again if the status line goes blank):

```bash
npm install -g --prefix ~/.local @pablobfonseca/claude-cyberpunk-powerline
```

## Codex

Codex is an oracle here, not a job runner: `/ask-codex`, and `/fable-plan`'s `--council` and `--critics`, consult it read-only (`claude/docs/oracle-agents.md`). The setup is a global `AGENTS.md`, conservative CLI defaults in `config.toml`, and the general skills under `skills/` (codebase-design, diagnosing-bugs, domain-modeling, front-end-testing, functional, handoff, neovim-lua, typescript-strict), copies of their `claude/skills/` originals where one exists. `rules/default.rules` lets `gh` run without an approval prompt. Codex finds each skill and the rules file through a symlink in `~/.codex/` (`~/.codex/skills/<name>`, `~/.codex/rules/default.rules`), made by hand on each machine. Merge any local `~/.codex/rules/default.rules` into the dotfiles copy first, since `-f` replaces it; `-n` keeps a rerun from nesting a link inside an existing skill directory. The queue command copies, the custom agents and the claudeos hook registrations went with the Codex executor (ClaudeOS q424).

```bash
mkdir -p ~/.codex/skills ~/.codex/rules
for s in ~/.dotfiles/codex/skills/*/; do ln -sfn "${s%/}" ~/.codex/skills/"$(basename "$s")"; done
ln -sfn ~/.dotfiles/codex/rules/default.rules ~/.codex/rules/default.rules
```

## Gemini CLI

`~/.gemini/settings.json` is a symlink into `gemini/` and carries only the auth choice. Gemini is an oracle like Codex (`/ask-gemini`, `--council`, `--critics`); its command copies, agents and claudeos hook registrations went with the Gemini executor (ClaudeOS q424).

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
