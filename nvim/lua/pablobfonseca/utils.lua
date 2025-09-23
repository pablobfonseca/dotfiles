local M = {}

local function is_abs(path)
  -- POSIX: starts with /
  if path:sub(1, 1) == "/" then
    return true
  end
  -- Windows drive: C:\ or C:/
  if path:match "^%a:[/\\]" then
    return true
  end
  -- Windows UNC: \\server\share
  if path:sub(1, 2) == "\\\\" then
    return true
  end
  return false
end

-- Open a location (file/lnum/col)
function M.jump_to(entry)
  vim.cmd.edit(vim.fn.fnameescape(entry.filename))
  vim.api.nvim_win_set_cursor(0, { entry.lnum or 1, (entry.col or 1) - 1 })
  vim.cmd "normal! zvzz"
end

-- utils.lua
function M.parse_fzf_expect(out, allowed)
  -- allowed: set like { ['ctrl-v']=true, ['ctrl-x']=true, ['ctrl-t']=true }
  local lines = vim.split(out or "", "\n", { trimempty = true })
  if #lines == 0 then
    return nil, {}
  end
  local first = lines[1]
  local key = (allowed and allowed[first]) and first or nil
  if key then
    table.remove(lines, 1) -- drop key line; rest are selections
  end
  return key, lines
end

function M.split_lines(s)
  local t = {}
  for L in (s or ""):gmatch "([^\n]*)\n?" do
    if L == "" then
      break
    end
    t[#t + 1] = L
  end
  return t
end

function M.run(cmd, opts)
  opts = opts or {}
  local res = vim.system(cmd, { text = true, stdin = opts.stdin, cwd = opts.cwd }):wait()
  return res.code or 0, (res.stdout or ""), (res.stderr or "")
end

-- Parse "file:lnum:col:text" lines (ripgrep --vimgrep)
function M.parse_vimgrep_line(line, root)
  -- Greedy filename up to the 3 trailing colon fields: lnum:col:text
  local file, lnum, col, text = line:match "^(.-):(%d+):(%d+):(.*)$"
  if not file then
    return nil
  end

  local resolved
  if is_abs(file) then
    resolved = file
  else
    ---@diagnostic disable-next-line: undefined-field
    local base = root or vim.loop.cwd()
    resolved = (base and base ~= "") and (base .. "/" .. file) or file
  end

  resolved = vim.fs.normalize(resolved)

  return {
    filename = resolved,
    lnum = tonumber(lnum),
    col = tonumber(col),
    text = text,
  }
end

return M
