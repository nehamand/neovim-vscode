--[[
  VSCode Neovim Configuration
  
  A minimal configuration optimized specifically for the VSCode Neovim extension.
  Includes only essential vim options and keymaps for VSCode integration.
]]--

-- ============================================================================
-- GENERAL OPTIONS
-- ============================================================================

-- Line numbering
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Use relative line numbers

-- Indentation
vim.opt.tabstop = 2            -- Number of spaces a tab counts for
vim.opt.softtabstop = 2        -- Number of spaces a tab counts for during editing operations
vim.opt.shiftwidth = 2         -- Number of spaces to use for auto-indenting
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.smartindent = true     -- Smart autoindenting when starting a new line

-- Search
vim.opt.ignorecase = true      -- Ignore case in search patterns
vim.opt.smartcase = true       -- Override ignorecase if search pattern contains uppercase
vim.opt.hlsearch = true        -- Highlight search results
vim.opt.incsearch = true       -- Show matches as you type

-- Text editing
vim.opt.wrap = false           -- Don't wrap lines
vim.opt.scrolloff = 8          -- Minimum number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8      -- Minimum number of columns to keep left/right of cursor
vim.opt.virtualedit = "block"  -- Allow cursor to move where there is no text in visual block mode

-- Miscellaneous
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.updatetime = 50        -- Faster update time for better user experience
vim.opt.timeoutlen = 300       -- Time to wait for a mapped sequence to complete (in ms)
vim.opt.undofile = true        -- Enable persistent undo

-- ============================================================================
-- VSCODE-SPECIFIC OPTIONS
-- ============================================================================

-- VSCode detection and integration
if vim.g.vscode then
  -- Sync clipboard with VSCode
  vim.opt.clipboard = "unnamedplus"
  
  -- VSCode-specific globals
  vim.g.vscode_clipboard = true
end

-- ============================================================================
-- KEYMAPPINGS
-- ============================================================================

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation through VSCode commands
vim.keymap.set("n", "<C-h>", function() vim.fn.VSCodeNotify('workbench.action.navigateLeft') end)
vim.keymap.set("n", "<C-j>", function() vim.fn.VSCodeNotify('workbench.action.navigateDown') end)
vim.keymap.set("n", "<C-k>", function() vim.fn.VSCodeNotify('workbench.action.navigateUp') end)
vim.keymap.set("n", "<C-l>", function() vim.fn.VSCodeNotify('workbench.action.navigateRight') end)

-- Window management
vim.keymap.set("n", "<leader>v", function() vim.fn.VSCodeNotify('workbench.action.splitEditorRight') end)
vim.keymap.set("n", "<leader>s", function() vim.fn.VSCodeNotify('workbench.action.splitEditorDown') end)
vim.keymap.set("n", "<leader>q", function() vim.fn.VSCodeNotify('workbench.action.closeActiveEditor') end)

-- File navigation
vim.keymap.set("n", "<leader>e", function() vim.fn.VSCodeNotify('workbench.action.toggleSidebarVisibility') end)
vim.keymap.set("n", "<leader>f", function() vim.fn.VSCodeNotify('workbench.action.quickOpen') end)
vim.keymap.set("n", "<leader>b", function() vim.fn.VSCodeNotify('workbench.action.showAllEditors') end)

-- Search
vim.keymap.set("n", "<leader>/", function() vim.fn.VSCodeNotify('workbench.action.findInFiles') end)
vim.keymap.set("n", "<leader>sr", function() vim.fn.VSCodeNotify('editor.action.startFindReplaceAction') end)

-- Code actions
vim.keymap.set("n", "gd", function() vim.fn.VSCodeNotify('editor.action.revealDefinition') end)
vim.keymap.set("n", "gr", function() vim.fn.VSCodeNotify('editor.action.goToReferences') end)
vim.keymap.set("n", "K", function() vim.fn.VSCodeNotify('editor.action.showHover') end)
vim.keymap.set("n", "<leader>ca", function() vim.fn.VSCodeNotify('editor.action.quickFix') end)
vim.keymap.set("n", "<leader>rn", function() vim.fn.VSCodeNotify('editor.action.rename') end)

-- Moving lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste/delete operations
vim.keymap.set("x", "<leader>p", "\"_dP")         -- Paste over selection without losing buffer
vim.keymap.set("n", "<leader>d", "\"_d")          -- Delete without yanking
vim.keymap.set("v", "<leader>d", "\"_d")

-- Clear search highlighting
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- Commenting (uses VSCode's commenting capabilities)
vim.keymap.set({"n", "v"}, "gc", function() vim.fn.VSCodeNotify('editor.action.commentLine') end)
vim.keymap.set({"n", "v"}, "gb", function() vim.fn.VSCodeNotify('editor.action.blockComment') end)

-- ============================================================================
-- AUTO COMMANDS
-- ============================================================================

-- Create an auto-command group for our custom commands
local augroup = vim.api.nvim_create_augroup("VSCodeNeovim", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- ============================================================================

-- Disable netrw (not needed in VSCode)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable unused built-in plugins for faster startup
local disabled_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "spellfile_plugin",
  "matchit",
  "rrhelper",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
