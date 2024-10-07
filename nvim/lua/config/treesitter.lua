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

return {
  setup = function()
    require('nvim-treesitter.configs').setup(treesitter_config)
  end
}
