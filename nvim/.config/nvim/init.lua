if vim.loader then
    vim.loader.enable()
end
require("myluaconf.sets")
require("myluaconf.keymaps")
require("myluaconf.functions").init()
require("myluaconf.lazy").init()
