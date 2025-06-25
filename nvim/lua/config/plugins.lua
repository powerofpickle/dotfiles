local plugin_config = {
  -- vim plugins
  --'psliwka/vim-smoothie', -- Smooth scrolling
  --'scrooloose/nerdtree',  -- Messing with OSC52 clipboard
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',
  'Vimjas/vim-python-pep8-indent',

  -- Themes
  'ellisonleao/gruvbox.nvim',
  'edeneast/nightfox.nvim',
  'catppuccin/nvim',
  'folke/tokyonight.nvim',
  'sainnhe/everforest',

  {
    'nat-418/boole.nvim',
    config = function()
      require('boole').setup({
        mappings = require("config.keymap").boole_mappings,
      })
    end
  },
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
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',

      'hrsh7th/cmp-nvim-lsp',

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}

if require('config.settings').enable_copilot then
  plugin_config[#plugin_config+1] = {
    'github/copilot.vim',
  }
end

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
