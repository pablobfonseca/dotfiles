local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

-- Literal-glob file finder.
--
-- Unlike `<C-p>` (find_files), the prompt here is piped straight into
-- `rg --files --iglob <pattern>`, so shell-style globs like `demo/*.html`
-- match literally. The fzf sorter is bypassed (empty sorter) — rg does all
-- the filtering, the same way `multi-ripgrep.lua` does for content search.
return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()

  local glob_finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      -- A prompt already containing a glob (`*`) or path separator (`/`),
      -- e.g. `demo/*.html`, passes through verbatim. Bare words are wrapped
      -- as `*<word>*` so `foo` matches any path containing "foo" — keeps the
      -- picker useful as a loose find when you're not writing a full glob.
      local pattern = prompt:find "[*/]" and prompt or ("*" .. prompt .. "*")

      return {
        "rg",
        "--files",
        "--iglob",
        pattern,
        "--color=never",
      }
    end,
    entry_maker = make_entry.gen_from_file(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Find Files (glob)",
      finder = glob_finder,
      previewer = conf.file_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end
