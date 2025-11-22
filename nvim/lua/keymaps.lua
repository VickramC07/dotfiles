vim.g.mapleader = " "
vim.o.completeopt = "menuone,noselect" -- always show autocomplete
vim.keymap.set("n", "<Enter>", "o<esc>", { desc = "Enter new line below" })
vim.keymap.set("n", "<S-Enter>", "O<esc>", { desc = "Enter new line above" })
vim.keymap.set("n", "<Up>", "k$", { desc = "up to end of line" })
vim.keymap.set("n", "<Down>", "$a{<CR>}<Left><CR><Up><Tab>", { desc = "new parenthesis" })
vim.keymap.set("n", "<Left>", "_", { desc = "start of line" })
vim.keymap.set("n", "<Right>", "$", { desc = "end of line" })
vim.keymap.set('n', '<leader>er', vim.diagnostic.goto_next, { desc = "show next diagnostic" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "code action" })
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

