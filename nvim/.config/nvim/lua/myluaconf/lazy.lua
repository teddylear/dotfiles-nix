local function lazy()
    local PLUGINS_LOCATION = vim.fn.expand("~/dotfiles-nix/nvim/plugins/")
    local lazypath = PLUGINS_LOCATION .. "/lazy.nvim"

    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end

    vim.opt.rtp:prepend(lazypath)

    -- https://github.com/antonk52/dot-files/blob/master/nvim/init.lua
    local lazy_options = {
        root = PLUGINS_LOCATION,
        lockfile = vim.fn.expand("~/dotfiles-nix/nvim/.config/nvim/lua")
            .. "/lazy-lock.json",
        performance = {
            rtp = {
                disabled_plugins = {
                    "2html_plugin",
                    "getscript",
                    "getscriptPlugin",
                    "logipat",
                    "netrwFileHandlers",
                    "netrwSettings",
                    "rrhelper",
                    "tar",
                    "tarPlugin",
                    "tutor",
                    "tutor_mode_plugin",
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                },
            },
        },
        ui = {
            icons = {
                cmd = "⌘",
                config = "🛠",
                event = "📅",
                ft = "📂",
                init = "⚙",
                keys = "🗝",
                plugin = "🔌",
                runtime = "💻",
                source = "📄",
                start = "🚀",
                task = "📌",
                lazy = "💤 ",
            },
        },
    }

    require("lazy").setup("myluaconf.plugins", lazy_options)
end

local function init()
    lazy()
end

return {
    init = init,
}
