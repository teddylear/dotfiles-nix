return {
    "nvim-lua/plenary.nvim",
    config = function()
        local map = vim.api.nvim_set_keymap
        local Path = require("plenary.path")

        local function createTestScript()
            if Path:new("test.sh"):exists() then
                print("Error!: test.sh already exists")
                return
            end

            -- Open new tab
            vim.cmd(":tabnew")

            local bufnr = vim.api.nvim_get_current_buf()

            vim.api.nvim_buf_set_lines(
                bufnr,
                0,
                1,
                false,
                { "#!/usr/bin/env bash" }
            )
            vim.api.nvim_buf_set_lines(
                bufnr,
                1,
                2,
                false,
                { 'echo "Hello World!"' }
            )

            vim.cmd(":w test.sh")

            -- From nvim-treesitter
            vim.fn.system("chmod +x test.sh")
            if vim.v.shell_error ~= 0 then
                print("Error running `chmod +x test.sh`")
                return
            end

            print("Created test.sh")
        end

        map("n", "<leader>ts", "", {
            noremap = true,
            callback = createTestScript,
            desc = "Create Test Script",
        })

        local function removeLspLog()
            local lsp_file_path = "/.local/state/nvim/lsp.log"
            local lsp_file =
                Path:new(string.format("%s%s", vim.env.HOME, lsp_file_path))
            if lsp_file:exists() then
                lsp_file:rm()
            else
                print("Lsp file does not exist!")
            end
        end

        vim.api.nvim_create_user_command("LspCleanLog", removeLspLog, {
            desc = "Removes Lsp Log",
            nargs = 0,
        })

        local function find_venv()
            if vim.env.VIRTUAL_ENV then
                return vim.VIRTUAL_ENV
            end

            if Path:new("Pipfile"):exists() then
                local venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
                return venv
            end

            return nil
        end

        local function pyrightConfigurationSetup()
            local pyright_config_path = Path:new("pyrightconfig.json")
            if pyright_config_path:exists() then
                print("Error! pyrightconfig.json already exists")
                return
            end

            local venv = find_venv()
            if not venv then
                print("No venv found!")
                return
            end

            local end_index = 0
            for i = #venv, 1, -1 do
                if venv:sub(i, i) == "/" then
                    end_index = i
                    break
                end
            end
            local venv_path = venv:sub(1, end_index)
            local venv_name = venv:sub(end_index + 1, #venv)

            local pyright_config_string = string.format(
                "{\n"
                    .. '    "venvPath": "%s",\n'
                    .. '    "venv": "%s"\n'
                    .. "}",
                venv_path,
                venv_name
            )
            pyright_config_path:write(pyright_config_string, "w")

            print("Made pyrightconfig.json successfully!")
        end

        vim.api.nvim_create_user_command(
            "PyrightCongfigurationSetup",
            pyrightConfigurationSetup,
            {
                desc = "Sets up pyrightconfig.json if not found",
                nargs = 0,
            }
        )

        map("n", "<leader>pt", "<Plug>PlenaryTestFile", {
            noremap = false,
            silent = false,
            desc = "Plenary Test current file",
        })

        if pcall(require, "plenary") then
            RELOAD = require("plenary.reload").reload_module

            R = function(name)
                RELOAD(name)
                return require(name)
            end
        end
    end,
}
