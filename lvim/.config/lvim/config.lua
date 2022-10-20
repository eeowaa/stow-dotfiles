-- General
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "jellybeans-nvim"
vim.opt.scrolloff = 0
vim.opt.number = false
vim.opt.signcolumn = "auto" -- left margin (disable with `:se scl=no`)
vim.opt.linebreak = true

-- TODO: Figure out how to do the following (it causes errors)
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- Keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- Add your own keymappings
--[[
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
]]

-- Unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")

-- Override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"
-- or vim.keymap.set("n", "<C-q>", ":q<cr>")

lvim.keys.normal_mode["="] = "<c-w>+"
lvim.keys.normal_mode["-"] = "<c-w>-"
lvim.keys.normal_mode["_"] = "<c-w><"
lvim.keys.normal_mode["+"] = "<c-w>>"
-- TODO: <c-u> and <c-k>
vim.api.nvim_set_keymap("c", "<c-a>", "<home>", {noremap = false})
vim.api.nvim_set_keymap("c", "<c-e>", "<end>", {noremap = false})
vim.api.nvim_set_keymap("c", "<c-d>", "<delete>", {noremap = false})
vim.api.nvim_set_keymap("c", "<c-f>", "<right>", {noremap = false})
vim.api.nvim_set_keymap("c", "<c-b>", "<left>", {noremap = false})
vim.api.nvim_set_keymap("i", "<c-a>", "<home>", {noremap = false})
vim.api.nvim_set_keymap("i", "<c-e>", "<end>", {noremap = false})
vim.api.nvim_set_keymap("i", "<c-d>", "<delete>", {noremap = false})
vim.api.nvim_set_keymap("i", "<c-f>", "<right>", {noremap = false})
vim.api.nvim_set_keymap("i", "<c-b>", "<left>", {noremap = false})

-- Change Telescope navigation
--[[
-- use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
]]

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
--[[
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
]]

-- User config for predefined plugins
-- After changing plugin config:
-- 1. Exit and reopen LunarVim,
-- 2. Run :PackerInstall
-- 3. Run :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.indentlines.active = false
lvim.builtin.breadcrumbs.active = true
lvim.builtin.bufferline.active = false
vim.opt.showtabline = 1

-- Disable autocomplete
local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false
  }
}

-- If you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

-- Treesitter config
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
-- TODO: Enable treesitter-based folding where possible
-- https://www.reddit.com/r/neovim/comments/kx2nnj/treesitter_and_folding/
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- Generic LSP settings

-- Install servers in the skipped_servers list
--[[
lvim.lsp.installer.setup.ensure_installed = {
    "sumneko_lua",
    "jsonls",
}
]]

-- Change UI setting of `LspInstallInfo`
--[[
-- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
lvim.lsp.installer.setup.ui.border = "rounded"
lvim.lsp.installer.setup.ui.keymaps = {
    uninstall_server = "d",
    toggle_server_expand = "o",
}
]]

-- Disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- Configure a server manually
--[[
-- !!Requires `:LvimCacheReset` to take effect!!
-- see the full default list via
-- `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pyright", opts)
]]
vim.list_extend(lvim.lsp.automatic_configuration.skipped_filetypes, { "helm" })

-- Remove a server from the skipped list
--[[
-- !!Requires `:LvimCacheReset` to take effect!!
-- `:LvimInfo` lists which server(s) are skipped for the current filetype
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "emmet_ls"
end, lvim.lsp.automatic_configuration.skipped_servers)
]]

-- Define a custom on_attach function for all language servers
--[[
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end
]]
lvim.lsp.on_attach_callback = function(client, bufnr)
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- disable virtual text
      virtual_text = false,

      -- show signs
      signs = true,

      -- delay update diagnostics
      update_in_insert = false,
    }
  )
end

-- Set additional formatters
--[[
-- This will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",

    -- arguments to pass to the formatter;
    -- options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with", "100" },

    -- specify which filetypes to enable;
    -- by default, a provider will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact" },
  },
}
]]

-- Set additional linters
--[[
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    -- each linter accepts a list of options identical to
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",

    -- arguments to pass to the linter;
    -- options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
  {
    command = "codespell",

    -- specify which filetypes to enable;
    -- by default, a provider will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}
]]

-- Additional Plugins
lvim.plugins = {
  -- Colorschemes
  {
    "rktjmp/lush.nvim",
    "metalelf0/jellybeans-nvim",
    cmd = "colorscheme jellybeans-nvim",
  },
  -- Git
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" },
  },
  -- Treesitter
  { "p00f/nvim-ts-rainbow", },
  -- General
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  { "tommcdo/vim-lion", },
  { "tpope/vim-repeat", },
  {
    "tpope/vim-surround",
    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
      --  vim.o.timeoutlen = 500
    -- end
  },
  { "tpope/vim-unimpaired", },
  -- Language-specific
  { "towolf/vim-helm", },
  { "bfrg/vim-jq", },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
--[[
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})
]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm",
  callback = function()
    vim.lsp.start({
      name = 'helm-lint-ls',
      cmd = {'helm-lint-ls', 'serve'},
      root_dir = vim.fs.dirname(vim.fs.find({'Chart.yaml', 'values.yaml'}, { upward = true })[1]),
    })
  end,
})
