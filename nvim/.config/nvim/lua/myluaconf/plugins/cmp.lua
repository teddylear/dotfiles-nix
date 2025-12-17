return {
    "saghen/blink.cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
    },
    version = "*",
    config = function()
        require("blink.cmp").setup({
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
            },

            keymap = {
                ["<C-e>"] = { "hide" },
                ["<C-y>"] = { "accept" },
                ["<C-n>"] = { "select_next" },
                ["<C-p>"] = { "select_prev" },
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    buffer = {
                        min_keyword_length = 2,
                    },
                },
            },
        })
    end,
}
