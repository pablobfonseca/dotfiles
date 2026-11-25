local normalize_line = function(line)
  return line:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
end

local extract_function_definitions = function(text)
  local lines = vim.split(text, "\n")
  local result = {}
  local seen = {}

  for _, line in ipairs(lines) do
    line = normalize_line(line)
    if line ~= "" then
      local signature = line:match("^function%s+[%w%._:]+%s*%b()")
      if not signature then
        local local_signature = line:match("^local%s+function%s+[%w%._:]+%s*%b()")
        if local_signature then
          signature = local_signature:gsub("^local%s+", "")
        else
          local name, args = line:match("^([%w%._:]+)%s*=%s*function%s*(%b())")
          if name and args then
            signature = "function " .. name .. args
          end
        end
      end

      if signature and not seen[signature] then
        seen[signature] = true
        table.insert(result, signature)
      end
    end
  end

  return table.concat(result, "\n")
end

local drop_deprecated = function(lines)
  local result = {}
  local deprecated = false
  for _, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if vim.startswith(trimmed, "---") then
      if trimmed:match("@deprecated") then
        deprecated = true
      end
      table.insert(result, line)
    else
      if not (deprecated and vim.startswith(trimmed, "function ")) then
        table.insert(result, line)
      end
      deprecated = false
    end
  end
  return result
end

local metas = {
  {
    name = "diagnostic.lua",
    path = "lua/vim/diagnostic.lua",
    description = "vim.diagnostic APIs, types, and helpers.",
  },
}

local read = {}

table.insert(read, "# Neovim Diagnostics API Reference")
table.insert(read, "")
table.insert(read, "This document contains function definitions for Neovim's diagnostics Lua API.")
table.insert(read, "Use this as a reference when working with diagnostics in Neovim Lua.")
table.insert(read, "Generated from Neovim " .. tostring(vim.version()) .. ".")
table.insert(read, "")

for _, meta in ipairs(metas) do
  local file = vim.api.nvim_get_runtime_file(meta.path, false)[1]
  if file then
    local lines = vim.fn.readfile(file)
    local text = table.concat(drop_deprecated(lines), "\n")
    text = extract_function_definitions(text)

    table.insert(read, "---")
    table.insert(read, "")
    table.insert(read, "## " .. meta.name:gsub("%.lua$", ""))
    table.insert(read, "")
    table.insert(read, meta.description)
    table.insert(read, "")
    table.insert(read, "```lua")
    table.insert(read, text)
    table.insert(read, "```")
    table.insert(read, "")
  else
    io.stderr:write("Error: Could not find " .. meta.path .. "\n")
    os.exit(1)
  end
end

local result = table.concat(read, "\n")
local output_path = arg[1] or (os.getenv("HOME") .. "/.behaviors/vim.diagnostics.md")
local dir = output_path:match("(.*/)")
if dir then
  os.execute("mkdir -p " .. dir)
end

local file = io.open(output_path, "w")
if file then
  file:write(result)
  file:close()
  print("Generated: " .. output_path)
else
  io.stderr:write("Error: Could not write to " .. output_path .. "\n")
  os.exit(1)
end
