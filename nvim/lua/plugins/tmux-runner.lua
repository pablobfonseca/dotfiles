return {
  "christoomey/vim-tmux-runner",
  keys = {
    {
      "<C-c>ta",
      mode = "n",
      desc = "Tmux attach pane",
      "<cmd>VtrAttachToPane<cr>",
    },
    {
      "<C-c>tt",
      mode = "n",
      desc = "Tmux run command",
      "<cmd>VtrSendCommandToRunner!<cr>",
    },
    {
      "<C-c>tf",
      mode = "n",
      desc = "Tmux flush command",
      "<cmd>VtrFlushCommand<cr>",
    },
  },
}
