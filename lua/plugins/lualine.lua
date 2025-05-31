return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_c = {
        {
          "filename",
          path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
        },
      },
      lualine_z = {}, -- hide clock
    },
  },
}
