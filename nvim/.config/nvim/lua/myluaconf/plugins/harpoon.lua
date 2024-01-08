return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local map = vim.api.nvim_set_keymap
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
            },
        })

        map("n", "<leader>a", "", {
            noremap = true,
            callback = function()
                harpoon:list():append()
            end,
            desc = "Add file to harpoon plugin list",
        })

        map("n", "<C-e>", "", {
            noremap = true,
            callback = function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Toggle Harpoon quick menu",
        })

        local file_map = {
            i = 1,
            t = 2,
            n = 3,
            s = 4,
        }

        for k, v in pairs(file_map) do
            map("n", string.format("<C-%s>", k), "", {
                noremap = true,
                callback = function()
                    return harpoon:list():select(v)
                end,
                desc = string.format("Open harpoon file %s", v),
            })
        end

        local function open_terminal_first_hp_position()
            if
                harpoon:list():length() > 0
                and string.match(harpoon:list():get(1).value, "term://", 1)
            then
                print(
                    "found terminal existing terminal at harpoon 1, removing..."
                )
                harpoon:list():removeAt(1)
            end

            vim.cmd(":terminal")
            harpoon:list():prepend()
        end

        map("n", "<leader>hp", "", {
            noremap = true,
            callback = open_terminal_first_hp_position,
            desc = "Open new harpoon terminal in first harpoon position",
        })
    end,
}
