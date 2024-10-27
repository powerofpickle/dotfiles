-- Add cd functionality to nvim-tree
local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local core = require("nvim-tree.core")

  api.config.mappings.default_on_attach(bufnr)

  local function change_pwd()
    local node = core.get_explorer():get_node_at_cursor()
    local path
    if node.parent == nil then
      path = core.get_cwd()
    else
      path = node:last_group_node().absolute_path
      if node.type ~= "directory" then
        path = vim.fn.fnamemodify(path, ":h")
      end
    end
    print('Changing PWD to ' .. path)
    vim.cmd("cd " .. path)
  end

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', 'cd', change_pwd, opts('Change PWD'))
end

local performance_mode = require('config.settings').nvim_tree_performance_mode

local nvim_tree_config = {
  view = {
    preserve_window_proportions = true,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  on_attach = nvim_tree_on_attach,
  git = {
    enable = not performance_mode,
    timeout = 400, -- TODO
  },
  filesystem_watchers = {
    enable = not performance_mode,
  },
}

local setup_nvim_tree = function()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  require("nvim-tree").setup(nvim_tree_config)
end

return {
  setup = setup_nvim_tree,
}
