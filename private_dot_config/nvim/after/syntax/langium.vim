syn case match

syn keyword langiumKeyword           Date EOF assoc bigint boolean current entry extends false fragment grammar hidden import infer infers infix interface left number on returns right string terminal true type with
syn match   langiumStringEscape      contained "\\\(x[0-9A-Fa-f]\{2}\|u[0-9A-Fa-f]\{4}\|u{[0-9A-Fa-f]\+}\|[0-2][0-7]\{0,2}\|3[0-6][0-7]\?\|37[0-7]\?\|[4-7][0-7]\?\|.\|$\)"
syn region  langiumDoubleQuoted      contains=langiumStringEscape start=+"+ skip=+""+ end=+"+ extend
syn region  langiumSingleQuoted      contains=langiumStringEscape start=+'+ skip=+''+ end=+'+ extend
syn region  langiumBlockComment      start="/\*" end="*/"
syn region  langiumLineComment       start="//" end="$" oneline

syn region  langiumRegex             start=" /" end="/;" oneline

" Synchronization
syn sync minlines=50
syn sync maxlines=500

command -nargs=+ HiLink hi def link <args>

HiLink langiumKeyword                @keyword
HiLink langiumDoubleQuoted           @string
HiLink langiumSingleQuoted           @string
HiLink langiumStringEscape           @string.escape
HiLink langiumBlockComment           @comment
HiLink langiumLineComment            @comment
HiLink langiumRegex                  @string

delcommand HiLink
