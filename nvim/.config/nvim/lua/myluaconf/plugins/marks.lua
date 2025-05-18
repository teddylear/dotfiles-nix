return {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
        mappings = {
            set_next = "<leader>m",
            next = "mn",
            preview = "m:",
            set_bookmark0 = "m0",
            prev = false, -- pass false to disable only this default mapping
        },
    },
}
