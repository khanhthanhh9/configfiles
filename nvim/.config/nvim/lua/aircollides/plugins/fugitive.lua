return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },  -- Load only when using Git commands
    keys = {
      { "<leader>gs", ":Git<CR>", desc = "Git Status" },
      { "<leader>gc", ":Git commit<CR>", desc = "Git Commit" },
      { "<leader>gp", ":Git push<CR>", desc = "Git Push" },
      { "<leader>gl", ":Git pull<CR>", desc = "Git Pull" }
    }
  }
}

