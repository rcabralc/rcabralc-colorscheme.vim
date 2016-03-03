" vim: fdm=marker
" Name:   rcabralc's Colorscheme for Vim.
" Author: rcabralc <rcabralc@gmail.com>
" URL:    https://github.com/rcabralc/monokai.vim
" Note:   A vibrant, warmer variation of Monokai, with a litte bit more
"         contrast between colors and white.


let s:options = {
    \ 'transparent_background': 0,
    \ 'use_default_term_colors': 0,
    \ 'prominent_search_highlight': 0,
    \ 'allow_italics': 0,
\ }

if !exists('g:rcabralc')
    let g:rcabralc = {}
endif

function! s:compute_options()
    for [k, v] in items(g:rcabralc)
        let s:options[k] = v
    endfor
endfunction
call s:compute_options()
delfunction s:compute_options

" Palette definition
" Note: The "blue" color is not used in this colorscheme because there's no
" equivalent in the original Monokai, and it's not needed anyway.  It is
" defined here as a matter of standardization; since it's recommended to change
" the terminal colorscheme for better color fidelity, it's worth to specify a
" blueish color to be used as a replacement for the 4th terminal color.
let s:blend = function('rcabralc#blend')
let s:build_color = function('rcabralc#build_color')
let s:def_term = s:options.use_default_term_colors

let s:none    = { 'gui': 'NONE', 'term': 'NONE', }
let s:black   = s:build_color('#26231d', s:def_term ? { 'term': 0  } : {})
let s:white   = s:build_color('#f5e2bc', s:def_term ? { 'term': 15 } : {})
let s:lime    = s:build_color('#9fd304', s:def_term ? { 'term': 2, 'terms': [10] } : {})
let s:yellow  = s:build_color('#ebcc66', s:def_term ? { 'term': 11 } : {})
let s:blue    = s:build_color('#73a1e1', s:def_term ? { 'term': 4, 'terms': [12] } : {})
let s:purple  = s:build_color('#b37df5', s:def_term ? { 'term': 5, 'terms': [13] } : {})
let s:cyan    = s:build_color('#73e1b3', s:def_term ? { 'term': 6, 'terms': [14] } : {})
let s:orange  = s:build_color('#f66d04', s:def_term ? { 'term': 3  } : {})
let s:magenta = s:build_color('#f60461', s:def_term ? { 'term': 1, 'terms': [9] } : {})

let s:gray0 = s:blend(s:white, s:black, 0.04)
let s:gray1 = s:blend(s:white, s:black, 0.08, s:def_term ? { 'term': 8 } : {})
let s:gray2 = s:blend(s:white, s:black, 0.12)
let s:gray3 = s:blend(s:white, s:black, 0.16)
let s:gray4 = s:blend(s:white, s:black, 0.33, s:def_term ? { 'term': 7 } : {})
let s:gray  = s:blend(s:white, s:black, 0.5)

let s:darklime     = s:blend(s:lime,    s:black, 0.0625)
let s:darkpurple   = s:blend(s:purple,  s:black, 0.25)
let s:darkerpurple = s:blend(s:purple,  s:black, 0.0625)
let s:darkmagenta  = s:blend(s:magenta, s:black, 0.0625)

if !has('gui_running') && g:rcabralc.transparent_background == 1
    let s:blackbg = { 'gui': 'NONE', 'term': 'NONE' }
else
    let s:blackbg = s:black
endif

hi clear
if exists("syntax on")
    syntax reset
endif

" Export palette
let g:rcabralc#palette = {}
let g:rcabralc#palette.none         = s:none
let g:rcabralc#palette.black        = s:black
let g:rcabralc#palette.gray0        = s:gray0
let g:rcabralc#palette.gray1        = s:gray1
let g:rcabralc#palette.gray2        = s:gray2
let g:rcabralc#palette.gray3        = s:gray3
let g:rcabralc#palette.gray4        = s:gray4
let g:rcabralc#palette.gray         = s:gray
let g:rcabralc#palette.white        = s:white
let g:rcabralc#palette.lime         = s:lime
let g:rcabralc#palette.yellow       = s:yellow
let g:rcabralc#palette.blue         = s:blue
let g:rcabralc#palette.purple       = s:purple
let g:rcabralc#palette.cyan         = s:cyan
let g:rcabralc#palette.orange       = s:orange
let g:rcabralc#palette.magenta      = s:magenta
let g:rcabralc#palette.darklime     = s:darklime
let g:rcabralc#palette.darkpurple   = s:darkpurple
let g:rcabralc#palette.darkerpurple = s:darkerpurple
let g:rcabralc#palette.darkmagenta  = s:darkmagenta

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

call s:hl('Normal', s:white, s:blackbg)

"        *Comment        any comment
if s:options.allow_italics
call s:hl('Comment', s:gray4, s:none, 'italic')
else
call s:hl('Comment', s:gray4, s:none)
endif

"        *Constant       any constant
"         String         a string constant: "this is a string"
"         Character      a character constant: 'c', '\n'
"         Number         a number constant: 234, 0xff
"         Boolean        a boolean constant: TRUE, false
"         Float          a floating point constant: 2.3e10
call s:hl('Constant',  s:purple, s:none, 'bold')
call s:hl('String',    s:yellow, s:none)
call s:hl('Character', s:purple, s:none)
call s:hl('Number',    s:purple, s:none)
call s:hl('Boolean',   s:lime,   s:none)

"        *Identifier     any variable name
"         Function       function name (also: methods for classes)
call s:hl('Identifier', s:lime, s:none)

"        *Statement      any statement
"         Conditional    if, then, else, endif, switch, etc.
"         Repeat         for, do, while, etc.
"         Label          case, default, etc.
"         Operator       "sizeof", "+", "*", etc.
"         Keyword        any other keyword
"         Exception      try, catch, throw
call s:hl('Statement', s:magenta, s:none, 'bold')
call s:hl('Operator',  s:orange,  s:none)
call s:hl('Exception', s:lime,    s:none, 'bold')

"        *PreProc        generic Preprocessor
"         Include        preprocessor #include
"         Define         preprocessor #define
"         Macro          same as Define
"         PreCondit      preprocessor #if, #else, #endif, etc.
call s:hl('PreProc', s:magenta, s:none, 'bold')

"        *Type           int, long, char, etc.
"         StorageClass   static, register, volatile, etc.
"         Structure      struct, union, enum, etc.
"         Typedef        A typedef
call s:hl('Type',         s:cyan,    s:none)
call s:hl('StorageClass', s:magenta, s:none, 'bold')

"        *Special        any special symbol
"         SpecialChar    special character in a constant
"         Tag            you can use CTRL-] on this
"         Delimiter      character that needs attention
"         SpecialComment special things inside a comment
"         Debug          debugging statements
call s:hl('Special',        s:orange,  s:none)
call s:hl('Tag',            s:cyan,    s:none, 'bold')
call s:hl('Delimiter',      s:orange,  s:none)
call s:hl('SpecialComment', s:white,   s:none, 'bold')
call s:hl('Debug',          s:purple,  s:none)

"        *Underlined     text that stands out, HTML links
call s:hl('Underlined', s:none, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call s:hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call s:hl('Error', s:magenta, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call s:hl('Todo', s:white, s:none, 'bold')


" Extended highlighting
call s:hl('SpecialKey',   s:gray4,   s:none)
call s:hl('NonText',      s:gray4,   s:none)
call s:hl('StatusLine',   s:white,   s:gray0,   'bold')
call s:hl('StatusLineNC', s:gray4,   s:gray0)
call s:hl('Visual',       s:none,    s:gray1)
call s:hl('Directory',    s:purple,  s:none)
call s:hl('ErrorMsg',     s:magenta, s:blackbg, 'bold')
call s:hl('IncSearch',    s:none,    s:gray2,   'underline')

if s:options.prominent_search_highlight
call s:hl('Search', s:none, s:none,  'reverse')
else
call s:hl('Search', s:none, s:darkpurple)
endif

call s:hl('MoreMsg',      s:cyan,    s:blackbg)
call s:hl('ModeMsg',      s:lime,    s:blackbg)
call s:hl('LineNr',       s:gray4,   s:blackbg)
call s:hl('Question',     s:cyan,    s:none,     'bold')
call s:hl('VertSplit',    s:gray4,   s:gray0)
call s:hl('Title',        s:magenta, s:none,     'bold')
call s:hl('VisualNOS',    s:black,   s:white)
call s:hl('WarningMsg',   s:orange,  s:blackbg)
call s:hl('WildMenu',     s:cyan,    s:blackbg)
call s:hl('Folded',       s:gray4,   s:blackbg)
call s:hl('FoldColumn',   s:gray4,   s:blackbg)
call s:hl('DiffAdd',      s:none,    s:lime0)
call s:hl('DiffChange',   s:none,    s:purple0)
call s:hl('DiffDelete',   s:none,    s:magenta0)
call s:hl('DiffText',     s:none,    s:purple0,  'underline')
call s:hl('SignColumn',   s:lime,    s:blackbg)
call s:hl('Conceal',      s:gray1,   s:none)
call s:hl('SpellBad',     s:none,    s:none,     'undercurl', 'NONE', s:magenta)
call s:hl('SpellCap',     s:none,    s:none,     'undercurl', 'NONE', s:cyan)
call s:hl('SpellRare',    s:none,    s:none,     'undercurl', 'NONE', s:white)
call s:hl('SpellLocal',   s:none,    s:none,     'undercurl', 'NONE', s:orange)
call s:hl('Pmenu',        s:gray1,   s:white)
call s:hl('PmenuSel',     s:orange,  s:gray1,    'bold')
call s:hl('PmenuSbar',    s:none,    s:gray4)
call s:hl('PmenuThumb',   s:none,    s:gray1)
call s:hl('TabLine',      s:black,   s:gray4)
call s:hl('TabLineFill',  s:gray4,   s:gray4)
call s:hl('TabLineSel',   s:white,   s:gray1,    'bold')
call s:hl('CursorColumn', s:none,    s:gray0)
call s:hl('CursorLine',   s:none,    s:gray0)
call s:hl('CursorLineNr', s:lime,    s:blackbg)
call s:hl('ColorColumn',  s:none,    s:gray0)
call s:hl('Cursor',       s:black,   s:white)
hi! link lCursor Cursor
call s:hl('MatchParen',   s:none,    s:none,     'reverse,underline')

" Must be at the end due to a bug in VIM trying to figuring out automagically
" if the background set through Normal highlight group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
