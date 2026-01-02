-- Avoid focusing neo-tree when closing other windows
-- Track if a window was just closed
local window_just_closed = false

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    window_just_closed = true
    vim.defer_fn(function()
      window_just_closed = false
    end, 50)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "neo-tree *",
  callback = function()
    -- Only redirect if we got here from a window close
    if not window_just_closed then
      return
    end

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
