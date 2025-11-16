return {
    {
        "stevearc/conform.nvim",
        config = function()
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
        end,
    },
}
