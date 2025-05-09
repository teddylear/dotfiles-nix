local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.s
local t = ls.text_node
local rep = require("luasnip.extras").rep

ls.add_snippets("lua", {
    ls.parser.parse_snippet("fn", "local function $1($2)\n    $0\nend"),
    ls.parser.parse_snippet("cfn", "function $1:$2($3)\n    $0\nend"),
    ls.parser.parse_snippet("ifs", "if $1 then\n    $0\nend"),
    ls.parser.parse_snippet("ifel", "if $1 then\n    $2\nelse $3\n    $0\nend"),
    s("prn", fmt('print("{}:", {})', { i(1), rep(1) })),
    s("prni", fmt('print("{}:", vim.inspect({}))', { i(1), rep(1) })),
    s("hh", { t({ 'print("Hitting here!")' }) }),
})
