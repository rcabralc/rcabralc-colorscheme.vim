" vim: fdm=marker
" Name:   rcabralc's Colorscheme for Vim.
" Author: rcabralc <rcabralc@gmail.com>
" URL:    https://github.com/rcabralc/rcabralc-colorscheme.vim


let s:options = {
    \ 'transparent_background': 0,
    \ 'use_default_term_colors': 0,
    \ 'allow_italics': 0,
\ }

function! s:merge_options()
    for [k, v] in items(exists('g:rcabralc') ? g:rcabralc : {})
        let s:options[k] = v
    endfor
endfunction
call s:merge_options()
delfunction s:merge_options

let s:color = function('rcabralc#build_color')

" Save background value: workaround for Vim bug, restored (enforced) at the
" end.
let s:is_dark = (&bg == 'dark')


" Palette definition
" ------------------

let s:none = { 'gui': 'NONE', 'term': 'NONE', }

let s:black = s:color(rcabralc#hsv(0, 25, 20).gui, { 'term': s:is_dark ? 0 : 15 })
let s:white = s:color(rcabralc#hsv(0, 25, 95).gui, { 'term': s:is_dark ? 15 : 0 })

let s:fg = copy(s:is_dark ? s:white : s:black)
let s:opaquebg = copy(s:is_dark ? s:black : s:white)

if !has('gui_running') && s:options.transparent_background == 1
    let s:bg = { 'gui': 'NONE', 'term': 'NONE' }
else
    let s:bg = s:opaquebg
endif

let s:basered      = rcabralc#hsv(  0, 70, 90).gui
let s:basered_l    = rcabralc#hsv(  0, 70, 55).gui
let s:basegreen    = rcabralc#hsv( 90, 50, 95).gui
let s:basegreen_l  = rcabralc#hsv( 90, 50, 55).gui
let s:baseorange   = rcabralc#hsv( 15, 70, 95).gui
let s:baseorange_l = rcabralc#hsv( 15, 70, 70).gui
let s:baseyellow   = rcabralc#hsv( 15, 50, 95).gui
let s:baseyellow_l = rcabralc#hsv( 15, 50, 50).gui
let s:basepurple   = rcabralc#hsv(300, 35, 60).gui
let s:basepurple_l = rcabralc#hsv(300, 35, 60).gui
let s:basepink     = rcabralc#hsv(345, 50, 90).gui
let s:basepink_l   = rcabralc#hsv(345, 50, 55).gui
let s:basecyan     = rcabralc#hsv(180, 50, 95).gui
let s:basecyan_l   = rcabralc#hsv(180, 50, 50).gui

if s:is_dark
    let s:red    = s:color(s:basered,    { 'term': 9 })
    let s:green  = s:color(s:basegreen,  { 'term': 10 })
    let s:orange = s:color(s:baseorange, { 'term': 3 })
    let s:yellow = s:color(s:baseyellow, { 'term': 11 })
    let s:purple = s:color(s:basepurple, { 'term': 12 })
    let s:pink   = s:color(s:basepink,   { 'term': 13 })
    let s:cyan   = s:color(s:basecyan,   { 'term': 14 })
else
    let s:red    = s:color(s:basered_l,    { 'term': 1 })
    let s:green  = s:color(s:basegreen_l,  { 'term': 2 })
    let s:orange = s:color(s:baseorange_l, { 'term': 11 })
    let s:yellow = s:color(s:baseyellow_l, { 'term': 3 })
    let s:purple = s:color(s:basepurple_l, { 'term': 4 })
    let s:pink   = s:color(s:basepink_l,   { 'term': 5 })
    let s:cyan   = s:color(s:basecyan_l,   { 'term': 6 })
endif

let s:altred = s:red.blend(s:opaquebg, 0.8).term_aware(s:is_dark ? 1 : 9 )
let s:altgreen = s:green.blend(s:opaquebg, 0.8).term_aware(s:is_dark ? 2 : 10)
let s:altorange = s:orange.blend(s:opaquebg, 0.8).term_aware()
let s:altyellow = s:yellow.blend(s:opaquebg, 0.8).term_aware()
let s:altpurple = s:purple.blend(s:opaquebg, 0.8).term_aware(s:is_dark ? 4 : 12)
let s:altpink = s:pink.blend(s:opaquebg, 0.8).term_aware(s:is_dark ? 5 : 13)
let s:altcyan = s:cyan.blend(s:opaquebg, 0.8).term_aware(s:is_dark ? 6 : 14)

let s:altred2 = s:red.blend(s:opaquebg, 0.4).term_aware()
let s:altgreen2 = s:green.blend(s:opaquebg, 0.4).term_aware()
let s:altorange2 = s:orange.blend(s:opaquebg, 0.4).term_aware()
let s:altyellow2 = s:yellow.blend(s:opaquebg, 0.4).term_aware()
let s:altpurple2 = s:purple.blend(s:opaquebg, 0.4).term_aware()
let s:altcyan2 = s:cyan.blend(s:opaquebg, 0.4).term_aware()
let s:altpink2 = s:pink.blend(s:opaquebg, 0.4).term_aware()

let s:redbg = s:red.blend(s:opaquebg, 0.1).term_aware()
let s:greenbg = s:green.blend(s:opaquebg, 0.1).term_aware()
let s:orangebg = s:orange.blend(s:opaquebg, 0.2).term_aware()
let s:yellowbg = s:yellow.blend(s:opaquebg, 0.2).term_aware()
let s:purplebg = s:purple.blend(s:opaquebg, 0.15).term_aware()
let s:pinkbg = s:pink.blend(s:opaquebg, 0.15).term_aware()

let s:gray0 = s:fg.blend(s:bg, 0.10).term_aware()
let s:gray1 = s:fg.blend(s:bg, 0.15).term_aware(8)
let s:gray2 = s:fg.blend(s:bg, 0.45).term_aware(7)

" Export the palette
let g:rcabralc#palette = {}
let g:rcabralc#palette.none = s:none
let g:rcabralc#palette.bg = s:opaquebg
let g:rcabralc#palette.fg = s:fg
let g:rcabralc#palette.black = s:black
let g:rcabralc#palette.gray0 = s:gray0
let g:rcabralc#palette.gray1 = s:gray1
let g:rcabralc#palette.gray2 = s:gray2
let g:rcabralc#palette.white = s:white
let g:rcabralc#palette.red = s:red
let g:rcabralc#palette.green = s:green
let g:rcabralc#palette.orange = s:orange
let g:rcabralc#palette.yellow = s:yellow
let g:rcabralc#palette.purple = s:purple
let g:rcabralc#palette.pink = s:pink
let g:rcabralc#palette.cyan = s:cyan
let g:rcabralc#palette.altred = s:altred
let g:rcabralc#palette.altgreen = s:altgreen
let g:rcabralc#palette.altorange = s:altorange
let g:rcabralc#palette.altyellow = s:altyellow
let g:rcabralc#palette.altpink = s:altpink
let g:rcabralc#palette.altpurple = s:altpurple
let g:rcabralc#palette.altcyan = s:altcyan
let g:rcabralc#palette.altred2 = s:altred2
let g:rcabralc#palette.altgreen2 = s:altgreen2
let g:rcabralc#palette.altorange2 = s:altorange2
let g:rcabralc#palette.altyellow2 = s:altyellow2
let g:rcabralc#palette.altpurple2 = s:altpurple2
let g:rcabralc#palette.altpink2 = s:altpink2
let g:rcabralc#palette.altcyan2 = s:altcyan2
let g:rcabralc#palette.redbg = s:redbg
let g:rcabralc#palette.greenbg = s:greenbg
let g:rcabralc#palette.orangebg = s:orangebg
let g:rcabralc#palette.yellowbg = s:yellowbg
let g:rcabralc#palette.purplebg = s:purplebg
let g:rcabralc#palette.pinkbg = s:pinkbg

function! s:name_colors()
    for [name, color] in items(g:rcabralc#palette)
        let color.name = name
    endfor
endfunction
call s:name_colors()
delfunction s:name_colors

" Highlight definitions
" For relevant help:
" :help highlight-groups
" :help cterm-colors
" :help group-name

" For testing:
" :source $VIMRUNTIME/syntax/hitest.vim

hi clear
if exists("syntax on")
    syntax reset
endif

let s:hl = function('rcabralc#hl')
let g:colors_name = "rcabralc"

call s:hl('Normal', s:fg, s:bg)

"        *Comment        any comment
if s:options.allow_italics
    call s:hl('Comment', s:gray2, s:none, 'italic')
else
    call s:hl('Comment', s:gray2, s:none)
endif

"        *Constant       any constant
"         String         a string constant: "this is a string"
"         Character      a character constant: 'c', '\n'
"         Number         a number constant: 234, 0xff
"         Boolean        a boolean constant: TRUE, false
"         Float          a floating point constant: 2.3e10
call s:hl('Constant', s:pink, s:none, 'bold')
call s:hl('String', s:yellow, s:none)
call s:hl('Number', s:purple, s:none)
call s:hl('Boolean', s:purple, s:none)

"        *Identifier     any variable name
"         Function       function name (also: methods for classes)
call s:hl('Identifier', s:pink, s:none)
call s:hl('Function', s:red, s:none, 'bold')

"        *Statement      any statement
"         Conditional    if, then, else, endif, switch, etc.
"         Repeat         for, do, while, etc.
"         Label          case, default, etc.
"         Operator       "sizeof", "+", "*", etc.
"         Keyword        any other keyword
"         Exception      try, catch, throw
call s:hl('Statement', s:purple, s:none, 'bold')
call s:hl('Operator', s:cyan, s:none)
call s:hl('Exception', s:red, s:none, 'bold')

"        *PreProc        generic Preprocessor
"         Include        preprocessor #include
"         Define         preprocessor #define
"         Macro          same as Define
"         PreCondit      preprocessor #if, #else, #endif, etc.
call s:hl('PreProc', s:purple, s:none, 'bold')

"        *Type           int, long, char, etc.
"         StorageClass   static, register, volatile, etc.
"         Structure      struct, union, enum, etc.
"         Typedef        A typedef
call s:hl('Type', s:green, s:none)
call s:hl('StorageClass', s:red, s:none, 'bold')

"        *Special        any special symbol
"         SpecialChar    special character in a constant
"         Tag            you can use CTRL-] on this
"         Delimiter      character that needs attention
"         SpecialComment special things inside a comment
"         Debug          debugging statements
call s:hl('Special', s:orange, s:none)
call s:hl('Tag', s:cyan, s:none)
call s:hl('Delimiter', s:orange, s:none)
call s:hl('SpecialComment', s:cyan, s:none, 'bold')
call s:hl('Debug', s:cyan, s:none)

"        *Underlined     text that stands out, HTML links
call s:hl('Underlined', s:cyan, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call s:hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call s:hl('Error', s:red, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call s:hl('Todo', s:orange, s:none, 'bold')


" Extended highlighting
call s:hl('SpecialKey', s:purple, s:none)
call s:hl('NonText', s:gray2, s:none)
call s:hl('StatusLine', s:fg, s:gray0, 'bold')
call s:hl('StatusLineNC', s:gray2, s:gray0)
call s:hl('Visual', s:none, s:pinkbg)
call s:hl('Directory', s:pink, s:none)
call s:hl('ErrorMsg', s:red, s:bg, 'bold')
call s:hl('IncSearch', s:opaquebg, s:yellow)
call s:hl('Search', s:opaquebg, s:yellow)
call s:hl('QuickFixLine', s:none, s:pinkbg)
call s:hl('MoreMsg', s:green, s:bg)
call s:hl('ModeMsg', s:orange, s:bg)
call s:hl('LineNr', s:gray2, s:bg)
call s:hl('Question', s:green, s:none, 'bold')
call s:hl('VertSplit', s:gray2, s:gray0)
call s:hl('Title', s:red, s:none, 'bold')
call s:hl('VisualNOS', s:opaquebg, s:fg)
call s:hl('WarningMsg', s:orange, s:bg)
call s:hl('WildMenu', s:green, s:bg)
call s:hl('Folded', s:gray2, s:bg)
call s:hl('FoldColumn', s:gray2, s:bg)
call s:hl('DiffAdd', s:none, s:greenbg)
call s:hl('DiffChange', s:none, s:purplebg)
call s:hl('DiffDelete', s:none, s:redbg)
call s:hl('DiffText', s:none, s:greenbg, 'underline')
call s:hl('SignColumn', s:orange, s:bg)
call s:hl('Conceal', s:gray0, s:none)
if has('gui_running')
    call s:hl('SpellBad', s:none, s:none, 'undercurl', 'NONE', s:red)
    call s:hl('SpellCap', s:none, s:none, 'undercurl', 'NONE', s:green)
    call s:hl('SpellRare', s:none, s:none, 'undercurl', 'NONE', s:white)
    call s:hl('SpellLocal', s:none, s:none, 'undercurl', 'NONE', s:orange)
else
    call s:hl('SpellBad', s:none, s:redbg, 'underline', 'NONE', s:red)
    call s:hl('SpellCap', s:none, s:greenbg, 'underline', 'NONE', s:green)
    call s:hl('SpellRare', s:none, s:none, 'underline', 'NONE', s:white)
    call s:hl('SpellLocal', s:none, s:orangebg, 'underline', 'NONE', s:orange)
endif
call s:hl('Pmenu', s:fg, s:gray1)
call s:hl('PmenuSel', s:opaquebg, s:pink, 'bold')
call s:hl('PmenuSbar', s:none, s:gray1)
call s:hl('PmenuThumb', s:none, s:gray2)
call s:hl('TabLine', s:gray2, s:gray1)
call s:hl('TabLineFill', s:gray0, s:gray0)
call s:hl('TabLineSel', s:fg, s:gray2, 'bold')
call s:hl('CursorColumn', s:none, s:gray0)
call s:hl('CursorLine', s:none, s:gray0)
call s:hl('CursorLineNr', s:orange, s:bg)
call s:hl('ColorColumn', s:none, s:gray0)
call s:hl('Cursor', s:none, s:none, 'reverse')
hi! link lCursor Cursor
call s:hl('MatchParen', s:cyan, s:bg, 'bold,reverse')

" Restore background saved.  Must be at the end due to a bug in VIM trying to
" figuring out automagically if the background set through Normal highlight
" group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
exe "set background=" . (s:is_dark ? 'dark' : 'light')
