local utils = require "pablobfonseca.utils"

-- Files
vim.api.nvim_create_user_command("Files", function(opts)
  if vim.fn.executable "fzf" ~= 1 then
    return vim.notify("fzf not found on PATH", vim.log.levels.ERROR)
  end

  local arg = vim.trim(opts.args or "")
  local root

  if arg ~= "" then
    local expanded = vim.fn.fnamemodify(vim.fn.expand(arg), ":p")
    if vim.fn.isdirectory(expanded) == 1 then
      root = expanded
    elseif vim.fn.filereadable(expanded) == 1 then
      root = vim.fn.fnamemodify(expanded, ":p:h")
    else
      return vim.notify("Files: path not found -> " .. arg, vim.log.levels.WARN)
    end
  else
    ---@diagnostic disable-next-line: undefined-field
    root = vim.loop.cwd()
  end

  local filelist

  if vim.fn.executable "fd" == 1 then
    -- fd is fast and prints paths relative to cwd with --strip-cwd-prefix
    local _, out, err = utils.run({ "fd", "-t", "f", "-H", "-E", ".git", "--strip-cwd-prefix" }, { cwd = root })
    if out == "" then
      return vim.notify("fd: no files.\n" .. (err or ""), vim.log.levels.INFO)
    end
    filelist = out
  end

  local has_bat = vim.fn.executable "bar" == 1
  local preview_cmd = has_bat and "bat -n --color=always --line-range :300 {}"
    or "sed -n '1,200p' -- {} 2>/dev/null || head -n 200 -- {}"

  local fzf_args = {
    "fzf",
    "--ansi",
    "--multi",
    "--prompt=Files> ",
    "--expect=ctrl-v,ctrl-x,ctrl-t",
    "--preview",
    preview_cmd,
    "--bind",
    "alt-j:preview-down,alt-k:preview-up,alt-u:preview-page-up,alt-d:preview-page-down,alt-p:toggle-preview",
    "--tmux",
  }

  local code, out, _ = utils.run(fzf_args, { stdin = filelist, cwd = root })
  if code ~= 0 or out == "" then
    return
  end

  local allowed = { ["ctrl-v"] = true, ["ctrl-x"] = true, ["ctrl-t"] = true }
  local key, selections = utils.parse_fzf_expect(out, allowed)

  if #selections == 0 then
    return
  end

  local function open(rel)
    local abs = vim.fn.fnamemodify(root .. "/" .. rel, ":p")
    if key == "ctrl-v" then
      vim.cmd.vsplit(vim.fn.fnameescape(abs))
    elseif key == "ctrl-x" then
      vim.cmd.split(vim.fn.fnameescape(abs))
    elseif key == "ctrl-t" then
      vim.cmd.tabedit(vim.fn.fnameescape(abs))
    else
      vim.cmd.edit(vim.fn.fnameescape(abs))
    end
  end

  if #selections == 1 then
    open(selections[1])
  else
    local qf = {}
    for _, p in ipairs(selections) do
      local abs = vim.fn.fnamemodify(p, ":p")
      table.insert(qf, { filename = abs, lnum = 1, col = 1, text = "[file] " .. vim.fn.fnamemodify(abs, ":t") })
    end
    vim.fn.setqflist(qf, "r")
    vim.cmd.copen()
  end
end, { nargs = "?", complete = "dir" })

-- RG (with fzf)
vim.api.nvim_create_user_command("Rg", function(opts)
  if vim.fn.executable "rg" ~= 1 then
    return vim.notify("ripgrep (rg) not found on PATH", vim.log.levels.ERROR)
  end

  if vim.fn.executable "fzf" ~= 1 then
    return vim.notify("fzf not found on PATH", vim.log.levels.ERROR)
  end

  local fargs = opts.fargs or {}

  local function as_dir(s)
    if not s or s == "" then
      return nil
    end
    local p = vim.fn.fnamemodify(vim.fn.expand(s), ":p")
    return (vim.fn.isdirectory(p) == 1) and p or nil
  end

  local root, args = nil, vim.deepcopy(fargs)
  if #args > 0 then
    local first_dir = as_dir(args[1])
    local last_dir = as_dir(args[#args])
    if first_dir then
      root = first_dir
      table.remove(args, 1)
    elseif last_dir then
      root = last_dir
      table.remove(args, fargs)
    end
  end

  ---@diagnostic disable-next-line: undefined-field
  root = root or vim.loop.cwd()

  local query = table.concat(args, " ")
  if query == "" then
    query = vim.fn.input "Rg > "
  end
  if query == "" then
    return
  end

  -- collect matches with rg --vimgrep
  local rg_cmd = { "rg", "--vimgrep", "--hidden", "--glob", "!.git/", "--smart-case", query }
  local _, rg_out, rg_err = utils.run(rg_cmd, { cwd = root })
  if rg_out == "" then
    return vim.notify("Rg: no matches.\n" .. (rg_err or ""), vim.log.levels.INFO)
  end

  local has_bat = vim.fn.executable "bar" == 1
  local preview_cmd = has_bat and "bat -n --color=always --line-range :300 {}"
    or "sed -n '1,200p' -- {} 2>/dev/null || head -n 200 -- {}"

  -- pipe to fzf (multi)
  local fzf_cmd = {
    "fzf",
    "--tmux",
    "--ansi",
    "--multi",
    "--prompt=Rg > ",
    "--preview",
    preview_cmd,
    "--preview-window",
    "right,60%,border",
    "--bind",
    "alt-j:preview-down,alt-k:preview-up,alt-u:preview-page-up,alt-d:preview-page-down,alt-p:toggle-preview",
  }
  local code, sel, _ = utils.run(fzf_cmd, { stdin = rg_out, cwd = root })
  if code ~= 0 or sel == "" then
    return
  end

  -- parse selections
  local entries = {}
  for line in sel:gmatch "([^\n]+)" do
    local e = utils.parse_vimgrep_line(line, root)
    if e then
      table.insert(entries, e)
    end
  end
  if #entries == 0 then
    return
  end

  if #entries == 1 then
    -- single: jump directly
    utils.jump_to(entries[1])
  else
    -- multi: quickfix
    local qf = {}
    for _, e in ipairs(entries) do
      table.insert(qf, { filename = e.filename, lnum = e.lnum, col = e.col, text = e.text })
    end
    vim.fn.setqflist(qf, "r")
    vim.cmd.copen()
  end
end, { nargs = "*", complete = "dir" })
