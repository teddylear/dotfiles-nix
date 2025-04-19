local ls = require("luasnip")

ls.add_snippets("terraform", {
    ls.parser.parse_snippet(
        "vs",
        'variable "$0" {\n  type = string\n}'
    ),
    ls.parser.parse_snippet(
        "vn",
        'variable "$0" {\n  type = number\n}'
    ),
    ls.parser.parse_snippet("vb", 'variable "$0" {\n  type = bool\n}'),
    ls.parser.parse_snippet("rs", 'resource "$1" "$2" {\n\t$0\n}'),
    ls.parser.parse_snippet("ds", 'data "$1" "$2" {\n\t$0\n}'),
    ls.parser.parse_snippet("md", 'module "$1" {\n\tsource = "$0"\n}'),
})
