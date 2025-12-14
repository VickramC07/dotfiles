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

            -- helper function to find cmd in auto-run
            function Find_cmd()
                local util = require("lspconfig.util")
                local filepath  = vim.fn.expand("%:p")
                local ext       = vim.fn.expand("%:e")
                local cmd = "echo 'error filetype not supported'"
                local filename  = vim.fn.expand("%:t")
                local filedir   = vim.fn.expand("%:p:h")

                local root = util.root_pattern("pom.xml", "build.gradle", ".git")(filepath)
                or vim.fn.getcwd()

                -- find relative folder path
                local relative_dir = filedir:sub(#root + 2) -- removes root + "/"

                -- build path to file
                local relative_file =
                (relative_dir ~= "" and relative_dir .. "/" .. filename) or filename

                -- JAVA
                if ext == "java" then
                    local classname = vim.fn.expand("%:t:r")
                    local class_path = relative_dir:gsub("/", ".") .. "." .. classname
                    class_path = (relative_dir ~= "" and class_path) or classname
                    cmd = string.format(
                        "cd '%s' && javac '%s' && java '%s'",
                        root, relative_file, class_path
                    )

                -- PYTHON3
                elseif ext == "py" then
                    local function find_venv(start_dir)
                        local candidates = { "venv", ".venv", "env", ".env" }
                        local dir = start_dir

                        while dir do
                            for _, name in ipairs(candidates) do
                                local full = dir .. "/" .. name
                                if vim.fn.isdirectory(full) == 1 then
                                    -- must have bin/activate (Unix)
                                    if vim.fn.filereadable(full .. "/bin/activate") == 1 then
                                        return full
                                    end
                                end
                            end

                            local parent = vim.fn.fnamemodify(dir, ":h")
                            if parent == dir then break end
                            dir = parent
                        end

                        return nil
                    end
                    local venv_path = find_venv(filedir)
                    local activate_prefix = ""
                    if venv_path then
                        activate_prefix = string.format("source '%s/bin/activate' && ", venv_path)
                    end
                    cmd = string.format(
                        "cd '%s' && %spython3 '%s'",
                        root, activate_prefix, relative_file
                    )

                -- Bash
                elseif ext == "sh" then
                    cmd = string.format(
                        "cd '%s' && bash '%s'",
                        root, relative_file
                    )

                -- Go
                elseif ext == "go" then
                    cmd = string.format(
                        "cd '%s' && go run '%s'",
                        root, relative_file
                    )

                -- JavaScript
                elseif ext == "js" then
                    cmd = string.format(
                        "cd '%s' && node '%s'",
                        root, relative_file
                    )

                -- C++
                elseif ext == "cpp" then
                    local out = vim.fn.expand("%:t:r")
                    cmd = string.format(
                        "cd '%s' && g++ '%s' -std=c++20 -O2 -o '%s' && './%s'",
                        root, relative_file, out, out
                    )

                -- C
                elseif ext == "c" then
                    local out = vim.fn.expand("%:t:r")
                    cmd = string.format(
                        "cd '%s' && gcc '%s' -o '%s' && './%s'",
                        root, relative_file, out, out
                    )

                end

                return cmd
            end

            local run = Terminal:new({
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            function _RUN_TOGGLE()
                cmd = Find_cmd()
                cmd = cmd .. " 2> /tmp/run_toggle_logs.txt"
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
                cmd = Find_cmd()
                buggy:toggle()
                buggy:send(cmd)
            end

            -- new idea: tm(for terminal multiply/multiplexer whatever)_ and _ can be a number 1-9 to test then a tmk (term. mult. kill)
            -- for testing multithreaded or whatever programs
            -- Keymap: <leader>t(whatever it opens)
            vim.keymap.set("n", "<leader>tl", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "toggle/terminal: lazygit" })
            vim.keymap.set("n", "<leader>tb", "<cmd>lua _BLANK_TOGGLE()<CR>", { desc = "toggle/terminal: blank(cwd)" })
            vim.keymap.set("n", "<leader>ty", "<cmd>lua _YAZI_TOGGLE()<CR>", { desc = "toggle/terminal: YAZI" })
            vim.keymap.set("n", "<leader>tr", "<cmd>lua _RUN_TOGGLE()<CR>", { desc = "toggle/terminal: run(compile&run program) closes after exit" })
            vim.keymap.set("n", "<leader>td", "<cmd>lua _RUN_BUGGY()<CR>", { desc = "toggle/terminal: run(compile&run program) stays open after exit" })
        end,
    },
}
