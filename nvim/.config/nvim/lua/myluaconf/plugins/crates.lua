return {
    "Saecki/crates.nvim",
    dependencies = { "nvimtools/none-ls.nvim" },
    config = function()
        local crates = require("crates")
        crates.setup({
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
            popup = {
                autofocus = true,
            },
        })

        -- TODO: update to not compete with todo-comments

        vim.keymap.set("n", "<leader>ct", crates.toggle, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Enable or disable UI elements",
        })

        vim.keymap.set("n", "<leader>cr", crates.reload, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Reload data (clears cache).",
        })

        vim.keymap.set("n", "<leader>cU", crates.update_crate, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: update crate on current line",
        })

        vim.keymap.set("v", "<leader>cU", crates.update_crates, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: update crates on lines visually selected",
        })

        vim.keymap.set("n", "<leader>cA", crates.update_all_crates, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: update all crates in the buffer",
        })

        vim.keymap.set("n", "<leader>cH", crates.open_homepage, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Open the homepage of the crate on the current line.",
        })

        vim.keymap.set("n", "<leader>cR", crates.open_repository, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Open the repository page of the crate on the current line.",
        })

        vim.keymap.set("n", "<leader>cD", crates.open_documentation, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Open the documentation page of the crate on the current line.",
        })

        vim.keymap.set("n", "<leader>cC", crates.open_crates_io, {
            noremap = true,
            silent = true,
            desc = "crates.nvim: Open the `crates.io` page of the crate on the current line.",
        })
    end,
}
