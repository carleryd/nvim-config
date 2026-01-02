-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd("CursorHold", {
--   pattern = { "*" },
--   callback = function()
--     vim.lsp.buf.hover()
--     -- if not require("cmp").visible() then
--     --   local hover_fixed = function()
--     --     vim.api.nvim_command("set eventignore=CursorHold")
--     --     vim.api.nvim_command('autocmd CursorMoved ++once set eventignore=" " ')
--     --     vim.lsp.buf.hover()
--     --   end
--     --   hover_fixed()
--     -- end
--   end,
-- })

-- Avoid focusing neo-tree when closing other windows
-- Only triggers when entering a neo-tree buffer, and only for non-floating windows
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "neo-tree *",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)

    -- Skip if this is a floating window (intentional focus)
    if config.relative ~= "" then
      return
    end

    -- Find a window with a normal file buffer to focus instead
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local wconfig = vim.api.nvim_win_get_config(w)
      -- Skip floating windows
      if wconfig.relative == "" then
        local b = vim.api.nvim_win_get_buf(w)
        local bt = vim.bo[b].buftype
        local ft = vim.bo[b].filetype
        if bt == "" and ft ~= "neo-tree" then
          vim.api.nvim_set_current_win(w)
          return
        end
      end
    end
  end,
})
