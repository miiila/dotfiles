-- Neovim Configuration in Lua

-- Bootstrap Lazy.nvim plugin manager if not installed
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

-- Keymappings
vim.g.mapleader = ' '
--
-- Disable compatibility with vi
vim.opt.compatible = false

-- Disable file type detection (will be re-enabled after plugin configuration)
vim.cmd('filetype off')

-- Set Python 3 host program
vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

-- Completion options
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

-- Vim options
vim.opt.number = true
vim.opt.relativenumber = true

-- Search Settings
vim.opt.hlsearch = false

-- Undo Settings
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true

-- Indentation Settings
vim.opt.tabstop = 2
vim.opt.softtabstop = -1  -- Use tabstop value
vim.opt.shiftwidth = 0    -- Use tabstop value
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Buffer Settings
vim.opt.hidden = true

-- Update Time
vim.opt.updatetime = 100

-- Plugin Specifications
require("lazy").setup({
  -- Theme
  'joshdick/onedark.vim',

  -- Autocomplete and LSP
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',

  -- Required by cmp
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  -- Coding tools
  'preservim/nerdcommenter',
  'airblade/vim-gitgutter',
  'tpope/vim-fugitive',

  -- Telescope (FZF Replacement)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Syntax highlighting
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  'cespare/vim-toml',
  'stephpy/vim-yaml',
  'plasticboy/vim-markdown',

  -- Python
  {
    'averms/black-nvim',
    build = ':UpdateRemotePlugins'
  },
  'mhinz/vim-mix-format'
})

-- LSP and Completion Setup
local cmp = require'cmp'
local lspconfig = require'lspconfig'

-- CMP Configuration
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }
})

-- Capabilities for LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Language Server Configurations
lspconfig.pyright.setup {
  capabilities = capabilities
}

lspconfig.gopls.setup {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
}

lspconfig.ts_ls.setup {}
lspconfig.cssls.setup { capabilities = capabilities }
lspconfig.volar.setup {
  filetypes = {'vue'},
  init_options = {
    typescript = {
      tsdk = '/Users/miiila/.fnm/node-versions/v20.2.0/installation/lib/node_modules/typescript/lib/'
    }
  }
}
lspconfig.html.setup { capabilities = capabilities }
lspconfig.elixirls.setup { cmd = { "/Users/miiila/code/elixir-ls/release/language_server.sh", capabilities = capabilities } }
lspconfig.clangd.setup{ init_options = {
    fallbackFlags = { '-std=c++20' },
  }
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'kotlin', "elixir", "eex", "heex"  },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)


-- Autocommands
vim.api.nvim_create_augroup('GO_LSP', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'GO_LSP',
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.formatting()
  end
})


-- LSP Keymaps
local function set_lsp_keymaps()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>gsh', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>grr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>gh', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>gca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>gsd', function()
    vim.lsp.diagnostic.show_line_diagnostics()
    vim.lsp.util.show_line_diagnostics()
  end, opts)
  -- vim.keymap.set('n', '<leader>gn', vim.lsp.diagnostic.goto_next, opts)
end

set_lsp_keymaps()

-- Telescope Keymaps
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>', { noremap = true })
vim.keymap.set('n', '<leader>;', ':Telescope buffers<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>', { noremap = true })

-- Additional Editor Settings
vim.cmd('syntax on')
vim.cmd('colorscheme onedark')

-- Line Numbers

-- Re-enable file type detection after plugin configuration
vim.cmd('filetype plugin indent on')

-- Create custom write command
vim.api.nvim_create_user_command('W', 'w', {})
