return {
  ------------------------------------------------------------------------------
  -- [ Configuration for included LazyVim packages ] --------------------
  ------------------------------------------------------------------------------
  { "folke/flash.nvim", enabled = false },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          enabled = true,
          opts = {
            border = "rounded",
            max_width = 200,
            max_height = 100,
          },
        },
      },
    },
    keys = {
      {
        "<C-f>",
        function()
          return "<C-u>"
        end,
        silent = true,
        expr = true,
        desc = "Make <C-f> act like <C-u>",
        -- All 3 modes needed, otherwise it doesn't override properly for insert mode
        mode = { "i", "n", "s" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 5, total = 100 },
          easing = "linear",
        },
      },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        terminal = {
          height = 0.8,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Extend the .env filetype pattern
      vim.filetype.add({
        pattern = {
          -- Keep the original LazyVim one
          ["%.env%.[%w_.-]+"] = "sh",
          -- Add more patterns as needed:
          ["%.envrc"] = "sh",
          ["%.env%.example"] = "sh",
          ["%.env%.local"] = "sh",
        },
      })
    end,
  },
  {
    -- We are using typescript-tools as language server for TypeScript
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = false, -- disable LazyVim's default tsserver setup
      },
    },
  },
  {
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
  },
  ------------------------------------------------------------------------------
  -- [ Below packages do not come with LazyVim by default ] --------------------
  ------------------------------------------------------------------------------
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light" -- or 'light'

      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "TrevorS/uuid-nvim",
    lazy = true,
    keys = {
      {
        "<leader>cau",
        function()
          local uuidNvim = require("uuid-nvim")
          uuidNvim.insert_v4({ case = "lower", quotes = "single" })
        end,
        desc = "Generate UUID",
        mode = { "n" },
      },
    },
  },
  { "mini.pairs", enabled = false },
  {
    -- Allow for cs{[ to change surrounding { with [
    "tpope/vim-surround",
  },
  {
    -- LazyVim comes with a built in <leader>gb git command which is not as good.
    -- This shows hints as gutter annotations on the right side of the editor.
    "FabijanZulj/blame.nvim",
    config = function()
      require("blame").setup()
    end,
    lazy = true,
    keys = {
      {
        "<leader>gb",
        "<cmd>BlameToggle virtual<CR>",
        desc = "Git blame file",
        mode = { "n" },
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {},
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "OscarCreator/rsync.nvim",
    build = "make",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("rsync").setup()
    end,
  },
}
