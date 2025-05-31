-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "<C-f>", "<C-u>", { noremap = true, silent = true })

-- keymaps for visual mode (LazyVim style)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cai",
  "<cmd>normal! gv<CR><cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true, desc = "List fixes" }
)

vim.api.nvim_set_keymap("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Scroll Noice hover popup (down and up)
vim.keymap.set({ "n", "i", "s" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then
    return "<C-f>"
  end
end, { silent = true, expr = true, desc = "Scroll hover down" })

vim.keymap.set({ "n", "i", "s" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<C-b>"
  end
end, { silent = true, expr = true, desc = "Scroll hover up" })
