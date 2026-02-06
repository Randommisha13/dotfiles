require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "ltex-ls-plus", "pretty-php" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
