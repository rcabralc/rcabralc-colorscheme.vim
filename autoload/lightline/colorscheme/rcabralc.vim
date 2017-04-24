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

let s:black    = g:rcabralc#palette.black.actual
let s:white    = g:rcabralc#palette.white.actual
let s:bg       = g:rcabralc#palette.bg.actual
let s:fg       = g:rcabralc#palette.fg.actual
let s:normal0  = g:rcabralc#palette.altpurple2.actual
let s:normal   = g:rcabralc#palette.purple.actual
let s:insert0  = g:rcabralc#palette.altgreen2.actual
let s:insert   = g:rcabralc#palette.green.actual
let s:replace0 = g:rcabralc#palette.altcyan2.actual
let s:replace  = g:rcabralc#palette.cyan.actual
let s:visual0  = g:rcabralc#palette.altpink2.actual
let s:visual   = g:rcabralc#palette.pink.actual
let s:error    = g:rcabralc#palette.red.actual
let s:warning  = g:rcabralc#palette.orange.actual
let s:gray0    = g:rcabralc#palette.gray0.actual
let s:gray1    = g:rcabralc#palette.gray1.actual
let s:gray2    = g:rcabralc#palette.gray2.actual
let s:tabsel   = g:rcabralc#palette.purple.actual
let s:tabright = g:rcabralc#palette.purple.actual


function! s:e(fg, bg, ...)
    if a:0 == 1
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term, a:1]
    else
        return [a:fg.gui, a:bg.gui, a:fg.term, a:bg.term]
    endif
endfunction

let s:p.normal.left =     [s:e(s:bg, s:normal), s:e(s:fg, s:normal0)]
let s:p.normal.middle =   [s:e(s:fg, s:gray1)]
let s:p.normal.right =    [s:e(s:bg, s:normal), s:e(s:fg, s:normal0)]

let s:p.insert.left =     [s:e(s:bg, s:insert), s:e(s:fg, s:insert0)]
let s:p.insert.middle =   [s:e(s:fg, s:gray1)]
let s:p.insert.right =    [s:e(s:bg, s:insert), s:e(s:fg, s:insert0)]

let s:p.replace.left =    [s:e(s:bg, s:replace), s:e(s:fg, s:replace0)]
let s:p.replace.middle =  [s:e(s:fg, s:gray1)]
let s:p.replace.right =   [s:e(s:bg, s:replace), s:e(s:fg, s:replace0)]

let s:p.visual.left =     [s:e(s:bg, s:visual), s:e(s:fg, s:visual0)]
let s:p.visual.middle =   [s:e(s:fg, s:gray1)]
let s:p.visual.right =    [s:e(s:bg, s:visual), s:e(s:fg, s:visual0)]

let s:p.inactive.left =   [s:e(s:gray2, s:gray0), s:e(s:gray2, s:gray0)]
let s:p.inactive.middle = [s:e(s:gray2, s:gray0)]
let s:p.inactive.right =  [s:e(s:gray2, s:gray0), s:e(s:gray2, s:gray0)]

let s:p.tabline.left =    [s:e(s:gray2, s:gray1)]
let s:p.tabline.tabsel =  [s:e(s:bg,    s:tabsel)]
let s:p.tabline.middle =  [s:e(s:gray2, s:gray0)]
let s:p.tabline.right =   [s:e(s:bg,    s:tabright)]

let s:p.normal.error =    [s:e(s:black, s:error)]
let s:p.normal.warning =  [s:e(s:black, s:warning)]

let g:lightline#colorscheme#rcabralc#palette = s:p

augroup RcabralcLightlineColorScheme
    autocmd!
    autocmd ColorScheme rcabralc so <sfile> | call lightline#enable()
augroup END
