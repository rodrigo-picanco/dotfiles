vim.pack.add({
  'https://github.com/rose-pine/neovim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

vim.o.swapfile = false
vim.o.omnifunc =  'v:lua.vim.lsp.omnifunc'

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = event.buf })
    vim.keymap.set('n', 'gf', vim.lsp.buf.format)
  end
})

vim.lsp.enable('ruby_lsp')

require('rose-pine').setup({
  styles = {
    transparency = true,
  },
})
vim.cmd('colorscheme rose-pine')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ruby', 'eruby' },
  callback = function() 
    vim.treesitter.start() 
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.diagnostic.config({
  float = {
    source = "always",
    focusable = true,
    border = "rounded",
    width = 100,
    height = 15,
  },
})

vim.api.nvim_create_user_command('CopyPath', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
  print("Copied: " .. vim.fn.expand('%'))
end, {})
