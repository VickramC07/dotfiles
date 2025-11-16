vim.g.mapleader = " "
vim.o.completeopt = "menuone,noselect" -- always show autocomplete
vim.keymap.set("n", "<Enter>", "o<esc>", { desc = "Enter new line below" })
vim.keymap.set("n", "<S-Enter>", "O<esc>", { desc = "Enter new line above" })
vim.keymap.set("n", "<Up>", "k$", { desc = "up to end of line" })
vim.keymap.set("n", "<Down>", "a{<CR>}<Left><CR><Up><Tab>", { desc = "new parenthesis" })
vim.keymap.set("n", "<Left>", "_", { desc = "start of line" })
vim.keymap.set("n", "<Right>", "$", { desc = "end of line" })

