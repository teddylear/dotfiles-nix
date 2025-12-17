return {
    {
        "j-hui/fidget.nvim",
        lazy = false,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false, -- make sure configs are present before any FileType events
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
            -- nvim-cmp dep removed; blink.cmp provides LSP capabilities
            "saghen/blink.cmp",
        },
        config = function()
            -- LSP completion capabilities for blink.cmp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities =
                require("blink.cmp").get_lsp_capabilities(capabilities)

            -- lua_ls
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        completion = { callSnippet = "Replace" },
                    },
                },
            })

            vim.lsp.config("ty", {
                capabilities = capabilities,
                root_markers = { "pyproject.toml", "Pipfile", ".git" },
                cmd = { "ty", "server" },
                settings = {
                    ty = {
                        diagnosticMode = "openFilesOnly",
                        completions = { autoImport = true },
                    },
                },
            })
            vim.lsp.enable("ty")

            vim.lsp.config("terraformls", { capabilities = capabilities })

            vim.lsp.config("bashls", {
                capabilities = capabilities,
                root_markers = { ".git" },
                before_init = function(params)
                    params.processId = vim.NIL
                end,
            })

            vim.lsp.config("zls", {
                capabilities = capabilities,
                filetypes = { "zig", "zir" },
                cmd = { "zls" },
                root_markers = { "build.zig", "zls.json", ".git" },
            })

            for _, name in ipairs({ "gopls", "rust_analyzer", "marksman" }) do
                vim.lsp.config(name, { capabilities = capabilities })
            end

            vim.diagnostic.config({ update_in_insert = false })

            vim.lsp.enable({
                "lua_ls",
                -- "basedpyright",
                "ty",
                "terraformls",
                "bashls",
                "zls",
                "gopls",
                "rust_analyzer",
                "marksman",
            })

            local group =
                vim.api.nvim_create_augroup("THE_KENSTER_LSP", { clear = true })

            -- one format-on-save autocmd (avoid multiplying autocmds per attach)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                pattern = {
                    "*.tf",
                    "*.tfvars",
                    "*.go",
                    "*.rs",
                    "*.lua",
                    "*.zig",
                },
                callback = function(args)
                    vim.lsp.buf.format({ bufnr = args.buf, async = false })
                end,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(args)
                    local buf = args.buf
                    vim.keymap.set(
                        "n",
                        "<leader>gd",
                        vim.lsp.buf.definition,
                        { buffer = buf, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>re",
                        vim.lsp.buf.rename,
                        { buffer = buf, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>gr",
                        vim.lsp.buf.references,
                        { buffer = buf, silent = true }
                    )
                    vim.keymap.set(
                        "n",
                        "K",
                        vim.lsp.buf.hover,
                        { buffer = buf, silent = true }
                    )
                end,
            })
        end,
    },
}
