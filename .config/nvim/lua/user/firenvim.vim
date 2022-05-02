let g:timer_started = v:false
function! My_Write(timer) abort
	let g:timer_started = v:false
	write
endfunction

function! Delay_My_Write() abort
	if g:timer_started
		return
	end
	let g:timer_started = v:true
	call timer_start(10000, 'My_Write')
endfunction

au TextChanged * ++nested call Delay_My_Write()
au TextChangedI * ++nested call Delay_My_Write()

let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
        \ 'cmdlineTimeout': 3000,
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'always',
        \ },
    \ }
\ }
let s:bufname=expand('%:t')
if s:bufname =~? 'github.com'
    set ft=markdown
elseif s:bufname =~? 'cocalc.com' || s:bufname =~? 'kaggleusercontent.com'
    set ft=python
elseif s:bufname =~? 'localhost'
    set ft=python
elseif s:bufname =~? 'reddit.com'
    set ft=markdown
elseif s:bufname =~? 'stackexchange.com' || s:bufname =~? 'stackoverflow.com'
    set ft=markdown
elseif s:bufname =~? 'slack.com' || s:bufname =~? 'gitter.com'
    set ft=markdown
elseif s:bufname =~? 'localhost'
    set ft=markdown
endif

au BufEnter localhost_notebooks*.txt set filetype=markdown
