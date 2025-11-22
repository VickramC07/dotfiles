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

            local blank = Terminal:new({
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _BLANK_TOGGLE()
                blank:toggle()
            end

            local yazi = Terminal:new({
                cmd = "yazi",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _YAZI_TOGGLE()
                yazi:toggle()
            end

            -- Keymap: <leader>t(whatever it opens)
            vim.keymap.set("n", "<leader>tl", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "toggle/terminal: lazygit" })
            vim.keymap.set("n", "<leader>tb", "<cmd>lua _BLANK_TOGGLE()<CR>", { desc = "toggle/terminal: blank(cwd)" })
            vim.keymap.set("n", "<leader>ty", "<cmd>lua _YAZI_TOGGLE()<CR>", { desc = "toggle/terminal: YAZI" })
        end,
    },
}
