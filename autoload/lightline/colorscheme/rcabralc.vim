if !exists('g:lightline')
    finish
end

let s:p = {
    \ 'normal': {},
    \ 'inactive': {},
    \ 'insert': {},
    \ 'replace': {},
    \ 'visual': {},
    \ 'tabline': {},
\ }

let s:black   = g:rcabralc#palette.black
let s:gray4   = g:rcabralc#palette.gray4
let s:white   = g:rcabralc#palette.white
let s:cyan    = g:rcabralc#palette.cyan
let s:lime    = g:rcabralc#palette.lime
let s:purple  = g:rcabralc#palette.purple
let s:orange  = g:rcabralc#palette.orange
let s:magenta = g:rcabralc#palette.magenta
let s:gray0   = g:rcabralc#palette.gray0
let s:gray1   = g:rcabralc#palette.gray1
let s:gray2   = g:rcabralc#palette.gray2
let s:gray3   = g:rcabralc#palette.gray3

function! s:e(fg, bg, ...)
    if a:0 == 1
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term, a:1]
    else
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term]
    endif
endfunction

let s:purple1 = g:rcabralc#palette.purple1
let s:purple2 = g:rcabralc#palette.purple2
let s:purple3 = g:rcabralc#palette.purple3

let s:lime1 = g:rcabralc#palette.lime1
let s:lime2 = g:rcabralc#palette.lime2
let s:lime3 = g:rcabralc#palette.lime3

let s:orange1 = g:rcabralc#palette.orange1
let s:orange2 = g:rcabralc#palette.orange2
let s:orange3 = g:rcabralc#palette.orange3

let s:cyan1 = g:rcabralc#palette.cyan1
let s:cyan2 = g:rcabralc#palette.cyan2
let s:cyan3 = g:rcabralc#palette.cyan3

let s:p.normal.left =     [ s:e(s:white, s:purple3, 'bold'), s:e(s:white, s:purple2, 'bold'), s:e(s:white, s:purple1, 'bold') ]
let s:p.normal.middle =   [ s:e(s:purple, s:gray1, 'bold') ]
let s:p.normal.right =    [ s:e(s:white, s:purple3), s:e(s:white, s:purple2), s:e(s:white, s:purple1) ]

let s:p.inactive.left =   [ s:e(s:gray4, s:gray0), s:e(s:gray4, s:gray0) ]
let s:p.inactive.middle = [ s:e(s:gray4, s:gray0, 'bold') ]
let s:p.inactive.right =  [ s:e(s:gray4, s:gray0), s:e(s:gray4, s:gray0) ]

let s:p.insert.left =     [ s:e(s:white, s:lime3, 'bold'), s:e(s:white, s:lime2, 'bold'), s:e(s:white, s:lime1, 'bold') ]
let s:p.insert.middle =   [ s:e(s:lime, s:gray1, 'bold') ]
let s:p.insert.right =    [ s:e(s:white, s:lime3), s:e(s:white, s:lime2), s:e(s:white, s:lime1) ]

let s:p.replace.left =    [ s:e(s:white, s:orange3, 'bold'), s:e(s:white, s:orange2, 'bold'), s:e(s:white, s:orange1, 'bold') ]
let s:p.replace.middle =  [ s:e(s:orange, s:gray1, 'bold') ]
let s:p.replace.right =   [ s:e(s:white, s:orange3), s:e(s:white, s:orange2), s:e(s:white, s:orange1) ]

let s:p.visual.left =     [ s:e(s:white, s:cyan3, 'bold'), s:e(s:white, s:cyan2, 'bold'), s:e(s:white, s:cyan1, 'bold') ]
let s:p.visual.middle =   [ s:e(s:cyan, s:gray1, 'bold') ]
let s:p.visual.right =    [ s:e(s:white, s:cyan3), s:e(s:white, s:cyan2), s:e(s:white, s:cyan1) ]

let s:p.tabline.left =    [ s:e(s:gray4, s:gray1) ]
let s:p.tabline.tabsel =  [ s:e(s:white, s:purple) ]
let s:p.tabline.middle =  [ s:e(s:gray4, s:gray1, 'bold') ]
let s:p.tabline.right =   [ s:e(s:black, s:orange) ]

let s:p.normal.error =    [ s:e(s:black, s:magenta) ]
let s:p.normal.warning =  [ s:e(s:black, s:orange) ]

let g:lightline#colorscheme#rcabralc#palette = s:p

augroup RcabralcLightlineColorScheme
    autocmd!
    autocmd ColorScheme rcabralc so <sfile> | call lightline#enable()
augroup END
