return {
    "m4xshen/hardtime.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
    opts = {},
    config = function()
        local map = vim.api.nvim_set_keymap
        require("hardtime").setup()

        map(
            "n",
            "<leader>ht",
            "<CMD>Hardtime toggle<CR>",
            { noremap = true, desc = "Toggle hardtime plugin" }
        )
    end,
}
