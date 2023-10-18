if vim.loader then
    vim.loader.enable()
end
require("myluaconf.sets")
require("myluaconf.functions").init()
require("myluaconf.plugins").init()
