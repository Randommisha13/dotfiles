require("nvchad.configs.lspconfig").defaults()

local servers = {
    "cssls",
    "html",
    "ltex-ls-plus",
    "pretty-php",
    "pyright",
    "nil",
    "taplo",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
