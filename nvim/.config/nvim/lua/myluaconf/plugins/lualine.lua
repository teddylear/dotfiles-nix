return {
    {
       "nvim-tree/nvim-web-devicons",
       opts = {}
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local function harpoon_component()
                local mark_idx = require("harpoon.mark").get_current_index()
                if mark_idx == nil then
                    return ""
                end

                return string.format(" %d", mark_idx)
            end

            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    icons_enabled = true,
                    -- This sets relative path
                    globalstatus = true,
                },
                sections = {
                    lualine_b = {
                        { "branch", icon = "" },
                        { harpoon_component },
                        "diff",
                        { "diagnostics", icons_enabled = false },
                    },
                },
                extensions = { "fzf", "fugitive" },
            })
        end,
    },
}
