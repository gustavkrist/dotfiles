; extends

((string_content) @text
  (#lua-match? @text "^°°°.*°°°$"))

(module
  (comment) @cellseparator
  . (expression_statement
      (string
        (string_start)
        (string_content) @text
        (string_end)))
  (#match-percent-separator? @cellseparator "markdown"))
