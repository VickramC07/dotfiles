return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            size = 20,
            open_mapping = [[<c-\>]],
            shade_terminals = true,
            direction = "float",
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            -- Lazygit terminal
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _LAZYGIT_TOGGLE()
                lazygit:toggle()
            end

            -- Keymap: <leader>fg
            vim.keymap.set("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazy Git" })
        end,
    },
}
