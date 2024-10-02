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

local lazy_config = {
  'scrooloose/nerdtree',
  'tpope/vim-sleuth',
  'neovim/nvim-lspconfig',
  'tpope/vim-fugitive',
  --'psliwka/vim-smoothie', -- Smooth scrolling
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false
  },
  --'eandrju/cellular-automaton.nvim',
  'ojroques/nvim-osc52', -- Copy paste through terminal

  -- Themes
  'ellisonleao/gruvbox.nvim',
  'edeneast/nightfox.nvim',
  'catppuccin/nvim',
  'folke/tokyonight.nvim',
  'sainnhe/everforest',
  {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  },
  'nvim-tree/nvim-web-devicons',
  'nvim-tree/nvim-tree.lua',
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

local enable_avante = false

if enable_avante then
  lazy_config[#lazy_config+1] = {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      claude = {
        api_key_name = "cmd:anthropic-key",
      },
      hints = { enabled = false },
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
end

vim.g.mapleader = ';'

require("lazy").setup(lazy_config)

local options = {
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  --autoindent = true,
  hidden = true,
  hlsearch = false, -- Don't highlight search results
  autoread = true,
  relativenumber = true,
  termguicolors = true,
  signcolumn = 'yes',
  cmdheight = 1,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

require('nvim-treesitter.configs').setup {
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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Add cd functionality to nvim-tree
local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local core = require("nvim-tree.core")
  local lib = require("nvim-tree.lib")

  api.config.mappings.default_on_attach(bufnr)

  local function change_pwd()
    local node = lib.get_node_at_cursor()
    local path
    if node.parent == nil then
      path = core.get_cwd()
    else
      path = lib.get_last_group_node(node).absolute_path
      if node.type ~= "directory" then
        path = vim.fn.fnamemodify(path, ":h")
      end
    end
    print('Changing PWD to ' .. path)
    vim.uv.chdir(path)
  end

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', 'cd', change_pwd, opts('Change PWD'))
end

require("nvim-tree").setup({
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
    enable = true,
    timeout = 400, -- TODO
  }
})


--[[
-- From https://shapeshed.com/vim-netrw/
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 4
vim.g.netrw_winsize = 25
--//
--[[
vim.cmd[[
  augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * :Vexplore
  augroup END
]]
--]]

-- Set color scheme
--vim.cmd.colorscheme "base16-ocean"
--vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin-macchiato"

-- Make background same as terminal
for _, hl_group in pairs({
  'Normal',
  -- 'LineNr', Changes text color, fix later
  'NormalFloat',
  -- 'FloatBorder',
  -- 'Pmenu',
  -- 'PmenuSel',
  -- 'PmenuSbar',
  -- 'PmenuThumb',
  'SignColumn',
  -- 'VertSplit',
}) do
  vim.api.nvim_set_hl(0, hl_group, {bg = "none"})
end

-- Remove this once text color issue is fixed
vim.cmd[[
  highlight LineNr ctermbg=none guibg=none
]]

-- Show relative numbers when buffer is focused, otherwise show absolute numbers
vim.cmd[[
  set number
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
]]


-- Remove help indicator at top of NERDTree
vim.cmd[[let NERDTreeMinimalUI=1]]

-- Prevents filename from being searched with regex search
vim.cmd[[
  command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]

vim.cmd[[set completeopt-=preview]]

vim.cmd[[
  set path+=**
  set wildmenu
]]

require('config.keymap')
require('config.lsp')

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('n', '<leader>c', '"+y')
vim.keymap.set('n', '<leader>cc', '"+yy')
