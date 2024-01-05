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
                },
                highlight = {
                    enable = true,
                },
            })
        end,
    }
}
