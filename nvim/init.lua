vim.g.mapleader = ';'

require("config.plugins").setup()

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

vim.cmd[[source ~/.config/vim/config/options.vim]]

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

require('config.keymap').setup()
