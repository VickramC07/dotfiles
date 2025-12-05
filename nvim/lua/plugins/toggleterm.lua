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

            local run = Terminal:new({
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _RUN_TOGGLE()
                local util = require("lspconfig.util")
                local filepath  = vim.fn.expand("%:p")
                local ext       = vim.fn.expand("%:e")
                local cmd = "error filetype not supported"
                local filename  = vim.fn.expand("%:t")
                local classname = vim.fn.expand("%:t:r")
                local filedir   = vim.fn.expand("%:p:h")

                local root = util.root_pattern("pom.xml", "build.gradle", ".git")(filepath)
                or vim.fn.getcwd()

                -- compute relative folder path
                local relative_dir = filedir:sub(#root + 2) -- removes root + "/"

                -- build path to .java file
                local relative_file = relative_dir .. "/" .. filename

                -- build package-style class path (replace "/" with ".")
                local class_path = relative_dir:gsub("/", ".") .. "." .. classname

                if ext == "java" then
                    -- build the command
                    cmd = string.format("cd '%s' && javac '%s' && java '%s'", root, relative_file, class_path)
                end
                run.cmd = cmd
                run:toggle()
            end

            local buggy = Terminal:new({
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _RUN_BUGGY()
                local util = require("lspconfig.util")
                local filepath  = vim.fn.expand("%:p")
                local ext       = vim.fn.expand("%:e")
                local cmd = "error filetype not supported"
                local filename  = vim.fn.expand("%:t")
                local classname = vim.fn.expand("%:t:r")
                local filedir   = vim.fn.expand("%:p:h")

                local root = util.root_pattern("pom.xml", "build.gradle", ".git")(filepath)
                or vim.fn.getcwd()

                -- compute relative folder path
                local relative_dir = filedir:sub(#root + 2) -- removes root + "/"

                -- build path to .java file
                local relative_file = relative_dir .. "/" .. filename

                -- build package-style class path (replace "/" with ".")
                local class_path = relative_dir:gsub("/", ".") .. "." .. classname

                if ext == "java" then
                    -- build the command
                    cmd = string.format("cd '%s' && javac '%s' && java '%s'", root, relative_file, class_path)
                end
                buggy:toggle()
                buggy:send(cmd)
            end

            -- Keymap: <leader>t(whatever it opens)
            vim.keymap.set("n", "<leader>tl", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "toggle/terminal: lazygit" })
            vim.keymap.set("n", "<leader>tb", "<cmd>lua _BLANK_TOGGLE()<CR>", { desc = "toggle/terminal: blank(cwd)" })
            vim.keymap.set("n", "<leader>ty", "<cmd>lua _YAZI_TOGGLE()<CR>", { desc = "toggle/terminal: YAZI" })
            vim.keymap.set("n", "<leader>tr", "<cmd>lua _RUN_TOGGLE()<CR>", { desc = "toggle/terminal: run(compile&run program) closes after exit" })
            vim.keymap.set("n", "<leader>td", "<cmd>lua _RUN_BUGGY()<CR>", { desc = "toggle/terminal: run(compile&run program) stays open after exit" })
        end,
    },
}
