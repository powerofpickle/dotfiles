
local opts = {noremap=true, silent=true}

keys = {'h', 'j', 'k', 'l'}
for _, key in pairs(keys) do
    lhs = string.format("<C-%s>", key)
    rhs = string.format("<C-w>%s", key)

    vim.keymap.set("n", lhs, rhs, opts) -- Normal mode
    vim.keymap.set("i", lhs, "<C-\\><C-N>" .. rhs, opts) -- Insert mode
end

vim.keymap.set('n', '<C-n>', ':bn<CR>') -- Next buffer in list
vim.keymap.set('n', '<C-p>', ':bp<CR>') -- Previous buffer in list
vim.keymap.set('n', '<C-s>', ':b#<CR>') -- Previous buffer you were in, <C-#>
vim.keymap.set('n', '<C-i>', ':NERDTreeToggle<CR>') -- Previous buffer you were in, <C-#>

-- Center cursor after movements
--[[
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
--]]

vim.g.mapleader = ';'

local fzf_keys = {
    ['<leader><space>'] = ':Files<CR>',
    ['<leader>b'] = ':Buffers<CR>',
    ['<leader>w'] = ':Windows<CR>',
    ['<leader>;'] = ':BLines<CR>',
    ['<leader>o'] = ':BTags<CR>',
    ['<leader>t'] = ':Tags<CR>',
    ['<leader>?'] = ':History<CR>',
    ['<leader>/'] = ':execute \'Ag \' . input(\'Ag/\')<CR>',
    ['<leader>.'] = ':AgIn ',
    ['<leader>r'] = ':Rg<CR>'
}

for lhs, rhs in pairs(fzf_keys) do
    vim.keymap.set('n', lhs, rhs, opts)
end

-- Surround selection with parentheses or quotes
vim.keymap.set('v', '((', '"sc(<C-r>s)<Esc>', opts)
vim.keymap.set('v', '""', '"sc"<C-r>s"<Esc>', opts)
