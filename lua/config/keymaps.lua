-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("i", "<C-f>", "<C-u>", { desc = "LEFT" })
vim.api.nvim_set_keymap("n", "<C-f>", "<C-u>", { noremap = true, silent = true })

-- keymaps for visual mode (LazyVim style)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cai",
  "<cmd>normal! gv<CR><cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true, desc = "List fixes" }
)
