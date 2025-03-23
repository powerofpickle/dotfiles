local M = {}

local prefix = ';'

M.setup = function()
  vim.cmd[[source ~/.config/vim/config/keymap.vim]]

  -- Center cursor after movements
  --[[
  local opts = {noremap=true, silent=true}
  vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
  vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
  --]]

  -- Cellular automaton
  --vim.keymap.set("n", prefix .. "fml", "<cmd>CellularAutomaton make_it_rain<CR>")
end

M.boole_mappings = {
  increment = '<C-a>',
  decrement = '<C-x>',
}

M.setup_nvim_tree = function()
  vim.keymap.set('n', '<C-i>', ':NvimTreeToggle<CR>') -- Toggle sidebar
  vim.keymap.set('n', prefix .. 'f', ':NvimTreeFindFile<CR>')
end

M.setup_telescope = function()
  local builtin = require('telescope.builtin')

  -- Telescope Default Bindings
  vim.keymap.set('n', prefix .. 'ff', builtin.find_files, {})
  vim.keymap.set('n', prefix .. 'fg', builtin.live_grep, {})
  local buffer_view = function()
    builtin.buffers({
      sort_mru=true,
      ignore_current_buffer=true,
    })
  end
  vim.keymap.set('n', prefix .. 'fb', buffer_view, {})
  vim.keymap.set('n', prefix .. 'fh', builtin.help_tags, {})

  local telescope_keys = {
    -- FZF Backwards Compatibility
    ['<space>'] = builtin.find_files,
    ['b'] = buffer_view,
    ['r'] = builtin.live_grep,

    ['fr'] = builtin.resume,
    ['fp'] = builtin.builtin,

    ['ls'] = builtin.lsp_dynamic_workspace_symbols,
    ['lr'] = builtin.lsp_references,
    ['gc'] = builtin.git_commits,
    ['gbc'] = builtin.git_bcommits,
    ['gs'] = builtin.git_status,

    ['j'] = builtin.jumplist,
    --['k'] = builtin.keymaps,
    --['l'] = builtin.reloader,
  }

  for lhs, rhs in pairs(telescope_keys) do
    vim.keymap.set('n', prefix .. lhs, rhs, opts)
  end

  vim.api.nvim_set_keymap(
    "n",
    prefix .. "fb",
    ":Telescope file_browser<CR>",
    { noremap = true }
  )
end

return M
