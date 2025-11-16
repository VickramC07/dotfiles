return {
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
}
