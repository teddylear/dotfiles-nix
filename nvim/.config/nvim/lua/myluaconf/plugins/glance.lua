return {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {},
    keys = {
        {
            "<leader>gd",
            "<cmd>Glance definitions<cr>",
            desc = "Glance definitions",
        },
        {
            "<leader>gr",
            "<cmd>Glance references<cr>",
            desc = "Glance references",
        },
        {
            "<leader>gy",
            "<cmd>Glance type_definitions<cr>",
            desc = "Glance type definitions",
        },
        {
            "<leader>gm",
            "<cmd>Glance implementations<cr>",
            desc = "Glance implementations",
        },
    },
}
