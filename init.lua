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
  {
  'neovim/nvim-lspconfig',
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
  },
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
  "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    }
  },
  'mhinz/vim-mix-format',
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
   -- DAP (Debug Adapter Protocol) plugins
  {
    'mfussenegger/nvim-dap',
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'mfussenegger/nvim-dap-python',  -- Python adapter
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'leoluz/nvim-dap-go',  -- Go adapter
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      },
    opts = {
    strategies = {
      -- Change the default chat adapter and model
      chat = {
        adapter = "anthropic",
        model = "claude-sonnet-4-20250514"
        },
      },
    },
  },
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
require('mason').setup()
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
    ensure_installed = { "pyright", "zls", "svelte" }
}
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
lspconfig.ruff.setup {
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'kotlin', "elixir", "eex", "heex", "svelte"  },

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
  require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})

-- DAP (Debug Adapter Protocol) Setup
local dap = require('dap')
local dapui = require('dapui')
local dap_virtual_text = require('nvim-dap-virtual-text')

-- Configure DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- Configure DAP Virtual Text
dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil
})

-- Configure Python DAP
-- -- Use the Python from our dedicated debugpy virtual environment
local debugpy_python = vim.fn.expand('~/.debugpy-env/.venv/bin/python')
require('dap-python').setup(debugpy_python)

-- Load Docker remote debugging configuration
require('dap-docker')


-- Autocommands
vim.api.nvim_create_augroup('GO_LSP', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'GO_LSP',
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.formatting()
  end
})

-- DAP Event Listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
--dap.listeners.before.event_terminated["dapui_config"] = function()
  --dapui.close()
--end
--dap.listeners.before.event_exited["dapui_config"] = function()
  --dapui.close()
--end
---- Instead, modify behavior to preserve the UI after termination
dap.listeners.before.event_terminated["dapui_config"] = function()
  -- Keep UI open, but add a message to the REPL
  require('dap.repl').append('Program terminated. UI kept open for inspection.')
end
dap.listeners.before.event_exited["dapui_config"] = function()
  -- Keep UI open, but add a message to the REPL
  require('dap.repl').append('Program exited. UI kept open for inspection.')
end

-- DAP Keymappings
vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "Debug: Continue" })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "Debug: Run Last" })
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "Debug: Open REPL" })
vim.keymap.set('n', '<Leader>dui', function() dapui.toggle() end, { desc = "Debug: Toggle UI" })

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
  vim.keymap.set('n', '<leader>gsd', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>gn', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>gp', vim.diagnostic.goto_prev, opts)
end

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = true,      -- Show errors inline
  signs = true,             -- Show signs in the gutter
  underline = true,         -- Underline errors
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true,     -- Sort by severity
  float = {
    border = "rounded",
    source = "always",
  },
})


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
