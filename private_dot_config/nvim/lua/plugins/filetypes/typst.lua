return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      open_cmd = "/Applications/Firefox.app/Contents/MacOS/firefox %s -P typst-preview",
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
}
