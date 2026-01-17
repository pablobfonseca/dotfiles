vim.pack.add { { src = "https://github.com/coder/claudecode.nvim" } }

require("claudecode").setup {}

local set = vim.keymap.set

set({ "n" }, "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
set({ "n" }, "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
set({ "n" }, "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
set({ "n" }, "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
set({ "n" }, "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
set({ "n" }, "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
set({ "n", "v" }, "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
set({ "n" }, "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
set({ "n" }, "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
