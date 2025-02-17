return {
	{
		"mistweaverco/kulala.nvim",
		opts = function()
			return {
				additional_curl_options = { "-k" },
				contenttypes = {
					["application/scim+json"] = {
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
