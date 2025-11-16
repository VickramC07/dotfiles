-- =========================
-- Basic settings
-- =========================
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.mapleader = " "
vim.o.completeopt = "menuone,noselect" -- always show autocomplete
vim.keymap.set("n", "<Enter>", "o<esc>", { desc = "Enter new line below" })
vim.keymap.set("n", "<S-Enter>", "O<esc>", { desc = "Enter new line above" })
vim.keymap.set("n", "<Up>", "k$", { desc = "up to end of line" })
vim.keymap.set("n", "<Down>", "a{<CR>}<Left><CR><Up><Tab>", { desc = "new parenthesis" })
vim.keymap.set("n", "<Left>", "_", { desc = "start of line" })
vim.keymap.set("n", "<Right>", "$", { desc = "end of line" })

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
local plugins = {
    -- Colorscheme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- Telescope
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Mason + LSP + DAP + Formatter
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "jay-babu/mason-nvim-dap.nvim" },
    { "mfussenegger/nvim-dap" },
    { "stevearc/conform.nvim" },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets", -- ES7/React snippets
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- Load VSCode-format snippets (includes ES7/React)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Optional: snippet jump keys (no Tab conflicts)
            vim.keymap.set({ "i", "s" }, "<C-j>", function()
                if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-k>", function()
                if luasnip.jumpable(-1) then luasnip.jump(-1) end
            end, { silent = true })

            -- LSP capabilities for cmp
            local capabilities = cmp_nvim_lsp.default_capabilities()
            vim.g.lsp_capabilities = capabilities

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end
    },
        -- Snippets (adds ES7+ snippets for React/JS/TS)
    { "rafamadriz/friendly-snippets" },
        -- Neoscroll
    {
        "karb94/neoscroll.nvim",
        config = function()
            local neoscroll = require("neoscroll")

            neoscroll.setup({
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
                easing = "quadratic",
                hide_cursor = true,
            })

            local keymap = {
                ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end,
                ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end,
                ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
                ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
                ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false, duration = 100 }) end,
                ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false, duration = 100 }) end,
                ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end,
                ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
                ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end,
            }

            for key, func in pairs(keymap) do
                vim.keymap.set({ "n", "v", "x" }, key, func)
            end
        end,
    },
        -- luaLine
    {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- for filetype icons
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                section_separators = { left = "", right = "" },
                component_separators = { left = "󰫢", right = "󰫢" },
                disabled_filetypes = { "neo-tree", "lazy" },
                globalstatus = true, -- single statusline at bottom
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } }, -- relative path
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = { "neo-tree", "lazy", "mason" }, -- useful integrations
        })

        end,
    },
}

require("lazy").setup(plugins, {})

-- =========================
-- Colorscheme setup
-- =========================
require("catppuccin").setup({ flavour = "mocha", transparent_background = true, })
vim.cmd.colorscheme("catppuccin")

-- =========================
-- Telescope keymaps
-- =========================
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- =========================
-- Treesitter setup
-- =========================
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "javascript", "go", "typescript", "tsx"},
    highlight = { enable = true },
    indent = { enable = true },
})

-- =========================
-- Mason setup
-- =========================
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "clangd", "gopls", "ts_ls", "cssls"} })
require("mason-nvim-dap").setup({ ensure_installed = { "delve" } })

-- =========================
-- Conform formatter
-- =========================
require("conform").setup({
    formatters_by_ft = {
        go = { "gofmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

    },
})
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({})
end)

-- =========================
-- LSP setup
-- =========================
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
    capabilities = vim.g.lsp_capabilities,
    on_attach = function(client, bufnr)
        local buf_map = function(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
        end
        buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    end,
    settings = {
        gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true },
    },
})
-- React / JavaScript / TypeScript
lspconfig.ts_ls.setup({
    capabilities = vim.g.lsp_capabilities,
    on_attach = function(client, bufnr)
        -- Disable built-in formatting in favor of prettier
        client.server_capabilities.documentFormattingProvider = false

        local buf_map = function(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
        end
        buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    end,

    -- 👇 this enables auto-imports
    init_options = {
        preferences = {
            importModuleSpecifierPreference = "relative", -- or "non-relative"
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
        },
    },
})

-- CSS LS
lspconfig.cssls.setup({
    capabilities = vim.g.lsp_capabilities,
    on_attach = function(client, bufnr)
        local buf_map = function(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
        end
        buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    end,
})
-- =========================
-- DAP setup for Go
-- =========================
local dap = require("dap")
dap.adapters.go = {
    type = "executable",
    command = "dlv",
    args = { "dap" },
}
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
    },
}
