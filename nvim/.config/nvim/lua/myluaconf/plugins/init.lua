return {
    -- color schemes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            local catppuccin = require("catppuccin")

            -- configure it
            catppuccin.setup()
            -- latte, frappe, macchiato, mocha
            vim.g.catppuccin_flavour = "mocha"
            vim.cmd([[colorscheme catppuccin]])

            -- TODO: do something better for this
            -- disable all lsp highlighting because we want treesitter to
            -- do it. This comes from neovim docs
            for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
                vim.api.nvim_set_hl(0, group, {})
            end
        end,
    },
    -- smart comments, so useful
    "preservim/nerdcommenter",
    -- Vim Tmux Integration
    "christoomey/vim-tmux-navigator",
    -- better highlighting for TODO, NOTE, etc
    {
        "folke/todo-comments.nvim",
        opts = {},
    },
    -- make `jk` mapping work faster
    {
        "max397574/better-escape.nvim",
        opts = {},
    },
    -- replace serveral varients of words at once
    "tpope/vim-abolish",
    -- measure startup time
    -- TODO: do I need this?
    -- "dstein64/vim-startuptime",
}
