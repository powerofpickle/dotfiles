local plugin_config = {
  -- vim plugins
  'scrooloose/nerdtree',
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',
  --'psliwka/vim-smoothie', -- Smooth scrolling

  -- Themes
  'ellisonleao/gruvbox.nvim',
  'edeneast/nightfox.nvim',
  'catppuccin/nvim',
  'folke/tokyonight.nvim',
  'sainnhe/everforest',

  'nvim-tree/nvim-web-devicons',
  --'eandrju/cellular-automaton.nvim',
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = require("config.lsp").setup,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    config = require("config.treesitter").setup,
    version = require("config.treesitter").plugin_version(),
  },
  {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = require("config.keymap").setup_telescope,
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = require("config.nvim-tree").setup,
    version = "*",
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({ replace_netrw = true })
      vim.api.nvim_set_keymap("n", ";ef", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
      vim.api.nvim_set_keymap("n", ";eg", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(false)
        end,
      })
    end,
  },
}

if require('config.avante').enable_avante then
  local avante_config = require('config.avante').lazy_config(
    "yetone/avante.nvim"
  )
  plugin_config[#plugin_config+1] = avante_config
end

if require('config.osc52').osc52_plugin_needed() then
  -- Copy paste through terminal
  -- TODO: remove once no longer needed
  plugin_config[#plugin_config+1] = {
    'ojroques/nvim-osc52',
    init = require('config.osc52').init,
  }
end

local setup_lazy = function(lazy_config)
  -- Install lazy.nvim if not installed
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

  require("lazy").setup(lazy_config)
end

return {
  setup = function()
    setup_lazy(plugin_config)
  end,
}
