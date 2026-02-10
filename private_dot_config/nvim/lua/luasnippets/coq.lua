local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local ms = ls.multi_snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local snippets = {
  s(
    { trig = "ind", desc = "Induction" },
    fmt(
      [[
        induction {} as [| {}' IH{}'].
        - {}
        - 
      ]],
      {
        i(1, "n"),
        dl(2, l._1, 1),
        dl(3, l._1, 1),
        i(0),
      }
    )
  ),
  s(
    { trig = "ind2", desc = "Induction (2 constructers with one arg)" },
    fmt(
      [[
        induction {} as [| {}' IH{}' | {}' IH{}'].
        - {}
        - 
        - 
      ]],
      {
        i(1, "n"),
        dl(2, l._1 .. "0", 1),
        dl(3, l._1 .. "0", 1),
        dl(4, l._1 .. "1", 1),
        dl(5, l._1 .. "1", 1),
        i(0),
      }
    )
  ),
  s(
    { trig = "dest", desc = "Destruct" },
    fmt(
      [[
        destruct {} as [| {}' ] eqn:E{}.
        - {}
        - 
      ]],
      {
        i(1, "n"),
        dl(2, l._1, 1),
        dl(2, l._1, 1),
        i(0),
      }
    )
  ),
  s(
    { trig = "match", desc = "Match statement" },
    fmt(
      [[
        match {} with
        | {} => {}
        end.
      ]],
      {
        i(1),
        i(2),
        i(0),
      })
  ),
}

local autosnippets = {
  s({ trig = "ref.", desc = "Reflexivity" }, t("reflexivity.")),
  s(
    { trig = "rwl.", desc = "[R]e[w]rite [L]eft" },
    fmt(
      [[
        rewrite <- {}.{}
      ]],
      {
        i(1, "H"),
        i(0),
      }
    )
  ),
  s(
    { trig = "rwr.", desc = "[R]e[w]rite [R]ight" },
    fmt(
      [[
        rewrite -> {}.{}
      ]],
      {
        i(1, "H"),
        i(0),
      }
    )
  ),
}

return snippets, autosnippets
