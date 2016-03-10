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
let s:white   = g:rcabralc#palette.white
let s:bg      = g:rcabralc#palette.bg
let s:cyan0   = g:rcabralc#palette.cyan0
let s:cyan    = g:rcabralc#palette.cyan
let s:lime0   = g:rcabralc#palette.lime0
let s:lime    = g:rcabralc#palette.lime
let s:orange0 = g:rcabralc#palette.orange0
let s:orange  = g:rcabralc#palette.orange
let s:purple0 = g:rcabralc#palette.purple0
let s:purple  = g:rcabralc#palette.purple
let s:magenta = g:rcabralc#palette.magenta
let s:gray0   = g:rcabralc#palette.gray0
let s:gray1   = g:rcabralc#palette.gray1
let s:gray2   = g:rcabralc#palette.gray2


function! s:e(fg, bg, ...)
    if a:0 == 1
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term, a:1]
    else
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term]
    endif
endfunction

let s:p.normal.left =     [ s:e(s:bg, s:cyan, 'bold'), s:e(s:white, s:cyan0, 'bold'), s:e(s:gray2, s:gray1, 'bold') ]
let s:p.normal.middle =   [ s:e(s:cyan, s:gray1, 'bold') ]
let s:p.normal.right =    [ s:e(s:bg, s:cyan), s:e(s:white, s:cyan0), s:e(s:gray2, s:gray1) ]

let s:p.inactive.left =   [ s:e(s:gray2, s:gray0), s:e(s:gray2, s:gray0) ]
let s:p.inactive.middle = [ s:e(s:gray2, s:gray0, 'bold') ]
let s:p.inactive.right =  [ s:e(s:gray2, s:gray0), s:e(s:gray2, s:gray0) ]

let s:p.insert.left =     [ s:e(s:bg, s:lime, 'bold'), s:e(s:white, s:lime0, 'bold'), s:e(s:gray2, s:gray1, 'bold') ]
let s:p.insert.middle =   [ s:e(s:lime, s:gray1, 'bold') ]
let s:p.insert.right =    [ s:e(s:bg, s:lime), s:e(s:white, s:lime0), s:e(s:gray2, s:gray1) ]

let s:p.replace.left =    [ s:e(s:bg, s:orange, 'bold'), s:e(s:white, s:orange0, 'bold'), s:e(s:gray2, s:gray1, 'bold') ]
let s:p.replace.middle =  [ s:e(s:orange, s:gray1, 'bold') ]
let s:p.replace.right =   [ s:e(s:bg, s:orange), s:e(s:white, s:orange0), s:e(s:gray2, s:gray1) ]

let s:p.visual.left =     [ s:e(s:bg, s:purple, 'bold'), s:e(s:white, s:purple0, 'bold'), s:e(s:gray2, s:gray1, 'bold') ]
let s:p.visual.middle =   [ s:e(s:purple, s:gray1, 'bold') ]
let s:p.visual.right =    [ s:e(s:bg, s:purple), s:e(s:white, s:purple0), s:e(s:gray2, s:gray1) ]

let s:p.tabline.left =    [ s:e(s:gray2, s:gray1) ]
let s:p.tabline.tabsel =  [ s:e(s:bg,    s:cyan, 'bold') ]
let s:p.tabline.middle =  [ s:e(s:gray2, s:gray0) ]
let s:p.tabline.right =   [ s:e(s:bg,    s:orange) ]

let s:p.normal.error =    [ s:e(s:black, s:magenta) ]
let s:p.normal.warning =  [ s:e(s:black, s:orange) ]

let g:lightline#colorscheme#rcabralc#palette = s:p

augroup RcabralcLightlineColorScheme
    autocmd!
    autocmd ColorScheme rcabralc so <sfile> | call lightline#enable()
augroup END
