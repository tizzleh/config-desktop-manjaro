-- init.lua file in your nvim directory

-- Bootstrap the Packer plugin manager
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

-- Plugins
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'gruvbox-community/gruvbox'
  use 'neovim/nvim-lspconfig'
  use 'tpope/vim-fugitive'
  use 'voldikss/vim-floaterm'
  use 'tpope/vim-commentary'
  use 'hrsh7th/nvim-compe' -- For autocompletion

  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'}, {'nvim-lua/popup.nvim'} },
  config = function()
    -- At the end of your init.lua file
    vim.cmd [[
      autocmd VimEnter * if !argc() | execute 'Telescope find_files' | endif
    ]]
  end
}

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons', -- optional
    config = function()
      require("nvim-tree").setup {}
    end
  }

end)

-- Basic settings

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.opt.shiftwidth = 1
vim.g.mapleader = "," -- 'Space' is the leader key

vim.o.relativenumber = true
vim.o.number = true
vim.o.termguicolors = true
vim.cmd([[set guifont=IBM\ Plex\ Mono:h10]]) -- Setting GUI font size
vim.cmd([[colorscheme gruvbox]]) -- Setting colorscheme

-- Change color of line numbers
vim.cmd [[
  highlight CursorLineNr guifg=blue gui=bold
]]


-- LSP settings
local nvim_lsp = require('lspconfig')

-- Use a loop to conveniently setup multiple servers
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {}
end
-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
-- Autocompletion settings
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Additional mappings
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})

-- Use 'Tab' and 'Shift-Tab' to move down and up in hints respectively.
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true, noremap = true})

-- Fugitive
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {noremap = true, silent = true})  -- Git status
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', {noremap = true, silent = true})  -- Git commit

-- Floaterm
vim.api.nvim_set_keymap('n', '<F1>', ':FloatermToggle<CR>', {noremap = true, silent = true})

-- Nvim Tree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

