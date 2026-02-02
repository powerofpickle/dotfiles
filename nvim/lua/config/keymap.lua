local M = {}

local prefix = ';'

M.setup = function()
  vim.cmd[[source ~/.config/vim/config/keymap.vim]]

  vim.keymap.set('n', prefix .. 'yp', function()
    local relative_path = vim.fn.expand('%')
    local line_number = vim.fn.line('.')
    local result = relative_path .. ' ' .. line_number
    vim.fn.setreg('+', result)
    print('Copied: ' .. result)
  end, {desc = 'Copy relative path with line number' })

  vim.keymap.set('v', prefix .. 'yp', function()
    local relative_path = vim.fn.expand('%')

    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')

    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    local result = relative_path .. ' ' .. start_line .. ' ' .. end_line
    vim.fn.setreg('+', result)
    print('Copied: ' .. result)
  end, {desc = 'Copy relative path with line number' })

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

M.which_key = {
  {  -- From example config
    "<leader>?",
    function()
      require("which-key").show({ global = false })
    end,
    desc = "Buffer Local Keymaps (which-key)",
  },
  {
    prefix .. "?",
    function()
      require("which-key").show({ global = true })
    end,
    desc = "Global Keymaps (which-key)",
  },
}

M.setup_nvim_tree = function()
  vim.keymap.set('n', '<space>t', ':NvimTreeToggle<CR>') -- Toggle sidebar
  vim.keymap.set('n', '<space>f', ':NvimTreeFindFile<CR>')
  vim.keymap.set('n', prefix .. 'tt', ':NvimTreeToggle<CR>') -- Toggle sidebar
  vim.keymap.set('n', prefix .. 'tf', ':NvimTreeFindFile<CR>')

  local function cd_to_nvim_tree_root()
    local core = require('nvim-tree.core')
    local path = core.get_explorer().absolute_path
    print('Changing PWD to ' .. path)
    vim.cmd("cd " .. path)
  end
  vim.keymap.set('n', prefix .. 'cr', cd_to_nvim_tree_root)
end

M.setup_telescope = function()
  local telescope = require('telescope')
  telescope.setup {
    defaults = {
      layout_strategy = "vertical",
      path_display = {"truncate"},
    },
  }

  local builtin = require('telescope.builtin')

  -- Telescope Default Bindings
  vim.keymap.set('n', prefix .. 'ff', builtin.find_files, {})
  vim.keymap.set('n', prefix .. 'fg', builtin.live_grep, {})
  local buffer_view = function()
    builtin.buffers({
      sort_mru = true,
      sort_lastused = true,
      --ignore_current_buffer=true,
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
