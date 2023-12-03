local map = vim.api.nvim_set_keymap
local harpoon = require("harpoon")

harpoon:setup()

map("n", "<leader>a", "", {
    noremap = true,
    callback = function() harpoon:list():append() end,
    desc = "Add file to harpoon plugin list",
})

map("n", "<C-e>", "", {
    noremap = true,
    callback = function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    desc = "Toggle Harpoon quick menu",
})

-- TODO: Make mini function for this? Like a for loop

map("n", "<C-i>", "", {
    noremap = true,
    callback = function() return harpoon:list():select(1) end,
    desc = "Open harpoon file 1",
})

map("n", "<C-t>", "", {
    noremap = true,
    callback = function() return harpoon:list():select(2) end,
    desc = "Open harpoon file 2",
})

map("n", "<C-n>", "", {
    noremap = true,
    callback = function() return harpoon:list():select(3) end,
    desc = "Open harpoon file 3",
})

map("n", "<C-s>", "", {
    noremap = true,
    callback = function() return harpoon:list():select(4) end,
    desc = "Open harpoon file 4",
})

local function open_terminal_first_hp_position()
    if harpoon:list():length() > 0 and string.match(harpoon:list():get(1).value, "term://", 1) then
        print("found terminal existing terminal at harpoon 1, removing...")
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
