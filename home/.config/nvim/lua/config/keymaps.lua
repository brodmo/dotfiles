local map = vim.keymap.set

map("", "U", "<C-R>")
map("v", "<", "<gv")
map("v", ">", ">gv")

map("", "h", "<C-O>") -- history
map("", "j", "<C-I>") -- jump
map("", "k", '"_dd') -- kill
map("", "l", "^") -- left

map("n", "gl", function() Snacks.lazygit() end, { desc = "Lazygit" })

if vim.g.vscode then
  map("n", "u", '<Cmd>call VSCodeNotify("undo")<CR>', { silent = true })
  map("n", "U", '<Cmd>call VSCodeNotify("redo")<CR>', { silent = true })
end
