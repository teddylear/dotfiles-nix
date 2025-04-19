return {
    "tpope/vim-fugitive",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "tpope/vim-rhubarb",
        "sindrets/diffview.nvim",
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
            local git_branch_name = vim.fn.input("Git Branch > ")
            if git_branch_name == "" then
                print("You have to enter a branch name message silly")
            else
                createBranchIfNotExists(git_branch_name)
            end
        end

        local function gitRebase()
            local output = vim.fn.system(
                "git remote show origin | sed -n '/HEAD branch/s/.*: //p'"
            )
            local branch = string.sub(output, 1, output:len() - 1)
            vim.api.nvim_exec2('Git rebase -i "' .. branch .. '"', {})
        end

        map("n", "<leader>gc", "<CMD>G commit<CR>", {
            noremap = true,
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

        map("n", "<leader>df", "<CMD>DiffviewOpen<CR>", {
            noremap = true,
            desc = "Open diffview.nvim git diff for current project",
        })

        map("n", "<leader>dh", "<CMD>DiffviewFileHistory %<CR>", {
            noremap = true,
            desc = "Open diffview.nvim file history diff for current file",
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
