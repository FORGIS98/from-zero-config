local keymap = vim.keymap

-- nnoremap Y y$
keymap.set("n", "Y", "y$", { noremap = true, silent = true, desc = "Yank to end of line" })