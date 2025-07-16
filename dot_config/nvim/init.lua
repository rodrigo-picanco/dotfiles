vim.o.foldmethod = "expr"
vim.o.foldcolumn = "0"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.g.mapleader = " "

-- Define plugin groups for granular loading
local ui_plugins = {
  "telescope.nvim",
  "monochrome.nvim",
  "noice.nvim",
  "lualine.nvim",
  "gitsigns.nvim",
  "dressing.nvim",
  "copilot.vim"
}

-- Command to activate whatnots (UI/UX features only)
vim.api.nvim_create_user_command('Whatnots', function()
  print("Loading whatnots (UI/UX features)...")
  for _, plugin in ipairs(ui_plugins) do
    pcall(vim.cmd, "Lazy load " .. plugin)
  end
  print("Whatnots loaded! Telescope, statusline, and UI features are now available.")
end, {})

-- Available LSP servers
local lsp_servers = {
  ruby = function() require("lspconfig").ruby_lsp.setup({
    on_attach = function(client)
      if client.server_capabilities.hoverProvider == vim.empty_dict() then
        client.server_capabilities.hoverProvider = true
      end
    end,
  }) end,
  sorbet = function() require("lspconfig").sorbet.setup({
    cmd = { "srb", "tc", "--lsp" },
    filetypes = { "ruby" },
    root_dir = require("lspconfig").util.root_pattern("sorbet/config", "Gemfile"),
    on_new_config = function(config, root_dir)
      config.cmd_cwd = root_dir
    end,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.hoverProvider = false
    end,
  }) end,
  lua = function() require("lspconfig").lua_ls.setup({}) end,
  typescript = function() require("lspconfig").ts_ls.setup({
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", ".git"),
  }) end,
  graphql = function() require("lspconfig").graphql.setup({
    filetypes = { "graphql", "gql", "svelte", "astro", "vue" },
    root_dir = require("lspconfig").util.root_pattern(
      "graphql.config.*",
      ".graphqlrc*",
      "package.json",
      ".git"
    ),
  }) end,
}

-- Command to control LSP servers
vim.api.nvim_create_user_command('LSP', function(opts)
  local args = vim.split(opts.args, "%s+")
  local action = args[1]
  local server_name = args[2]

  if action == "enable" and server_name then
    if lsp_servers[server_name] then
      pcall(vim.cmd, "Lazy load nvim-lspconfig")
      lsp_servers[server_name]()
      
      -- Trigger LSP start for current buffer if filetype matches
      local ft = vim.bo.filetype
      local server_filetypes = {
        ruby = { "ruby" },
        sorbet = { "ruby" },
        lua = { "lua" },
        typescript = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        graphql = { "graphql", "gql", "svelte", "astro", "vue" }
      }
      
      if server_filetypes[server_name] and vim.tbl_contains(server_filetypes[server_name], ft) then
        -- Force LSP to attach to current buffer
        vim.schedule(function()
          vim.cmd("doautocmd FileType " .. ft)
        end)
        print("LSP server '" .. server_name .. "' enabled and started for current buffer!")
      else
        print("LSP server '" .. server_name .. "' enabled! Open a matching file type to start it.")
      end
    else
      print("Unknown LSP server: " .. server_name)
      print("Available: " .. table.concat(vim.tbl_keys(lsp_servers), ", "))
    end
  elseif action == "disable" and server_name then
    -- Map our server names to actual LSP client names
    local client_names = {
      ruby = "ruby_lsp",
      sorbet = "sorbet",
      lua = "lua_ls", 
      typescript = "ts_ls",
      graphql = "graphql"
    }
    
    local client_name = client_names[server_name] or server_name
    vim.cmd("LspStop " .. client_name)
    print("LSP server '" .. server_name .. "' disabled!")
  elseif action == "list" then
    print("Available LSP servers: " .. table.concat(vim.tbl_keys(lsp_servers), ", "))
  else
    print("Usage: :LSP [enable|disable|list] [server_name]")
    print("Examples:")
    print("  :LSP enable ruby")
    print("  :LSP disable typescript")
    print("  :LSP list")
  end
end, {
  nargs = '*',
  complete = function(arg_lead, cmd_line, cursor_pos)
    local args = vim.split(cmd_line, "%s+")
    if #args == 2 then
      return vim.tbl_filter(function(action)
        return action:match("^" .. arg_lead)
      end, {"enable", "disable", "list"})
    elseif #args == 3 and (args[2] == "enable" or args[2] == "disable") then
      return vim.tbl_filter(function(server)
        return server:match("^" .. arg_lead)
      end, vim.tbl_keys(lsp_servers))
    end
    return {}
  end
})

-- Command to activate formatters/linters
vim.api.nvim_create_user_command('Formatter', function()
  print("Loading formatters and linters...")
  pcall(vim.cmd, "Lazy load none-ls.nvim")
  print("Formatters loaded! Stylua, Prettier, and other formatters are now available.")
end, {})
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 0
vim.o.autoindent = true
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.laststatus = 3
vim.o.nu = true
vim.o.relativenumber = true
vim.o.scrolloff = 999
vim.o.shiftwidth = 8
vim.o.smartindent = true
vim.o.softtabstop = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.o.wrap = false
vim.opt.showmode = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }
vim.opt.shortmess:append("c")
vim.opt.pumheight = 15 -- Max items in popup menu
vim.opt.pumwidth = 30  -- Min width of popup menu

-- Disable buffer completion to reduce clutter
vim.opt.complete:remove(".")  -- Remove current buffer
vim.opt.complete:remove("w")  -- Remove other windows
vim.opt.complete:remove("b")  -- Remove other loaded buffers
vim.keymap.set("n", "<leader>cbn", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end)

if not vim.g.vscode then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup({
    spec = {
      {
        "stevearc/oil.nvim",
        config = function()
          require("oil").setup({
            default_file_explorer = true,
            columns = {
              "icon",
            },
          })
        end,
        lazy = false,
        keys = {
          { "<leader>l", "<cmd>Oil<cr>", desc = "Show current dir files" },
        },
      },
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
          highlight = {
            enable = true,
            disable = function(buf)
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > 100 * 1024 then
                return true
              end
            end,
            additional_vim_regex_highlighting = false,
          },
        },
      },
      {
        "mason-org/mason.nvim",
        opts = {},
      },
      {
        "neovim/nvim-lspconfig",
        lazy = true,
        dependencies = {
          { "mason-org/mason.nvim", opts = {} },
        },
      },
      {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        lazy = true,
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope-live-grep-args.nvim",
        },
        keys = {
          { "<leader>ff", "<cmd>Telescope find_files<cr>" },
          { "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>" },
        },
        config = function()
          local telescope = require("telescope")
          telescope.setup({})
          telescope.load_extension("live_grep_args")
        end,
      },
      {
        "kdheepak/monochrome.nvim",
        lazy = true,
        config = function()
          vim.cmd("colorscheme monochrome")
        end,
      },
      {
        "folke/noice.nvim",
        lazy = true,
        opts = {
          -- add any options here
        },
        dependencies = {
          "MunifTanjim/nui.nvim",
          "rcarriga/nvim-notify",
        },
      },
      {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("lualine").setup()
        end,
      },
      {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        config = function()
          require("gitsigns").setup()
        end,
      },
      {
        "nvimtools/none-ls.nvim",
        lazy = true,
        config = function()
          local null_ls = require("null-ls")
          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.stylua,
              null_ls.builtins.completion.spell,
              null_ls.builtins.formatting.prettierd,
              -- Ruby formatting with stree via bundle exec
              {
                method = null_ls.methods.FORMATTING,
                filetypes = { "ruby" },
                generator = null_ls.formatter({
                  command = "bundle",
                  args = { "exec", "stree", "format" },
                  to_stdin = true,
                  cwd = function(params)
                    -- Find the directory containing Gemfile (usually backend/)
                    local root = require("lspconfig").util.root_pattern("Gemfile")(params.bufname)
                    return root or "/Users/rodrigo.picanto/workspace/factorial/backend"
                  end,
                }),
              },
              -- Semgrep diagnostics
              null_ls.builtins.diagnostics.semgrep.with({
                timeout = 5000,             -- 15 seconds
                extra_args = { "--config", "auto", "--disable-version-check" },
                env = { PYTHONWARNINGS = "ignore" }, -- Suppress Python warnings
                cwd = function(params)
                  -- Run from project root for better rule detection
                  local root = require("lspconfig").util.root_pattern(".git")(params.bufname)
                  return root or "/Users/rodrigo.picanto/workspace/factorial"
                end,
              }),
            },
          })
        end,
      },
      {
        "stevearc/dressing.nvim",
        lazy = true,
      },
      {
        "github/copilot.vim",
        lazy = true,
      },
    },
  })
end

vim.diagnostic.config({
  float = {
    source = "always",
    focusable = true,
    border = "rounded",
    width = 80,
    height = 15,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.open_float({ focus_id = "diagnostic_float" })
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          vim.api.nvim_set_current_win(win)
          vim.wo[win].wrap = true
          vim.wo[win].linebreak = true
          vim.wo[win].breakindent = true
          break
        end
      end
    end, opts)
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  end,
})
