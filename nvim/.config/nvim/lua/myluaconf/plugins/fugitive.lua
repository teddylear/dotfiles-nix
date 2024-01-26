return {
    "tpope/vim-fugitive",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "tpope/vim-rhubarb",
    },
    config = function()
        local map = vim.api.nvim_set_keymap

        local Input = require("nui.input")
        local event = require("nui.utils.autocmd").event

        local function createBranchIfNotExists(branch_name)
            local result = vim.api.nvim_exec2(
                "Git rev-parse --verify " .. branch_name,
                { output = true }
            )

            if string.find(result.output, "fatal") then
                result = vim.api.nvim_exec2(
                    'Git switch -c "' .. branch_name .. '"',
                    { output = true }
                )
                if string.find(result.output, "fatal") then
                    print("Error creating branch: ", branch_name)
                    print(result)
                else
                    print(
                        string.format(
                            "Created branch '%s' successfully!",
                            branch_name
                        )
                    )
                end
            else
                print(string.format("Branch '%s' already exists!", branch_name))
            end
        end

        local function gitBranch()
            local input = Input({
                position = "50%",
                size = {
                    width = 70,
                    height = 10,
                },
                relative = "editor",
                border = {
                    highlight = "GitBranch",
                    style = "rounded",
                    text = {
                        top = "Enter new Branch name",
                        top_align = "center",
                    },
                },
                win_options = {
                    winblend = 10,
                    winhighlight = "Normal:Normal",
                },
            }, {
                prompt = "> ",
                default_value = "",
                on_close = function()
                    print("No Branch created!")
                end,
                on_submit = function(commit_message)
                    if commit_message == "" then
                        print("You have to enter a branch name message silly")
                    else
                        createBranchIfNotExists(commit_message)
                    end
                end,
            })
            input:mount()
            input:on(event.BufLeave, function()
                input:unmount()
            end)
        end

        local function gitRebase()
            local output = vim.fn.system(
                "git remote show origin | sed -n '/HEAD branch/s/.*: //p'"
            )
            local branch = string.sub(output, 1, output:len() - 1)
            vim.api.nvim_exec2('Git rebase -i "' .. branch .. '"', {})
        end

        local function gitCommit()
            local input = Input({
                position = "50%",
                size = {
                    width = 70,
                    height = 10,
                },
                relative = "editor",
                border = {
                    highlight = "GitCommit",
                    style = "rounded",
                    text = {
                        top = "Enter commit message",
                        top_align = "center",
                    },
                },
                win_options = {
                    winblend = 10,
                    winhighlight = "Normal:Normal",
                },
            }, {
                prompt = "> ",
                default_value = "",
                on_close = function()
                    print("Commit cancelled!")
                end,
                on_submit = function(commit_message)
                    if commit_message == "" then
                        print("You have to enter a commit message silly")
                    else
                        vim.cmd('Git commit -m "' .. commit_message .. '"')
                    end
                end,
            })
            input:mount()
            input:on(event.BufLeave, function()
                input:unmount()
            end)
        end

        map("n", "<leader>gc", "", {
            noremap = true,
            callback = gitCommit,
            desc = "Git commit custom function",
        })

        map("n", "<leader>rb", "", {
            noremap = true,
            callback = gitRebase,
            desc = "Git rebase function",
        })

        map("n", "<leader>gb", "", {
            noremap = true,
            callback = gitBranch,
            desc = "Git Branch creation custom function",
        })

        map(
            "n",
            "<leader>gi",
            "<CMD>Git<CR>",
            { noremap = true, desc = "Open vim-fugitive git status window" }
        )
        map("n", "<leader>df", "<CMD>Gdiff<CR>", {
            noremap = true,
            desc = "Open vim-fugitive git diff for current file",
        })

        map("n", "<leader>gs", "<CMD>Git push origin --force-with-lease<CR>", {
            noremap = true,
            desc = "vim-fugitive git push --force-with-lease",
        })

        map("n", "<leader>gp", "<CMD>Git pull origin<CR>", {
            noremap = true,
            desc = "vim-fugitive git pull",
        })

        map(
            "n",
            "<leader>gh",
            "<CMD>GBrowse<CR>",
            { noremap = true, desc = "Open file in github in current browser" }
        )
    end,
}
