require("nvchad.configs.lspconfig").defaults()

local servers = {
    "cssls",
    "html",
    "ltex-ls-plus",
    "pretty-php",
    "pyright",
    "nil_ls",
    "taplo",
    "bashls",
    "emmylua_ls",
    "systemd_lsp"
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
