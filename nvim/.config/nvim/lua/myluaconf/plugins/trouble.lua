return {
    "folke/trouble.nvim",
    opts = {
        icons = false,
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠",
        },
    },
    keys = {
        {
            "<leader>tr",
            "<cmd>TroubleToggle<cr>",
            silent = true,
            noremap = true,
            desc = "Open Trouble menu to show lsp diagnostics",
        },
    },
}
