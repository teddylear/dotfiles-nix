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
                harpoon:list():add()
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

        local terminals = harpoon:list("terminals")

        local function open_harpoon_terminal()
            local entry = terminals:get(1)

            if entry and type(entry.value) == "string" then
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if
                        vim.api.nvim_buf_is_loaded(bufnr)
                        and vim.api.nvim_buf_get_name(bufnr) == entry.value
                    then
                        vim.api.nvim_set_current_buf(bufnr)
                        vim.cmd("startinsert")
                        return
                    end
                end
            end

            vim.cmd("enew | terminal")
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            terminals:prepend({
                value = bufname,
                context = {
                    save = false,
                },
            })

            vim.cmd("startinsert")
        end

        map("n", "<leader>to", "", {
            noremap = true,
            callback = open_harpoon_terminal,
            desc = "Open new harpoon terminal in first harpoon position",
        })
    end,
}
