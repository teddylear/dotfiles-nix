return {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    opts = {
        width = 0.95,
        height = 0.95,
    },
    keys = {
        {
            "<leader>pf",
            function()
                require("fff").find_files()
            end,
            desc = "Open file picker",
        },
    },
}
