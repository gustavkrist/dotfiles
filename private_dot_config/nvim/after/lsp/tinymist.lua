vim.lsp.handlers["tinymist/compileStatus"] = function(_, result)
  if result.wordsCount and result.wordsCount ~= vim.NIL then
    vim.g.tinymist_word_count = result.wordsCount.words
  end
  if result.pageCount and result.wordsCount ~= vim.NIL then
    vim.g.tinymist_char_count = result.wordsCount.chars
  end
  if result.status == "compiling" then
    vim.g.tinymist_compile_status = "compiling"
  elseif result.status == "compileError" then
    vim.g.tinymist_compile_status = "error"
  elseif result.status == "compileSuccess" then
    vim.g.tinymist_compile_status = "success"
  end
end

return {}
