return {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
        local hardtime = require("hardtime")
        hardtime.setup({})

        local enabled = true
        vim.keymap.set("n", "<leader>ht", function()
            enabled = not enabled
            if enabled then
                hardtime.enable()
                vim.notify("Hardtime enabled", vim.log.levels.INFO)
            else
                hardtime.disable()
                vim.notify("Hardtime disabled", vim.log.levels.INFO)
            end
        end, { desc = "Toggle hardtime.nvim" })
    end,
}
