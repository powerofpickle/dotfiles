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

--vim.keymap.set('n', '<C-i>', ':NERDTreeToggle<CR>') -- Toggle sidebar
vim.keymap.set('n', '<C-i>', ':NvimTreeToggle<CR>') -- Toggle sidebar

-- Center cursor after movements
--[[
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
--]]

vim.g.mapleader = ';'

vim.keymap.set('n', '<leader>f', ':NERDTreeFind<CR>') -- Focus sidebar on current file

-- Surround selection with parentheses or quotes
vim.keymap.set('v', '((', '"sc(<C-r>s)<Esc>', opts)
vim.keymap.set('v', '""', '"sc"<C-r>s"<Esc>', opts)

-- Cellular automaton
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")

local builtin = require('telescope.builtin')

-- Telescope Default Bindings
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local telescope_keys = {
    -- FZF Backwards Compatibility
    ['<leader><space>'] = builtin.find_files,
    ['<leader>b'] = builtin.buffers,
    ['<leader>r'] = builtin.live_grep,

    ['<leader>fr'] = builtin.resume,
    ['<leader>fp'] = builtin.builtin,

    ['<leader>ls'] = builtin.lsp_dynamic_workspace_symbols,
    ['<leader>lr'] = builtin.lsp_references,
    ['<leader>gc'] = builtin.git_commits,
    ['<leader>gs'] = builtin.git_status,
}

for lhs, rhs in pairs(telescope_keys) do
    vim.keymap.set('n', lhs, rhs, opts)
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)
