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

function! s:color(color, ...)
    let options = a:0 >= 1 ? a:1 : {}
    let term = -1

    if has_key(options, 'term')
        let term = options.term

        if !s:options.use_default_term_colors
            call remove(options, 'term')
        endif
    endif

    let color = rcabralc#build_color(a:color, options)

    if term >= 0
        exe "let g:terminal_color_" . term . " = '" . color.gui . "'"
    end

    return color
endfunction

function! s:blend(color1, color2, opacity, ...)
    let options = a:0 >= 1 ? a:1 : {}
    let blended = rcabralc#blend(a:color1, a:color2, a:opacity)

    return s:color(blended, options)
endfunction

" Save background value: workaround for Vim bug, restored (enforced) at the
" end.
let s:is_dark = (&bg == 'dark')


" Palette definition
" ------------------

let s:none = { 'gui': 'NONE', 'term': 'NONE', }

let s:black = s:color('#342722', { 'term': s:is_dark ? 0 : 15 })
let s:white = s:color('#edb29b', { 'term': s:is_dark ? 15 : 0 })

let s:fg = s:color((s:is_dark ? s:white : s:black).rgb)
let s:opaquebg = s:color((s:is_dark ? s:black : s:white).rgb)

if !has('gui_running') && s:options.transparent_background == 1
    let s:bg = { 'gui': 'NONE', 'term': 'NONE' }
else
    let s:bg = s:opaquebg
endif

let s:basered    = '#d11b39'
let s:basegreen  = '#88ad0c'
let s:baseorange = '#ff5f02'
let s:baseyellow = '#ff983d'
let s:baseblue   = '#6383b4'
let s:basepurple = '#a74d78'
let s:basecyan   = '#addfde'

if s:is_dark
    let s:red    = s:color(s:basered,    { 'term': 9 })
    let s:green  = s:color(s:basegreen,  { 'term': 10 })
    let s:orange = s:color(s:baseorange, { 'term': 3 })
    let s:yellow = s:color(s:baseyellow, { 'term': 11 })
    let s:blue   = s:color(s:baseblue,   { 'term': 12 })
    let s:purple = s:color(s:basepurple, { 'term': 13 })
    let s:cyan   = s:color(s:basecyan,   { 'term': 14 })
else
    let s:red    = s:blend(s:color(s:basered),    s:black, 1.0, { 'term': 1 })
    let s:green  = s:blend(s:color(s:basegreen),  s:black, 0.5, { 'term': 2 })
    let s:orange = s:blend(s:color(s:baseorange), s:black, 0.7, { 'term': 11 })
    let s:yellow = s:blend(s:color(s:baseyellow), s:black, 0.5, { 'term': 3 })
    let s:blue   = s:blend(s:color(s:baseblue),   s:black, 1.0, { 'term': 4 })
    let s:purple = s:blend(s:color(s:basepurple), s:black, 1.0, { 'term': 5 })
    let s:cyan   = s:blend(s:color(s:basecyan),   s:black, 0.4, { 'term': 6 })
endif

let s:altred    = s:blend(s:red,    s:opaquebg, 0.8, { 'term': s:is_dark ? 1 : 9 })
let s:altgreen  = s:blend(s:green,  s:opaquebg, 0.8, { 'term': s:is_dark ? 2 : 10 })
let s:altorange = s:blend(s:orange, s:opaquebg, 0.8)
let s:altyellow = s:blend(s:yellow, s:opaquebg, 0.8)
let s:altblue   = s:blend(s:blue,   s:opaquebg, 0.8, { 'term': s:is_dark ? 4 : 12 })
let s:altpurple = s:blend(s:purple, s:opaquebg, 0.8, { 'term': s:is_dark ? 5 : 13 })
let s:altcyan   = s:blend(s:cyan,   s:opaquebg, 0.8, { 'term': s:is_dark ? 6 : 14 })

let s:altred2    = s:blend(s:red,    s:opaquebg, 0.4)
let s:altgreen2  = s:blend(s:green,  s:opaquebg, 0.4)
let s:altorange2 = s:blend(s:orange, s:opaquebg, 0.4)
let s:altyellow2 = s:blend(s:yellow, s:opaquebg, 0.4)
let s:altblue2   = s:blend(s:blue,   s:opaquebg, 0.4)
let s:altcyan2   = s:blend(s:cyan,   s:opaquebg, 0.4)
let s:altpurple2 = s:blend(s:purple, s:opaquebg, 0.4)

let s:redbg     = s:blend(s:red,    s:opaquebg, 0.15)
let s:greenbg   = s:blend(s:green,  s:opaquebg, 0.1)
let s:orangebg  = s:blend(s:orange, s:opaquebg, 0.2)
let s:yellowbg  = s:blend(s:yellow, s:opaquebg, 0.2)
let s:bluebg    = s:blend(s:blue,   s:opaquebg, 0.15)
let s:purplebg  = s:blend(s:purple, s:opaquebg, 0.15)

let s:gray0 = s:blend(s:fg, s:bg, 0.10)
let s:gray1 = s:blend(s:fg, s:bg, 0.15, { 'term': 8 })
let s:gray2 = s:blend(s:fg, s:bg, 0.45, { 'term': 7 })

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
let g:rcabralc#palette.blue = s:blue
let g:rcabralc#palette.purple = s:purple
let g:rcabralc#palette.cyan = s:cyan
let g:rcabralc#palette.altred = s:altred
let g:rcabralc#palette.altgreen = s:altgreen
let g:rcabralc#palette.altorange = s:altorange
let g:rcabralc#palette.altyellow = s:altyellow
let g:rcabralc#palette.altpurple = s:altpurple
let g:rcabralc#palette.altblue = s:altblue
let g:rcabralc#palette.altcyan = s:altcyan
let g:rcabralc#palette.altred2 = s:altred2
let g:rcabralc#palette.altgreen2 = s:altgreen2
let g:rcabralc#palette.altorange2 = s:altorange2
let g:rcabralc#palette.altyellow2 = s:altyellow2
let g:rcabralc#palette.altblue2 = s:altblue2
let g:rcabralc#palette.altpurple2 = s:altpurple2
let g:rcabralc#palette.altcyan2 = s:altcyan2
let g:rcabralc#palette.redbg = s:redbg
let g:rcabralc#palette.greenbg = s:greenbg
let g:rcabralc#palette.orangebg = s:orangebg
let g:rcabralc#palette.yellowbg = s:yellowbg
let g:rcabralc#palette.bluebg = s:bluebg
let g:rcabralc#palette.purplebg = s:purplebg

delfunction s:color
delfunction s:blend

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
call s:hl('Constant', s:purple, s:none, 'bold')
call s:hl('String', s:cyan, s:none)
call s:hl('Character', s:purple, s:none)
call s:hl('Number', s:blue, s:none)
call s:hl('Boolean', s:blue, s:none)

"        *Identifier     any variable name
"         Function       function name (also: methods for classes)
call s:hl('Identifier', s:cyan, s:none)
call s:hl('Function', s:yellow, s:none)

"        *Statement      any statement
"         Conditional    if, then, else, endif, switch, etc.
"         Repeat         for, do, while, etc.
"         Label          case, default, etc.
"         Operator       "sizeof", "+", "*", etc.
"         Keyword        any other keyword
"         Exception      try, catch, throw
call s:hl('Statement', s:red, s:none, 'bold')
call s:hl('Operator',  s:orange, s:none)
call s:hl('Exception', s:orange, s:none, 'bold')

"        *PreProc        generic Preprocessor
"         Include        preprocessor #include
"         Define         preprocessor #define
"         Macro          same as Define
"         PreCondit      preprocessor #if, #else, #endif, etc.
call s:hl('PreProc', s:red, s:none, 'bold')

"        *Type           int, long, char, etc.
"         StorageClass   static, register, volatile, etc.
"         Structure      struct, union, enum, etc.
"         Typedef        A typedef
call s:hl('Type', s:green, s:none, 'bold')
call s:hl('StorageClass', s:red, s:none, 'bold')

"        *Special        any special symbol
"         SpecialChar    special character in a constant
"         Tag            you can use CTRL-] on this
"         Delimiter      character that needs attention
"         SpecialComment special things inside a comment
"         Debug          debugging statements
call s:hl('Special', s:orange, s:none)
call s:hl('Tag', s:green, s:none, 'bold')
call s:hl('Delimiter', s:orange, s:none)
call s:hl('SpecialComment', s:fg, s:none, 'bold')
call s:hl('Debug', s:purple, s:none)

"        *Underlined     text that stands out, HTML links
call s:hl('Underlined', s:none, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call s:hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call s:hl('Error', s:red, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call s:hl('Todo', s:fg, s:none, 'bold')


" Extended highlighting
call s:hl('SpecialKey', s:blue, s:none)
call s:hl('NonText', s:gray2, s:none)
call s:hl('StatusLine', s:fg, s:gray0, 'bold')
call s:hl('StatusLineNC', s:gray2, s:gray0)
call s:hl('Visual', s:none, s:bluebg)
call s:hl('Directory', s:purple, s:none)
call s:hl('ErrorMsg', s:red, s:bg, 'bold')
call s:hl('IncSearch', s:opaquebg, s:yellow)
call s:hl('Search', s:opaquebg, s:yellow)
call s:hl('QuickFixLine', s:none, s:purplebg)
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
call s:hl('PmenuSel', s:opaquebg, s:purple, 'bold')
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
call s:hl('MatchParen', s:yellow, s:bg, 'bold,underline')

" Restore background saved.  Must be at the end due to a bug in VIM trying to
" figuring out automagically if the background set through Normal highlight
" group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
exe "set background=" . (s:is_dark ? 'dark' : 'light')
