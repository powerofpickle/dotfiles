local treesitter_config = {
  ensure_installed = {"c", "cpp", "python", "lua", "rust", "nix", "kotlin", "tablegen"},
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

local plugin_version = function()
  local nvim_version = vim.version()
  if nvim_version.major == 0 and nvim_version.minor < 10 then
    --return 'cfc6f2c117aaaa82f19bcce44deec2c194d900ab' last good commit
    return 'v0.9.3'
  else
    --return nil -- latest commit
    return '*' -- latest tagged commit
  end
end

return {
  setup = function()
    require('nvim-treesitter.configs').setup(treesitter_config)
  end,
  plugin_version = plugin_version,
}
