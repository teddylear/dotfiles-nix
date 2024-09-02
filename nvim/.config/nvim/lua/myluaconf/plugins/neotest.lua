return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "rouge8/neotest-rust",
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-go",
    },
    ft = { "rust", "go" },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-rust"),
                require("neotest-go"),
            },
            icons = {
                failed = "",
                passed = "",
                running = "R",
                unknown = "U",
                skipped = "S",
            },
        })

        local map = vim.api.nvim_set_keymap

        map("n", "<leader>rt", "", {
            noremap = true,
            callback = function()
                return neotest.run.run()
            end,
            desc = "Run test closest to cursor via neotest",
        })

        map("n", "<leader>ta", "", {
            noremap = true,
            callback = function()
                return neotest.run.run({ suite = true })
            end,
            desc = "Run all tests in project via neotest",
        })

        map("n", "<leader>tf", "", {
            noremap = true,
            callback = function()
                return neotest.run.run(vim.fn.expand("%"))
            end,
            desc = "Run all tests current file via neotest",
        })

        map("n", "<leader>tp", "", {
            noremap = true,
            callback = neotest.output_panel.toggle,
            desc = "Toggle for showing neotest panel",
        })
    end,
}
