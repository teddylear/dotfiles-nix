local map = vim.api.nvim_set_keymap

return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup({
            prompt_func_return_type = {
                go = true,
            },
            prompt_func_param_type = {
                go = true,
            },
        })

        map(
            "v",
            "<Leader>ef",
            [[<Esc><Cmd>lua require("refactoring").refactor("Extract Function")<CR>]],
            {
                noremap = true,
                silent = true,
                expr = false,
                desc = "Refactoring extract function",
            }
        )

        map(
            "v",
            "<Leader>ev",
            [[<Esc><Cmd>lua require("refactoring").refactor("Extract Variable")<CR>]],
            {
                noremap = true,
                silent = true,
                expr = false,
                desc = "Refactoring extract variable",
            }
        )

        map("n", "<Leader>db", "", {
            noremap = true,
            silent = true,
            callback = function()
                return require("refactoring").debug.printf({ below = true })
            end,
            desc = "Refactoring plugin debug print statement",
        })

        map("n", "<Leader>dc", "", {
            noremap = true,
            silent = true,
            callback = require("refactoring").debug.cleanup,
            desc = "Refactoring plugin debug cleanup print statements",
        })

        map("v", "<Leader>dv", ":lua require('refactoring').debug.print_var()<CR>", {
            noremap = true,
            silent = true,
            expr = false,
            desc = "Refactoring plugin debug print var",
        })

        map(
            "n",
            "<Leader>dn",
            ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
            {
                noremap = true,
                silent = true,
                expr = false,
                desc = "Refactoring plugin debug print var",
            }
        )
    end,
}

