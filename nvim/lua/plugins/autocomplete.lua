return {
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
}
