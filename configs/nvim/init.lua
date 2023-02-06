vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
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
vim.o.shiftwidth = 2
vim.o.signcolumn = 'number'
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.o.undofile = true
vim.o.wrap = false

vim.keymap.set('n', '<Leader>l', vim.cmd.Ex)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  use('wbthomason/packer.nvim')
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    end
  })
  use({
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      local lsp = require('lsp-zero')
      lsp.preset('recommended')
      lsp.ensure_installed({
        'rust_analyzer',
        'sumneko_lua',
        'tsserver'
      })
      lsp.configure('sumneko_lua', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })
      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true })
      })
      cmp_mappings['<Tab>'] = nil
      cmp_mappings['<S-Tab>'] = nil
      lsp.setup_nvim_cmp({
        mapping = cmp_mappings
      })
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
      vim.keymap.set('n', '<leader>gtd', vim.lsp.buf.type_definition)
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
      vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
      lsp.setup()
    end
  })
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    tag = '0.1.0',
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fr', builtin.resume, {})
    end
  })
  use({
    'j-hui/fidget.nvim',
    config = function()
      require 'fidget'.setup({})
    end
  })
  use('folke/lsp-colors.nvim')
  use({
    'MunifTanjim/prettier.nvim',
    config = function()
      local pr = require 'prettier'
      pr.setup {
        bin = 'prettierd',
        filetypes = {
          'css',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'json',
          'scss'
        }
      }
    end
  })
  use({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local nl = require('null-ls')
      nl.setup({
        debouce = 2000,
        sources = {
          nl.builtins.diagnostics.eslint_d,
          nl.builtins.code_actions.eslint_d,
          nl.builtins.code_actions.gitsigns,
          nl.builtins.formatting.prettierd,
        },
      })
    end
  })
  use('github/copilot.vim')

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

