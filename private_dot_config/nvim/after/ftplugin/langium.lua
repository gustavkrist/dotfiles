vim.defer_fn(function()
  vim.call("EnableEmbeddedSyntaxHighlight", "pcre", " /", "/;", "@string.regexp")
end, 1000)
