local M = {}

M.setup = function()
  local opts = {noremap=true, silent=true}

  vim.cmd[[source ~/.config/vim/config/keymap.vim]]

  --vim.keymap.set('n', '<C-i>', ':NERDTreeToggle<CR>') -- Toggle sidebar
  vim.keymap.set('n', '<C-i>', ':NvimTreeToggle<CR>') -- Toggle sidebar

  -- Center cursor after movements
  --[[
  vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
  vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
  --]]

  --vim.g.mapleader = ';'
  vim.cmd[[
    let mapleader = ';'
  ]]

  vim.keymap.set('n', '<leader>f', ':NERDTreeFind<CR>') -- Focus sidebar on current file

  -- Cellular automaton
  --vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
end

M.setup_telescope = function()
  local builtin = require('telescope.builtin')

  -- Telescope Default Bindings
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  local buffer_view = function()
    builtin.buffers({
      sort_mru=true,
      ignore_current_buffer=true,
    })
  end
  vim.keymap.set('n', '<leader>fb', buffer_view, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

  local telescope_keys = {
    -- FZF Backwards Compatibility
    ['<leader><space>'] = builtin.find_files,
    ['<leader>b'] = buffer_view,
    ['<leader>r'] = builtin.live_grep,

    ['<leader>fr'] = builtin.resume,
    ['<leader>fp'] = builtin.builtin,

    ['<leader>ls'] = builtin.lsp_dynamic_workspace_symbols,
    ['<leader>lr'] = builtin.lsp_references,
    ['<leader>gc'] = builtin.git_commits,
    ['<leader>gbc'] = builtin.git_bcommits,
    ['<leader>gs'] = builtin.git_status,

    ['<leader>j'] = builtin.jumplist,
    --['<leader>k'] = builtin.keymaps,
    --['<leader>l'] = builtin.reloader,
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
end

return M
