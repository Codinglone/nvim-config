-- =========================
-- LEADER KEYS (must be first)
-- =========================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- =========================
-- BOOTSTRAP lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "--branch=stable", lazyrepo, lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- PLUGINS
-- =========================
require("lazy").setup({
  spec = {
    -- Theme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-tree").setup()
      end,
    },

    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup()
      end,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = { "c", "lua", "python", "rust", "javascript" },
        })
      end,
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.config("pyright", {})
        vim.lsp.config("rust_analyzer", {})
        vim.lsp.config("clangd", {})
        vim.lsp.enable({ "pyright", "rust_analyzer", "clangd" })
      end,
    },

    -- Autocomplete
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = "nvim_lsp" },
          },
        })
      end,
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup({
          options = { theme = "catppuccin" },
        })
      end,
    },
  },

  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
})

-- =========================
-- BASIC SETTINGS
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- =========================
-- COLORSCHEME
-- =========================
vim.cmd.colorscheme("catppuccin")

-- =========================
-- KEYMAPS
-- =========================
local keymap = vim.keymap

-- Explorer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")

-- Save
keymap.set("n", "<leader>w", ":w<CR>")

