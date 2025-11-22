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
                    java = { "google-java-format" },
                    lua = { "stylua" },
                },
                formatters = {
                    ["google-java-format"] = {
                        prepend_args = { "--aosp" },
                    },
                },
            })
            vim.keymap.set("n", "<leader>ff", function()
                require("conform").format()
            end, { desc = "format file" })
        end,
    },
}
