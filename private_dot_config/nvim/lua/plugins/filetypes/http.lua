return {
  {
    "mistweaverco/kulala.nvim",
    opts = function()
      return {
        contenttypes = {
          ["application/scim+json"] = {
            ft = "json",
            formatter = { "jq", "." },
            pathresolver = require("kulala.parser.jsonpath").parse,
          },
          ["application/graphql-response+json"] = {
            ft = "json",
            formatter = { "jq", "." },
            pathresolver = require("kulala.parser.jsonpath").parse,
          },
        },
      }
    end,
    ft = "http",
  },
}
