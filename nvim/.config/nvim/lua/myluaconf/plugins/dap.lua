return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    },
    ft = { "go" },
    config = function()
        local dap = require("dap")
        dap.set_log_level("INFO")

        dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}" },
            }
        }

        dap.configurations.go = {
            {
                type = "delve",
                name = "Debug",
                request = "launch",
                program = "${file}"
            },
            {
                type = "delve",
                name = "Debug test", -- configuration for debugging test files
                request = "launch",
                mode = "test",
                program = "${file}"
            },
            {
                type = "delve",
                name = "Debug test (go.mod)",
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}"
            },
            {
                type = "delve",
                name = "Debug Test (Current Function)",
                request = "launch",
                mode = "test",
                program = "${file}",
                args = function()
                    -- TODO: this would be pretty cool with a treesitter function
                    local test_name = vim.fn.input("Test name: ")
                    return { "-test.run", test_name }
                end,
            }
        }

        -- TODO: maybe change keybinds, see how these feel
        -- from prime: https://github.com/ThePrimeagen/init.lua/blob/cad018c8ec47617c1cf6c9fbdda218b0c7203e6b/lua/theprimeagen/lazy/dap.lua
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Conditional Breakpoint" })
        --
        vim.fn.sign_define('DapBreakpoint',
            { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

        local dapui = require('dapui')
        dapui.setup()

        vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug: Toggle Breakpoint" })
    end,
}
