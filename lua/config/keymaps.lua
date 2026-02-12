-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "<C-f>", "<C-u>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-f>", "<C-u>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-j>", "<C-d>", { noremap = true, silent = true }) -- half-page down
-- vim.keymap.set("n", "<C-k>", "<C-u>", { noremap = true, silent = true }) -- half-page up
-- vim.keymap.set("n", "<C-x>", function()
--   vim.api.nvim_buf_delete(0, { force = false })
-- end, { desc = "Delete current buffer" })

vim.keymap.set({ "n", "i", "v" }, "<D-s>", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save buffer" })

-- keymaps for visual mode (LazyVim style)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cai",
  "<cmd>normal! gv<CR><cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true, desc = "List fixes" }
)

vim.api.nvim_set_keymap("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Save original mappings before overriding
local original_cj = vim.fn.maparg("<C-j>", "n")
local original_ck = vim.fn.maparg("<C-k>", "n")

-- Scroll Noice hover popup (down and up), fallback to original behavior
vim.keymap.set({ "n", "i", "s" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then
    return original_cj ~= "" and original_cj or "<C-w>j"
  end
end, { silent = true, expr = true, desc = "Scroll hover down" })

vim.keymap.set({ "n", "i", "s" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then
    return original_ck ~= "" and original_ck or "<C-w>k"
  end
end, { silent = true, expr = true, desc = "Scroll hover up" })

vim.keymap.set("n", "Q", "q", { noremap = true })

-- Necessary to dismiss on "q" even if not inside of hover window
vim.keymap.set("n", "q", "<cmd>Noice dismiss<CR>", {
  desc = "Dismiss Noice popup",
  silent = true,
})

