require("options")
require("keymaps")
-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
local plugins = {}

vim.list_extend(plugins, require("plugins.catppuccin"))
vim.list_extend(plugins, require("plugins.telescope"))
vim.list_extend(plugins, require("plugins.treesitter"))
vim.list_extend(plugins, require("plugins.lsp"))
vim.list_extend(plugins, require("plugins.dap"))
vim.list_extend(plugins, require("plugins.conform"))
vim.list_extend(plugins, require("plugins.autocomplete"))
vim.list_extend(plugins, require("plugins.neoscroll"))
vim.list_extend(plugins, require("plugins.lualine"))

require("lazy").setup(plugins, {})

require("plugins.lspsetup")
