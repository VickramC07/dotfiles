-- lua/plugins/lspserver.lua

-- =========================
-- LSP capabilities
-- =========================
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
vim.g.lsp_capabilities = capabilities

-- =========================
-- Common on_attach function
-- =========================
local function on_attach(client, bufnr)
    local buf_map = function(mode, lhs, rhs)
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
    end

    buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
end

-- =========================
-- Utility function to start a server
-- =========================
local function start_server(name, cmd, extra)
    vim.lsp.start(vim.tbl_extend("force", {
        name = name,
        cmd = cmd,
        on_attach = on_attach,
        capabilities = capabilities,
    }, extra or {}))
end

-- =========================
-- Start each LSP server
-- =========================

-- Go
start_server("gopls", { "gopls" }, {
    settings = { gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true } }
})

-- TypeScript / JavaScript
start_server("ts_ls", { "typescript-language-server", "--stdio" }, {
    init_options = {
        preferences = {
            importModuleSpecifierPreference = "relative",
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
        },
    },
})

-- CSS
start_server("cssls", { "vscode-css-language-server", "--stdio" })

-- Java
start_server("jdtls", { "jdtls" })

