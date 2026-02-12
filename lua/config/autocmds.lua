-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- ============================================================================
-- Fix slow lazygit: disable LazyVim's checktime on terminal events
-- (It triggers expensive LSP reloads after discarding changes in lazygit)
-- ============================================================================

vim.api.nvim_del_augroup_by_name("lazyvim_checktime")

vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("checktime_focus_only", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- ============================================================================
-- Cursorline only in active window
-- ============================================================================

local cursorline_group = vim.api.nvim_create_augroup("CursorLineOnlyActiveWindow", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = cursorline_group,
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = cursorline_group,
  callback = function()
    -- Keep cursorline in Neo-tree to show which file is selected
    if vim.bo.filetype == "neo-tree" then
      return
    end
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- ============================================================================
-- C-/ toggles Claude Code terminal
-- From buffer: opens/focuses Claude
-- From Claude terminal: switches focus back to editor (keeps Claude open)
-- ============================================================================

local claudecode_group = vim.api.nvim_create_augroup("ClaudeCodeTerminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = claudecode_group,
  callback = function()
    vim.defer_fn(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ok, terminal = pcall(require, "claudecode.terminal")
      if ok then
        local claude_bufnr = terminal.get_active_terminal_bufnr()
        if claude_bufnr and claude_bufnr == bufnr then
          -- In Claude terminal: C-/ switches focus to editor
          local switch_to_editor = function()
            vim.cmd("wincmd p")
          end
          vim.keymap.set("t", "<C-/>", switch_to_editor, { buffer = bufnr, desc = "Switch to editor" })
          vim.keymap.set("t", "<C-_>", switch_to_editor, { buffer = bufnr, desc = "Switch to editor" })
        end
      end
    end, 100)
  end,
})

-- From normal mode: C-/ opens/focuses Claude
vim.keymap.set("n", "<C-/>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<C-_>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
