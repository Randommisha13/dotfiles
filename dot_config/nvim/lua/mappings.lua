require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<Leader>y", "\"+y")
map("v", "<Leader>y", "\"+y")
map("n", "<Leader>p", "\"+p")
map("v", "<Leader>p", "\"+p")

function toggle_auto_format()
    if string.find(vim.o.formatoptions, "a") then
        vim.cmd("set formatoptions-=a")
        print("auto-format disabled")
    else
        vim.cmd("set formatoptions+=a")
        print("auto-format enabled")
    end
end
map("n", "<Leader>a", function() toggle_auto_format() end, { desc = "Toggle auto-format (formatoption fo-a)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
vim.opt.langmap= "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
