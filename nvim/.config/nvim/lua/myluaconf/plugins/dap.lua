return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    },
    ft = { "go", "zig" },
    config = function()
        local dap = require("dap")
        dap.set_log_level("INFO")

        -- zig configuration when I'm ready
        -- dap.adapters.lldb = {
        -- type = "executable",
        -- command = "/usr/bin/lldb-vscode", -- Adjust path
        -- name = "lldb"
        -- }

        -- dap.configurations.zig = {
        -- {
        -- -- NOTE: when debugging with zig need to build with this
        -- -- zig build -Drelease-safe=false
        -- name = "Launch Zig Binary",
        -- type = "lldb",
        -- request = "launch",
        -- program = function()
        -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
        -- end,
        -- cwd = "${workspaceFolder}",
        -- stopOnEntry = false,
        -- args = {}, -- Add arguments if needed
        -- },
        -- {
        -- -- NOTE: `zig test <file>`
        -- name = "Debug Zig Test File",
        -- type = "lldb",
        -- request = "launch",
        -- program = function()
        -- -- Compile the Zig test file into an executable before running
        -- local test_binary = vim.fn.getcwd() .. "/zig-out/bin/test_executable"
        -- vim.fn.system("zig test " .. vim.fn.expand("%") .. " -femit-bin=" .. test_binary)
        -- return test_binary
        -- end,
        -- cwd = "${workspaceFolder}",
        -- stopOnEntry = false,
        -- args = {},
        -- },
        -- {
        -- -- NOTE: `zig test <file>`
        -- name = "Debug a Single Zig Test",
        -- type = "lldb",
        -- request = "launch",
        -- program = function()
        -- -- Prompt the user to enter the test function name
        -- local test_name = vim.fn.input("Test name: ")
        -- local test_binary = vim.fn.getcwd() .. "/zig-out/bin/test_executable"

        -- -- Compile only the test file, filtering for the selected test function
        -- vim.fn.system(
        -- "zig test " .. vim.fn.expand("%") .. " -femit-bin=" .. test_binary .. " -tfilter " .. test_name
        -- )

        -- return test_binary
        -- end,
        -- cwd = "${workspaceFolder}",
        -- stopOnEntry = false,
        -- args = {},
        -- },
        -- }

        dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}" },
            },
        }

        dap.configurations.go = {
            {
                type = "delve",
                name = "Debug",
                request = "launch",
                program = "${file}",
            },
            {
                type = "delve",
                name = "Debug test",
                request = "launch",
                mode = "test",
                program = "${file}",
            },
            {
                type = "delve",
                name = "Debug test (go.mod)",
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}",
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
            },
        }

        -- TODO: maybe change keybinds, see how these feel
        -- from prime: https://github.com/ThePrimeagen/init.lua/blob/cad018c8ec47617c1cf6c9fbdda218b0c7203e6b/lua/theprimeagen/lazy/dap.lua
        vim.keymap.set(
            "n",
            "<leader>dc",
            dap.continue,
            { desc = "Debug: Continue" }
        )
        vim.keymap.set(
            "n",
            "<F10>",
            dap.step_over,
            { desc = "Debug: Step Over" }
        )
        vim.keymap.set(
            "n",
            "<F11>",
            dap.step_into,
            { desc = "Debug: Step Into" }
        )
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set(
            "n",
            "<leader>b",
            dap.toggle_breakpoint,
            { desc = "Debug: Toggle Breakpoint" }
        )
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Conditional Breakpoint" })

        vim.fn.sign_define("DapBreakpoint", {
            text = "🔴",
            texthl = "DapBreakpoint",
            linehl = "DapBreakpoint",
            numhl = "DapBreakpoint",
        })

        local dapui = require("dapui")
        dapui.setup()

        vim.keymap.set(
            "n",
            "<leader>dt",
            dapui.toggle,
            { desc = "Debug: Toggle Breakpoint" }
        )
    end,
}
