; extends

((string_content) @injection.content
  (#lua-match? @injection.content "^°°°.*°°°$")
  (#gsub! @injection.content "^°°°(.*)°°°" "%1")
  (#set! injection.language "markdown"))
