local M = {}

M.setup = function()
  vim.g.mkdp_filetypes = { "markdown", "pandoc" }
  vim.cmd [[
  function! ChromeUrl(url)
    call system("osascript " . $HOME . "/scripts/chrome_new_window.scpt " . a:url)
  endfunction
  ]]
  vim.g.mkdp_browserfunc = 'ChromeUrl'
  vim.cmd [[
  let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {'macros': {
        \ "\\Xn": "X_1, \\ldots, X_n",
        \ "\\abs": "\\lvert #1 \\rvert",
        \ "\\ber": "\\operatorname{Ber}",
        \ "\\bin": "\\operatorname{Bin}",
        \ "\\ceil": "\\lceil #1 \\rceil",
        \ "\\cov": "\\operatorname{Cov}",
        \ "\\diff": "\\mathop{}\\!\\mathrm{d}",
        \ "\\expdist": "\\operatorname{Exp}",
        \ "\\expect": "\\operatorname{E}",
        \ "\\floor": "\\lfloor #1 \\rfloor",
        \ "\\geo": "\\operatorname{Geo}",
        \ "\\given": "\\,\\vert\\,",
        \ "\\inv": "#1^{\\text{inv}}",
        \ "\\mean": "\\overline{#1}",
        \ "\\med": "\\operatorname{Med}",
        \ "\\normdist": "\\operatorname{N}",
        \ "\\prob": "\\operatorname{P}",
        \ "\\unif": "\\operatorname{U}",
        \ "\\var": "\\operatorname{Var}",
        \ "\\xn": "x_1, \\ldots, x_n"
        \ }},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle',
      \ 'hide_yaml_meta': 1,
      \ 'sequence_diagrams': {},
      \ 'flowchart_diagrams': {},
      \ 'content_editable': v:false,
      \ 'disable_filename': 0,
      \ 'toc': {}
      \ }
  ]]
  vim.g.mkdp_markdown_css = os.getenv("HOME") .. "/.config/lvim/styles/markdown-preview.css"
end

return M
