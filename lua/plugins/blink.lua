return {
  "saghen/blink.cmp",
  config = function(_, opts)
    vim.schedule(function()
      vim.notify("sepearet blink.lua")
    end)
    opts.keymap["<C-j>"] = {
      LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
      "fallback",
    }
  end,
}
