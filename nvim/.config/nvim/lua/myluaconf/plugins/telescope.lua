return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_sorter = require("telescope.sorters").get_fzy_sorter,
                prompt_prefix = " >",
                color_devicons = true,

                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

                mappings = {
                    i = {
                        ["<C-x>"] = false,
                        ["<C-q>"] = require("telescope.actions").send_to_qflist,
                    },
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function(_)
                        -- TODO: Remove everything from gitignore?
                        return { "--hidden", "-g", "!.git" }
                    end,
                },
                find_files = {
                    find_command = {
                        "rg",
                        "--files",
                        "--hidden",
                        "-g",
                        "!.git",
                    },
                },
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
            },
        })
        require("telescope").load_extension("fzy_native")

        local Path = require("plenary.path")
        local homedir = os.getenv("HOME")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local function iam_actions()
            local iam_file_path = Path:new(
                homedir,
                "code",
                "aws-iam-actions-list",
                "all-actions.txt"
            )

            if not iam_file_path:exists() then
                error("No aws-iam-actions-list file found :(")
            end
            local iam_actions_map = iam_file_path:readlines()

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Iam actions",
                    finder = require("telescope.finders").new_table(
                        iam_actions_map
                    ),
                    sorter = require("telescope.config").values.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, _)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local val = tostring(selection[1])
                            vim.schedule(function()
                                vim.api.nvim_put({ val }, "c", true, true)
                            end)
                        end)
                        return true
                    end,
                })
                :find()
        end

        local function get_keymaps_with_desc()
            local keymap_with_desc = {}
            local modes = { "n", "v", "i", "t" }
            for _, mode in ipairs(modes) do
                for _, keymap in ipairs(vim.api.nvim_get_keymap(mode)) do
                    if keymap.desc ~= nil then
                        table.insert(
                            keymap_with_desc,
                            string.format(
                                "mode: '%s' | keymap: '%s' | desc: '%s' | cmd: '%s'",
                                keymap.mode,
                                keymap.lhs,
                                keymap.desc,
                                keymap.rhs
                            )
                        )
                    end
                end
            end

            return keymap_with_desc
        end

        local function keymaps()
            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Custom Keymaps",
                    finder = require("telescope.finders").new_table({
                        results = get_keymaps_with_desc(),
                    }),
                    sorter = require("telescope.config").values.generic_sorter({}),
                })
                :find()
        end

        local function tmux_sessions()
            local sessions =
                vim.fn.systemlist("tmux list-sessions -F '#S' 2>/dev/null")
            if vim.v.shell_error ~= 0 or #sessions == 0 then
                print("No tmux sessions found")
                return
            end

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Tmux Sessions",
                    finder = require("telescope.finders").new_table({
                        results = sessions,
                    }),
                    sorter = require("telescope.config").values.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, _)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            if not selection then
                                actions.close(prompt_bufnr)
                                return
                            end

                            actions.close(prompt_bufnr)
                            local session = tostring(selection[1])
                            local escaped_session = vim.fn.shellescape(session)

                            if vim.env.TMUX and vim.env.TMUX ~= "" then
                                vim.cmd(
                                    "silent !tmux switch-client -t "
                                        .. escaped_session
                                )
                            else
                                vim.cmd(
                                    "silent !tmux attach -t " .. escaped_session
                                )
                            end

                            vim.cmd("redraw!")
                        end)

                        return true
                    end,
                })
                :find()
        end

        local function tmux_windows()
            if not vim.env.TMUX or vim.env.TMUX == "" then
                print("Not inside tmux")
                return
            end

            local windows =
                vim.fn.systemlist("tmux list-windows -F '#I: #W' 2>/dev/null")
            if vim.v.shell_error ~= 0 or #windows == 0 then
                print("No tmux windows found")
                return
            end

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Tmux Windows",
                    finder = require("telescope.finders").new_table({
                        results = windows,
                    }),
                    sorter = require("telescope.config").values.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, _)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            if not selection then
                                actions.close(prompt_bufnr)
                                return
                            end

                            actions.close(prompt_bufnr)

                            local window_entry = tostring(selection[1])
                            local window_index = window_entry:match("^([^:]+):")
                            if not window_index then
                                print("Could not parse tmux window index")
                                return
                            end

                            local escaped_window_index =
                                vim.fn.shellescape(window_index)
                            vim.cmd(
                                "silent !tmux select-window -t "
                                    .. escaped_window_index
                            )
                            vim.cmd("redraw!")
                        end)

                        return true
                    end,
                })
                :find()
        end

        local map = vim.api.nvim_set_keymap

        map("n", "<leader>lg", "", {
            noremap = true,
            callback = require("telescope.builtin").live_grep,
            desc = "Telescope live grep",
        })

        map("n", "<leader>cw", "", {
            noremap = true,
            callback = function()
                return require("telescope.builtin").grep_string({
                    search = vim.fn.expand("<cword>"),
                })
            end,
            desc = "Telescope grep current word under cursor",
        })

        map("n", "<leader>pf", "", {
            noremap = true,
            callback = require("telescope.builtin").find_files,
            desc = "Telescope find files",
        })

        map("n", "<leader>pg", "", {
            noremap = true,
            callback = require("telescope.builtin").git_branches,
            desc = "Telescope change git branch",
        })

        map("n", "<leader>ch", "", {
            noremap = true,
            silent = false,
            callback = keymaps,
            desc = "Telescope open custom keymap descriptions",
        })

        map("n", "<leader>iam", "", {
            noremap = true,
            callback = iam_actions,
            desc = "List iam actions from aws",
        })

        map("n", "<leader>ts", "", {
            noremap = true,
            callback = tmux_sessions,
            desc = "Telescope switch tmux session",
        })

        map("n", "<leader>tw", "", {
            noremap = true,
            callback = tmux_windows,
            desc = "Telescope switch tmux window",
        })
    end,
}
