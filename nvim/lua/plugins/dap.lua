return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "delve", "java-debug-adapter", "java-test" },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Go
            dap.adapters.go = {
                type = "executable",
                command = "dlv",
                args = { "dap" },
            }
            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug",
                    request = "launch",
                    program = "${file}",
                },
            }

            -- Java
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/"
            dap.adapters.java = {
                type = "executable",
                command = "java",
                args = { "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044", "-jar", mason_path .. "com.microsoft.java.debug.plugin-*.jar" },
            }

            dap.configurations.java = {
                {
                    type = "java",
                    request = "launch",
                    name = "Launch Java Program",
                    mainClass = function()
                        return vim.fn.input("Main class > ")
                    end,
                    projectName = function()
                        return vim.fn.input("Project name > ")
                    end,
                },
            }
        end,
    },
}
