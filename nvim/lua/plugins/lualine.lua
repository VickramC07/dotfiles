return {
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
