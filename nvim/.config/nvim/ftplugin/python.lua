local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.s
local t = ls.text_node
local rep = require("luasnip.extras").rep

ls.add_snippets("python", {
    s(
        "prn",
        fmt(
            'print(f"^%: {^%}")',
            { i(1), rep(1) },
            { delimiters = "^%" }
        )
    ),
    s("hh", { t({ 'print("Hitting here!")' }) }),
    s(
        "main",
        { t({ 'if __name__=="__main__":', '\tprint("Hello World!")' }) }
    ),
    s("class", {
        t({ "class " }),
        i(0),
        t({
            ":",
            "",
            "\tdef __init__(self):",
            '\t\tprint("Hello World!")',
        }),
    }),
})
