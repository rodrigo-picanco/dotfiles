vim.g.mapleader = " "
vim.o.autoindent = true
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.laststatus = 3
vim.o.nu = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.scrolloff = 999
vim.o.shiftwidth = 8
vim.o.signcolumn = "number"
vim.o.smartindent = true
vim.o.softtabstop = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.o.wrap = false
-- vim.o.loaded_netrw = 0
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        {
                "christoomey/vim-tmux-navigator",
        },
        {
                "williamboman/mason.nvim",
                opts = {},
        },
        {
                "VonHeikemen/lsp-zero.nvim",
                branch = "v3.x",
                config = function()
                        local lsp_zero = require("lsp-zero")
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
                                { "<leader>r", vim.lsp.buf.rename,
                                        "<leader>ca", vim.lsp.buf.code_action
                                },
                        }
                end,
        },
        {
                "williamboman/mason-lspconfig.nvim",
                config = function()
                        require("mason-lspconfig").setup({
                                ensure_installed = {
                                        "ruby_lsp",
                                        "rubocop",
                                        "tsserver",
                                },
                                handlers = {
                                        require("lsp-zero").default_setup,
                                },
                        })
                end,
                opts = {},
        },
        {
                "nvim-tree/nvim-web-devicons",
        },
        {
                "neovim/nvim-lspconfig",
        },
        {
                "hrsh7th/cmp-nvim-lsp",
        },
        {
                "hrsh7th/nvim-cmp",
        },
        {
                "L3MON4D3/LuaSnip",
        },
        {
                "j-hui/fidget.nvim",
                opts = {},
        },
        {
                "nvim-lua/plenary.nvim"
        },
        {
                "nvim-telescope/telescope.nvim",
                keys = function()
                        local builtin = require("telescope.builtin")
                        return {
                                { "<C-p>",      builtin.git_files },
                                { "<leader>ff", builtin.find_files },
                                { "<leader>fb", builtin.buffers },
                                { "<leader>fg", builtin.live_grep },
                                { "<leader>fr", builtin.resume }
                        }
                end,
        },
        -- added before the review just so I do not forget it
        {
                "catppuccin/nvim",
                name = "catppuccin",
                priority = 1000,
                config = function()
                        vim.cmd.colorscheme("catppuccin")
                end
        },
        {
                "stevearc/oil.nvim",
                opts = {
                        default_file_explorer = true,
                },
                keys = function()
                        return {
                                { "<Leader>l", vim.cmd.Oil }
                        }
                end,
        },
        {
                "numToStr/Comment.nvim",
                opts = {},
        },
        {
                "ThePrimeagen/harpoon",
                config = function()
                        local mark = require("harpoon.mark")
                        local ui = require("harpoon.ui")
                        vim.keymap.set("n", "<leader>a", mark.add_file)
                        vim.keymap.set("n", "<leader>m", ui.toggle_quick_menu)
                end
        },
        {
                "nvim-treesitter/nvim-treesitter-textobjects"
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
                                textobjects = {
                                        select = {
                                                enable = true,
                                                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                                                keymaps = {
                                                        -- You can use the capture groups defined in textobjects.scm
                                                        ["aa"] = "@parameter.outer",
                                                        ["ia"] = "@parameter.inner",
                                                        ["af"] = "@function.outer",
                                                        ["if"] = "@function.inner",
                                                        ["ac"] = "@class.outer",
                                                        ["ic"] = "@class.inner",
                                                        ["ii"] = "@conditional.inner",
                                                        ["ai"] = "@conditional.outer",
                                                        ["il"] = "@loop.inner",
                                                        ["al"] = "@loop.outer",
                                                        ["at"] = "@comment.outer",
                                                },
                                        },
                                        move = {
                                                enable = true,
                                                set_jumps = true, -- whether to set jumps in the jumplist
                                                goto_next_start = {
                                                        ["]f"] = "@function.outer",
                                                        ["]]"] = "@class.outer",
                                                },
                                                goto_next_end = {
                                                        ["]F"] = "@function.outer",
                                                        ["]["] = "@class.outer",
                                                },
                                                goto_previous_start = {
                                                        ["[f"] = "@function.outer",
                                                        ["[["] = "@class.outer",
                                                },
                                                goto_previous_end = {
                                                        ["[F"] = "@function.outer",
                                                        ["[]"] = "@class.outer",
                                                },
                                        },
                                        swap = {
                                                enable = true,
                                                swap_next = {
                                                        ["<leader>a"] = "@parameter.inner",
                                                },
                                                swap_previous = {
                                                        ["<leader>A"] = "@parameter.inner",
                                                },
                                        },
                                },
                        })
                end
        },
        {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                        local nl = require("null-ls")
                        nl.setup({
                                debouce = 2000,
                                sources = {
                                        nl.builtins.diagnostics.eslint,
                                        nl.builtins.code_actions.eslint,
                                        nl.builtins.formatting.prettier,
                                },
                        })
                end
        },
        {
                "nvim-lualine/lualine.nvim",
                config = function()
                        -- Define a function to check that ollama is installed and working
                        local function get_condition()
                                return package.loaded["ollama"] and require("ollama").status ~= nil
                        end
                        -- Define a function to check the status and return the corresponding icon
                        local function get_status_icon()
                                local status = require("ollama").status()

                                if status == "IDLE" then
                                        return ""
                                elseif status == "WORKING" then
                                        return "Ollama ruminating"
                                end
                        end
                        -- Load and configure "lualine"
                        require("lualine").setup({
                                sections = {
                                        -- lualine_a = {},
                                        -- lualine_b = { "branch", "diff", "diagnostics" },
                                        lualine_c = { { "filename", path = 1 } },
                                        lualine_x = { get_status_icon },
                                        -- lualine_y = { "progress" },
                                        lualine_z = { "location" },
                                },
                        })
                end
        },
        {
                "FabijanZulj/blame.nvim",
                config = function()
                        require("blame").setup()
                end
        },
        {
                "github/copilot.vim",
        },
        -- lazy.nvim
        {
                "folke/noice.nvim",
                event = "VeryLazy",
                opts = {
                        -- add any options here
                },
                dependencies = {
                        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                        "MunifTanjim/nui.nvim",
                        -- OPTIONAL:
                        --   `nvim-notify` is only needed, if you want to use the notification view.
                        --   If not available, we use `mini` as the fallback
                        "rcarriga/nvim-notify",
                }
        }
}, {})
