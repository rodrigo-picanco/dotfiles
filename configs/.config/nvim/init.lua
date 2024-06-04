vim.g.mapleader = ' '
vim.o.autoindent = true
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.laststatus = 3
vim.o.nu = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.scrolloff = 999
vim.o.shiftwidth = 8
vim.o.signcolumn = 'number'
vim.o.smartindent = true
vim.o.softtabstop = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.o.undofile = true
vim.o.wrap = false
-- vim.o.loaded_netrw = 0
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                'git',
                'clone',
                '--filter=blob:none',
                'https://github.com/folke/lazy.nvim.git',
                '--branch=stable', -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
        {
                'christoomey/vim-tmux-navigator',
        },
        {
                'williamboman/mason.nvim',
                opts = {},
        },
        {
                'VonHeikemen/lsp-zero.nvim',
                branch = 'v3.x',
                config = function()
                        local lsp_zero = require('lsp-zero')
                        lsp_zero.extend_lspconfig()
                        lsp_zero.on_attach(function(_, bufnr)
                                lsp_zero.default_keymaps({
                                        buffer = bufnr,
                                        preserve_mappings = false
                                })
                        end)
                end,
                keys = function()
                        return {
                                { '<leader>r', vim.lsp.buf.rename,
                                  '<leader>ca', vim.lsp.buf.code_action
                                },
                        }
                end,
        },
        {
                'williamboman/mason-lspconfig.nvim',
                config = function()
                        require('mason-lspconfig').setup({
                                handlers = {
                                        require('lsp-zero').default_setup,
                                },
                        })
                end,
                opts = {},
        },
        {
                'nvim-tree/nvim-web-devicons',
        },
        {
                'neovim/nvim-lspconfig',
        },
        {
                'hrsh7th/cmp-nvim-lsp',
        },
        {
                'hrsh7th/nvim-cmp',
        },
        {
                'L3MON4D3/LuaSnip',
        },
        {
                'j-hui/fidget.nvim',
                opts = {},
        },
        {
                'nvim-lua/plenary.nvim'
        },
        {
                'nvim-telescope/telescope.nvim',
                keys = function()
                        local builtin = require('telescope.builtin')
                        return {
                                { '<C-p>',      builtin.git_files },
                                { '<leader>ff', builtin.find_files },
                                { '<leader>fb', builtin.buffers },
                                { '<leader>fg', builtin.live_grep },
                                { '<leader>fr', builtin.resume }
                        }
                end,
        },
        -- added before the review just so I do not forget it
        {
                'catppuccin/nvim',
                name = 'catppuccin',
                priority = 1000,
                config = function()
                        vim.cmd.colorscheme('catppuccin')
                end
        },
        {
                'stevearc/oil.nvim',
                opts = {
                        default_file_explorer = true,
                        experimental_watch_for_changes = false,
                },
                keys = function()
                        return {
                                { '<Leader>l', vim.cmd.Oil }
                        }
                end,
        },
        {
                'numToStr/Comment.nvim',
                opts = {},
        },
        {
                'ThePrimeagen/harpoon',
                config = function()
                        local mark = require('harpoon.mark')
                        local ui = require('harpoon.ui')
                        vim.keymap.set('n', '<leader>a', mark.add_file)
                        vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)
                end
        },
        {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                config = function()
                        local configs = require("nvim-treesitter.configs")
                        configs.setup({
                                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "go", "javascript", "html", "typescript", "tsx", "ruby" },
                                sync_install = false,
                                highlight = { enable = true },
                                indent = { enable = true },
                                incremental_selection = {
                                        enable = true,
                                        keymaps = {
                                                init_selection = "gnn",
                                                node_incremental = "grn",
                                                scope_incremental = "grc",
                                                node_decremental = "grm",
                                        },
                                },
                        })
                end
        },
        {
                'jose-elias-alvarez/null-ls.nvim',
                config = function()
                        local nl = require('null-ls')
                        nl.setup({
                                debouce = 2000,
                                sources = {
                                        nl.builtins.diagnostics.eslint_d,
                                        nl.builtins.code_actions.eslint_d,
                                        nl.builtins.formatting.prettierd,
                                        nl.builtins.diagnostics.markdownlint,
                                },
                        })
                end
        },
        {
                "nomnivore/ollama.nvim",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                },
                cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
                keys = {
                        {
                              "<leader>oo",
                              ":<c-u>lua require('ollama').prompt()<cr>",
                              desc = "ollama prompt",
                              mode = { "n", "v" },
                        },
                        {
                              "<leader>ol",
                              ":<c-u>lua require('ollama').prompt('Llamopilot')<cr>",
                              desc = "ollama raw query",
                              mode = { "n", "v" },
                        },
                },
                opts = {
                        prompts = {
                                Llamopilot = {
                                        model = "mistral",
                                        input_label = "> ",
                                        action = "display"
                                },
                                Raw = false,
                                Ask_About_Code = false,
                                Explain_Code = false,
                                Generate_Code = false,
                                Modify_Code = false,
                                Simplify_Code = false
                        }
                }
        },
        {
                "nvim-lualine/lualine.nvim",
                config = function()
                        -- Define a function to check that ollama is installed and working
                        local function get_condition()
                            return package.loaded["ollama"] and require("ollama").status ~= nil
                        end
                        -- Define a function to check the status and return the corresponding icon
                        local function get_status_icon() local status = require("ollama").status()

                          if status == "IDLE" then
                            return ""
                          elseif status == "WORKING" then
                            return "Ollama ruminating"
                          end
                        end
                        -- Load and configure 'lualine'
                        require("lualine").setup({
                                sections = {
                                        -- lualine_a = {},
                                        -- lualine_b = { "branch", "diff", "diagnostics" },
                                        -- lualine_c = { { "filename", path = 1 } },
                                        lualine_x = { get_status_icon },
                                        -- lualine_y = { "progress" },
                                        -- lualine_z = { "location" },
                                },
                        })
                end
        },
        {
                "kdheepak/lazygit.nvim",
    	        cmd = {
                        "LazyGit",
                        "LazyGitConfig",
                        "LazyGitCurrentFile",
                        "LazyGitFilter",
                        "LazyGitFilterCurrentFile",
    	        },
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                keys = {
                   { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
                }
    },
    {
        "FabijanZulj/blame.nvim",
        config = function()
                require("blame").setup()
        end
    }
}, {})
