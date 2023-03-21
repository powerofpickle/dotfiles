-- Install packer if not installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  local plugins = {
    'scrooloose/nerdtree',
    'tpope/vim-sleuth',
    {'junegunn/fzf', run = ':call fzf#install()'},
    'junegunn/fzf.vim',
    'neovim/nvim-lspconfig',
    'tpope/vim-fugitive',
    'psliwka/vim-smoothie', -- Smooth scrolling
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    'eandrju/cellular-automaton.nvim',

    'ellisonleao/gruvbox.nvim',
    'edeneast/nightfox.nvim',
    'catppuccin/nvim',
    'folke/tokyonight.nvim',
    'sainnhe/everforest',
  }

  for _, plugin in pairs(plugins) do
    use(plugin)
  end
end)

local options = {
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  autoindent = true,
  hidden = true,
  hlsearch = false, -- Don't highlight search results
  autoread = true,
  relativenumber = true,
  termguicolors = true,
  signcolumn = 'yes',
  cmdheight = 1,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

require('nvim-treesitter.configs').setup {
  ensure_installed = {"help", "c", "cpp", "python", "lua", "rust"},
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gcn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- From https://shapeshed.com/vim-netrw/
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 4
vim.g.netrw_winsize = 25
--[[
vim.cmd[[
  augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * :Vexplore
  augroup END
]]
--]]

-- Set color scheme
--vim.cmd.colorscheme "base16-ocean"
--vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin-macchiato"

-- Make background same as terminal
for _, hl_group in pairs({
  'Normal',
  -- 'LineNr', Changes text color, fix later
  'NormalFloat',
  -- 'FloatBorder',
  -- 'Pmenu',
  -- 'PmenuSel',
  -- 'PmenuSbar',
  -- 'PmenuThumb',
  'SignColumn',
  -- 'VertSplit',
}) do
  vim.api.nvim_set_hl(0, hl_group, {bg = "none"})
end

-- Remove this once text color issue is fixed
vim.cmd[[
  highlight LineNr ctermbg=none guibg=none
]]

-- Show relative numbers when buffer is focused, otherwise show absolute numbers
vim.cmd[[
  set number
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
]]


-- Remove help indicator at top of NERDTree
vim.cmd[[let NERDTreeMinimalUI=1]]

-- Prevents filename from being searched with regex search
vim.cmd[[
  command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]

vim.cmd[[set completeopt-=preview]]

vim.cmd[[
  set path+=**
  set wildmenu
]]

require('config.keymap')
require('config.lsp')
