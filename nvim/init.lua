
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

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
  'scrooloose/nerdtree',
  'tpope/vim-sleuth',
  'neovim/nvim-lspconfig',
  'tpope/vim-fugitive',
  --'psliwka/vim-smoothie', -- Smooth scrolling
  {'nvim-treesitter/nvim-treesitter'},
  --'eandrju/cellular-automaton.nvim',
  'ojroques/nvim-osc52', -- Copy paste through terminal

  -- Themes
  'ellisonleao/gruvbox.nvim',
  'edeneast/nightfox.nvim',
  'catppuccin/nvim',
  'folke/tokyonight.nvim',
  'sainnhe/everforest',
  {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  },
  'nvim-tree/nvim-web-devicons',
  'nvim-tree/nvim-tree.lua',
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

})

local options = {
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  --autoindent = true,
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
  ensure_installed = {"c", "cpp", "python", "lua", "rust", "nix", "kotlin"},
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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup {
  view = {
    preserve_window_proportions = true,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
}


--[[
-- From https://shapeshed.com/vim-netrw/
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 4
vim.g.netrw_winsize = 25
--//
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

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('n', '<leader>c', '"+y')
vim.keymap.set('n', '<leader>cc', '"+yy')
