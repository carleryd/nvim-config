return {
  ------------------------------------------------------------------------------
  -- [ Configuration for included LazyVim packages ] --------------------
  ------------------------------------------------------------------------------
  { "folke/flash.nvim", enabled = false },
  {
    "folke/noice.nvim",
    ---@return NoiceViewOptions
    ---@class NoiceConfigViews: table<string, NoiceViewOptions>
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
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
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
      function()
        require("noice").dismiss()
      end,
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
          position = "float",
        },
      },
      terminal = {
        cmd = "tmux a",
        win = {
          width = 0.95,
          height = 0.95,
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
    "nvim-lspconfig",
    opts = {
      servers = {
        tsserver = false, -- disable LazyVim's default tsserver setup
        vtsls = false,
        eslint = false, -- Not working
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
  {
    "saghen/blink.cmp",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      --   "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      },
      -- sources = {
      --   -- Add 'avante' to the list
      --   default = { "avante", "lsp", "path", "buffer" },
      --   providers = {
      --     avante = {
      --       module = "blink-cmp-avante",
      --       name = "Avante",
      --       opts = {
      --         -- options for blink-cmp-avante
      --       },
      --     },
      --   },
      -- },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git" },
      })
      require("telescope").load_extension("projects")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
            ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
            ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
            ["<C-f>"] = require("telescope.actions").preview_scrolling_up,
          },
          n = {
            ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
            ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
            ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
            ["<C-f>"] = require("telescope.actions").preview_scrolling_up,
          },
        },
      },
    },
  },
  ------------------------------------------------------------------------------
  -- [ Below packages do not come with LazyVim by default ] --------------------
  ------------------------------------------------------------------------------
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     provider = "claude",
  --     -- 2. Anthropic API settings
  --     providers = {
  --       claude = {
  --         timeout = 60000,
  --         -- temperature = 0,
  --         thinking = { type = "enabled", budget_tokens = 16000 },
  --         disable_tools = false,
  --         extra_request_body = {
  --           temperature = 1, -- temperature may only be set to 1 when thinking is enabled.
  --           max_tokens = 64000,
  --         },
  --       },
  --     },
  --   },
  --   input = {
  --     provider = "snacks",
  --     provider_opts = {
  --       -- Additional snacks.input options
  --       title = "Avante Input",
  --       icon = " ",
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "stevearc/dressing.nvim", -- for input provider dressing
  --     "folke/snacks.nvim", -- for input provider snacks
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     -- {
  --     --   -- Make sure to set this up properly if you have lazy=true
  --     --   "MeanderingProgrammer/render-markdown.nvim",
  --     --   opts = {
  --     --     file_types = { "markdown", "Avante" },
  --     --   },
  --     --   ft = { "markdown", "Avante" },
  --     -- },
  --   },
  -- },
  -- {
  --   "maxmx03/solarized.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.o.background = "light" -- or 'light'
  --
  --     vim.cmd.colorscheme("solarized")
  --   end,
  -- },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      handlers = {
        -- Below formats errors that show up in the standard lspconfig tooltips
        ["textDocument/publishDiagnostics"] = function(_client, result, ctx)
          if result.diagnostics == nil then
            return
          end

          -- ignore some tsserver diagnostics
          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]

            local formatter = require("format-ts-errors")[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message

            -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if entry.code == 80001 then
              -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
        end,
      },
    },
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
    "shortcuts/no-neck-pain.nvim",
    config = function()
      require("no-neck-pain").setup({
        width = 140,
      })
    end,
    lazy = true,
    keys = {
      {
        "<leader>up",
        "<cmd>NoNeckPain<CR>",
        desc = "NoNeckPain toggle",
        mode = { "n" },
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RGBA = true, -- #RGBA hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
      },
    },
  },
  {
    "davidosomething/format-ts-errors.nvim",
  },
}
