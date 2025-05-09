local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.s
local t = ls.text_node
local rep = require("luasnip.extras").rep

ls.add_snippets("go", {
    s("ife", {
        t({ "if err != nil {", "\treturn " }),
        i(0),
        t({ "", "}" }),
    }),
    s("prn", fmt('fmt.Println(fmt.Sprintf("{}: %v", {}))', { i(1), rep(1) })),
    s("hh", t({ 'fmt.Println("Hitting here!")' })),
})
