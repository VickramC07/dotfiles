return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "javascript", "go", "typescript", "tsx"},
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}
