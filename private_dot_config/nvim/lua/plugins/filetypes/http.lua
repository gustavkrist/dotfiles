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
    ft = { "http" },
    keys = function()
      return {
        { "<CR>", require("kulala").run, desc = "Execute current request", ft = "http" },
        { "[[", require("kulala").jump_prev, desc = "Jump to previous request", ft = "http" },
        { "]]", require("kulala").jump_next, desc = "Jump to next request", ft = "http" },
        { "<localleader>i", require("kulala").inspect, desc = "Inspect current request", ft = "http" },
        {
          "<localleader>t",
          require("kulala").toggle_view,
          desc = "Toggle between body and headers",
          ft = "http",
        },
        { "<localleader>c", require("kulala").copy, desc = "Copy request as curl command", ft = "http" },
        {
          "<localleader>p",
          require("kulala").from_curl,
          desc = "Paste curl request from clipboard as http",
          ft = "http",
        },
      }
    end,
  },
}
