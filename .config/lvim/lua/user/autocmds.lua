local autocmd_dict = {
  BufWinEnter = {
    {
      pattern = "*",
      command = "highlight Comment cterm=italic gui=italic"
    },
    {
      pattern = "*.Rmd",
      command = "nmap <buffer>  \\cd|nmap <buffer> <C-CR> \\cd|inoremap <M-Tab> ```{r}<CR><CR>```<UP>|inoremap <C-Tab> ```{r}<CR><CR>```<UP>"
    }
  },
  BufAdd = {
    {
      pattern = "*.tex",
      command = "setlocal syntax=tex | setlocal conceallevel=2"
    }
  },
  BufEnter = {
    {
      pattern = "*.tex",
      command = "setlocal conceallevel=2 | setlocal syntax=tex | colorscheme edge | hi! link IndentBlanklineChar Comment | hi! clear Conceal | hi Normal ctermbg=NONE guibg=NONE | hi EndOfBuffer ctermbg=NONE guibg=NONE"
    },
    {
      pattern = os.getenv("HOME") .. "/.zsh_functions/*",
      command = "setlocal ft=zsh"
    }
  },
  BufHidden = {
    {
      pattern = "*.tex",
      command = "colorscheme nord | hi Normal ctermbg=NONE guibg=NONE"
    }
  },
  VimLeave = {
    {
      pattern = "*",
      command = "if exists('g:SendCmdToR') && string(g:SendCmdToR) != 'function(''SendCmdToR_fake'')' | call RQuit('nosave') | endif"
    }
  },
  BufWritePost = {
    {
      pattern = "*.Rmd",
      command = "execute \"normal \\<plug>RMakeRmd(\\\"pdf_document\\\")\""
    }
  }
}

for event, opt_tbls in pairs(autocmd_dict) do
  for _, opt_tbl in pairs(opt_tbls) do
    vim.api.nvim_create_autocmd(event, opt_tbl)
  end
end
