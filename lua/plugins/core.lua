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
      bigfile = { enabled = true },
      dashboard = { enabled = false },
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
      terminal = { enabled = true },
    },
    init = function()
      -- Terminal tab state
      _G.snacks_term_ids = { "term1", "term2", "term3", "term4" }
      _G.snacks_term_current = nil

      -- Switch to a specific terminal tab (hide others, show this one)
      _G.snacks_term_switch = function(id)
        -- If same terminal is requested, just toggle it
        if _G.snacks_term_current == id then
          Snacks.terminal.toggle(nil, { win = { position = "bottom" }, id = id })
          _G.snacks_term_current = nil
          return
        end

        -- Hide current terminal if one is open
        if _G.snacks_term_current then
          local term = Snacks.terminal.get(nil, { id = _G.snacks_term_current })
          if term and term:win() and term:win():valid() then
            term:hide()
          end
        end

        -- Show/create the requested terminal
        Snacks.terminal.open(nil, { win = { position = "bottom" }, id = id })
        _G.snacks_term_current = id
      end
    end,
    keys = {
      {
        "<C-S-t>",
        function()
          -- Find the BOTTOM terminal (snacks), not claudecode's side terminal
          -- Bottom terminal is wider (spans full width or most of it)
          -- Claudecode side panel is only ~40% width
          local term_win = nil
          for _, w in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(w)
            if vim.bo[buf].buftype == "terminal" then
              local width = vim.api.nvim_win_get_width(w)
              -- Bottom terminal should be wider than half the screen
              if width > vim.o.columns * 0.5 then
                term_win = w
                break
              end
            end
          end

          if not term_win then
            return
          end

          local cur_win = vim.api.nvim_get_current_win()
          local h = vim.api.nvim_win_get_height(term_win)

          -- Save and temporarily reduce winminheight to allow maximum expansion
          local saved_wmh = vim.o.winminheight
          vim.o.winminheight = 1

          vim.api.nvim_set_current_win(term_win)

          if h <= 15 then
            -- Expand: wincmd _ fills all available vertical space
            vim.cmd("wincmd _")
          else
            -- Collapse to small size
            vim.cmd("resize 12")
          end

          vim.o.winminheight = saved_wmh
          vim.api.nvim_set_current_win(cur_win)
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal height",
      },
      -- Multiple terminal tabs
      { "<leader>t1", function() _G.snacks_term_switch("term1") end, mode = { "n", "t" }, desc = "Terminal 1" },
      { "<leader>t2", function() _G.snacks_term_switch("term2") end, mode = { "n", "t" }, desc = "Terminal 2" },
      { "<leader>t3", function() _G.snacks_term_switch("term3") end, mode = { "n", "t" }, desc = "Terminal 3" },
      { "<leader>t4", function() _G.snacks_term_switch("term4") end, mode = { "n", "t" }, desc = "Terminal 4" },
      {
        "<leader>tt",
        function()
          Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
        end,
        mode = { "n", "t" },
        desc = "Toggle default terminal",
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 55,
        mappings = {
          ["<C-f>"] = "<C-u>",
        },
      },
      default_component_configs = {
        file_size = {
          enabled = false,
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function()
            vim.cmd("wincmd =")
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            vim.cmd("wincmd =")
          end,
        },
      },
    },
    keys = {
      {
        "<leader>E",
        function()
          vim.cmd("Neotree reveal")
        end,
        desc = "Focus NeoTree",
      },
    },
  },
  { "akinsho/bufferline.nvim", enabled = false },
  ------------------------------------------------------------------------------
  -- [ Below packages do not come with LazyVim by default ] --------------------
  ------------------------------------------------------------------------------
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "right",
          split_width_percentage = 0.4,
          provider = "snacks",
        },
        diff_opts = {
          auto_close_on_accept = true,
          vertical_split = true,
        },
      })

      -- Keymaps matching opencode.nvim bindings

      -- <C-a> - Ask/Send to Claude (like opencode's ask)
      vim.keymap.set("n", "<C-a>", function()
        -- Check if Claude terminal is visible using the plugin's API
        local ok, terminal = pcall(require, "claudecode.terminal")
        if not ok then
          vim.notify("Failed to load claudecode.terminal", vim.log.levels.ERROR)
          return
        end

        local bufnr = terminal.get_active_terminal_bufnr()
        local is_visible = false
        if bufnr then
          local bufinfo = vim.fn.getbufinfo(bufnr)
          is_visible = bufinfo and #bufinfo > 0 and #bufinfo[1].windows > 0
        end

        if not is_visible then
          -- Claude is not visible, open it and add current line context
          terminal.open()
          vim.defer_fn(function()
            local file = vim.fn.expand("%:p")
            local line = vim.fn.line(".")
            vim.cmd("ClaudeCodeAdd " .. file .. " " .. line .. " " .. line)
          end, 100)
        else
          -- Claude is visible, send current line
          vim.o.operatorfunc = "v:lua.claude_operator"
          vim.cmd("normal! g@_")
        end
      end, { desc = "Send line to Claude or open Claude" })
      vim.keymap.set("x", "<C-a>", "<cmd>ClaudeCodeSend<cr><cmd>ClaudeCodeFocus<cr>", { desc = "Send selection to Claude" })

      -- <C-.> - Toggle Claude terminal (like opencode's toggle)
      vim.keymap.set({ "n", "t" }, "<C-.>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })

      -- go - Operator to add range to Claude (like opencode's operator)
      vim.keymap.set({ "n", "x" }, "go", function()
        vim.o.operatorfunc = "v:lua.claude_operator"
        return "g@"
      end, { expr = true, desc = "Add range to Claude" })

      vim.keymap.set("n", "goo", function()
        vim.o.operatorfunc = "v:lua.claude_operator"
        return "g@_"
      end, { expr = true, desc = "Add line to Claude" })

      -- Define the operator function globally
      _G.claude_operator = function(motion_type)
        local start_pos = vim.fn.getpos("'[")
        local end_pos = vim.fn.getpos("']")
        local start_line = start_pos[2]
        local end_line = end_pos[2]
        local file = vim.fn.expand("%:p")
        vim.cmd("ClaudeCodeAdd " .. file .. " " .. start_line .. " " .. end_line)
        vim.cmd("ClaudeCodeFocus")
      end

      -- Remap + and - for increment/decrement since we're using <C-a> and <C-x>
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })

      -- <C-S-f> - Toggle Claude split width between 40% and 90%
      local claude_expanded = false
      vim.keymap.set("t", "<C-S-f>", function()
        local ok, terminal = pcall(require, "claudecode.terminal")
        if not ok then
          return
        end
        local claude_bufnr = terminal.get_active_terminal_bufnr()
        local current_bufnr = vim.api.nvim_get_current_buf()
        if not (claude_bufnr and claude_bufnr == current_bufnr) then
          return
        end

        local win = vim.api.nvim_get_current_win()
        claude_expanded = not claude_expanded
        if claude_expanded then
          vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.9))
        else
          vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.4))
        end
      end, { desc = "Toggle Claude split width" })

      -- Additional Claude-specific keymaps under <leader>a prefix
      vim.keymap.set("n", "<leader>aR", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
      vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
      vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
      vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
      vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
      vim.keymap.set("n", "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", { desc = "Claude status" })
      vim.keymap.set({ "n", "x" }, "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer to Claude" })
    end,
  },
  {
    "NickvanDyke/opencode.nvim",
    enabled = false,
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      vim.keymap.set("n", "<S-C-f>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
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
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()
      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        tsserver_path = vim.fn.getcwd() .. "/node_modules/typescript/lib/tsserverlibrary.js",
      },
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
  {
    "https://git.sr.ht/~marcc/BufferBrowser",
    keys = {
      {
        "H",
        function()
          require("buffer_browser").prev()
        end,
        desc = "Previous recent files",
        mode = { "n" },
      },
      {
        "L",
        function()
          require("buffer_browser").next()
        end,
        desc = "Next recent files",
        mode = { "n" },
      },
    },
  },
}
