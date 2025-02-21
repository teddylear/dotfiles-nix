return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {},
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            local ts_update = require("nvim-treesitter.install").update({
                with_sync = true,
            })
            ts_update()

            -- TODO: can this be opt?
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "python",
                    "go",
                    "lua",
                    "yaml",
                    "json",
                    "bash",
                    "rust",
                    "dockerfile",
                    "typescript",
                    "ruby",
                    "javascript",
                    "query",
                    "cpp",
                    "markdown",
                    "hcl",
                    "puppet",
                    "terraform",
                    "nix",
                    "vimdoc",
                    "zig",
                },
                highlight = {
                    enable = true,
                },
            })

            local map = vim.api.nvim_set_keymap

            map("n", "<leader>tc", "<CMD>TSContextToggle<CR>", {
                noremap = true,
                desc = "Toggle TS Contexnt for parent",
            })
        end,
    },
}
