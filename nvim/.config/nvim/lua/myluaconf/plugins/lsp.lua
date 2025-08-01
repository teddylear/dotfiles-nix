local ft = {
    "terraform",
    "rust",
    "go",
    "lua",
    "python",
    "sh",
    "markdown",
    "zig",
}

return {
    {
        "j-hui/fidget.nvim",
        ft = ft,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        ft = ft,
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local util = require("lspconfig/util")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities =
                require("cmp_nvim_lsp").default_capabilities(capabilities)

            require("lspconfig").lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            })

            -- From below thread on this issue
            -- https://github.com/neovim/nvim-lspconfig/issues/500
            local path = util.path
            local function get_python_path(workspace)
                local python_path
                -- Use activated virtualenv.
                if vim.env.VIRTUAL_ENV then
                    python_path =
                        path.join(vim.env.VIRTUAL_ENV, "bin", "python")
                    print(
                        string.format(
                            "In a venv! Using that for lsp: %s",
                            python_path
                        )
                    )
                    return python_path
                end

                -- Find and use virtualenv from pipenv in workspace directory.
                local match = vim.fn.glob(path.join(workspace, "Pipfile"))
                if match ~= "" then
                    local venv = vim.fn.trim(
                        vim.fn.system(
                            "PIPENV_PIPFILE=" .. match .. " pipenv --venv"
                        )
                    )
                    python_path = path.join(venv, "bin", "python")
                    print(
                        string.format(
                            "Found a Pipfile! Using that for lsp: %s",
                            python_path
                        )
                    )
                    return python_path
                end

                -- Fallback to system Python.
                print("No venv or Pipfile found, using system python")
                return vim.fn.exepath("python3")
                    or vim.fn.exepath("python")
                    or "python"
            end

            require("lspconfig").basedpyright.setup({
                before_init = function(params)
                    params.processId = vim.NIL
                end,
                on_init = function(client)
                    client.config.settings.python.pythonPath =
                        get_python_path(client.config.root_dir)
                end,
                root_dir = util.root_pattern(".git", "Pipfile"),
                capabilities = capabilities,
                settings = {
                    pyright = {
                        autoImportCompletion = true,
                    },
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "off",
                        },
                    },
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "off",
                        },
                    },
                },
            })

            require("lspconfig").terraformls.setup({
                capabilities = capabilities,
                filetypes = { "hcl", "tf", "terraform", "tfvars" },
            })

            require("lspconfig").bashls.setup({
                before_init = function(params)
                    params.processId = vim.NIL
                end,
                root_dir = util.root_pattern(".git"),
                capabilities = capabilities,
            })

            require("lspconfig").zls.setup({
                root_dir = util.root_pattern(".git"),
                capabilities = capabilities,
            })

            local default_lsp_configs = {
                "gopls",
                "rust_analyzer",
                "marksman",
            }

            for _, lsp_name in ipairs(default_lsp_configs) do
                require("lspconfig")[lsp_name].setup({
                    capabilities = capabilities,
                })
            end

            vim.diagnostic.config({
                update_in_insert = false,
            })

            local group =
                vim.api.nvim_create_augroup("THE_KENSTER_LSP", { clear = true })
            -- From this article
            -- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(args)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = {
                            "*.tf",
                            "*.tfvars",
                            "*.go",
                            "*.rs",
                            "*.lua",
                            "*.zig",
                        },
                        callback = function()
                            vim.lsp.buf.format({
                                async = false,
                                id = args.data.client_id,
                            })
                        end,
                    })

                    vim.keymap.set(
                        "n",
                        "<leader>gd",
                        vim.lsp.buf.definition,
                        { buffer = true, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>re",
                        vim.lsp.buf.rename,
                        { buffer = true, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>gr",
                        vim.lsp.buf.references,
                        { buffer = true, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "K",
                        vim.lsp.buf.hover,
                        { buffer = true, silent = true }
                    )
                end,
            })
        end,
    },
}
