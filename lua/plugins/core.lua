return {
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
  { "folke/flash.nvim", enabled = false },
  -- {
  --   "jesseduffield/lazygit",
  -- },
  {
    "folke/noice.nvim",
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
    },
  },
  {
    "tpope/vim-commentary",
    desc = "This enables commenting with the command 'gc'",
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
  -- I'm attempting to make long filenames readable without truncating them, but it's not working atm.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    sections = {
      lualine_a = {
        {
          "filename",
          file_status = true, -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 0, -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory

          shorting_target = 80, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = "[+]", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for newly created file before first write
          },
        },
      },
    },
  },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   config = function()
  --     require("toggleterm").setup({
  --       open_mapping = [[<c-/>]],
  --       shade_terminals = false,
  --       size = 50,
  --       -- add --login so ~/.zprofile is loaded
  --       -- https://vi.stackexchange.com/questions/16019/neovim-terminal-not-reading-bash-profile/16021#16021
  --       shell = "zsh --login",
  --     })
  --   end,
  --   keys = {
  --     { [[<C-/>]] },
  --   },
  -- },
  {
    "tpope/vim-surround",
  },
  {
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
    "jose-elias-alvarez/null-ls.nvim",
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
}
