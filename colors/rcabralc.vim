" vim: fdm=marker
" Name:   rcabralc's Colorscheme for Vim.
" Author: rcabralc <rcabralc@gmail.com>
" URL:    https://github.com/rcabralc/monokai.vim
" Note:   A vibrant, warmer variation of Monokai, with a litte bit more
"         contrast between colors and white.


" The term colors were obtained by minimizing distance between xterm colors and
" the desired RGB colors.  This is not precise because RGB (or sRGB) is not an
" orthogonal space and metric distance doesn't reflect actual differences in
" vision perception.
" TODO: Provide better approximation (maybe through CSApprox?).

" {{{
function! s:blend(fg, bg, opacity)
    let fg = s:from_hex_color(a:fg)
    let bg = s:from_hex_color(a:bg)
    let opacity = a:opacity / 255.0

    let result = {}

    let result.r = fg.r * opacity + bg.r * (1 - opacity)
    let result.g = fg.g * opacity + bg.g * (1 - opacity)
    let result.b = fg.b * opacity + bg.b * (1 - opacity)

    return s:to_hex_color(result)
endfunction

function! s:from_hex_color(color)
    return {
        \ 'r': ('0x' . a:color[1:2]) + 0,
        \ 'g': ('0x' . a:color[3:4]) + 0,
        \ 'b': ('0x' . a:color[5:]) + 0,
    \ }
endfunction

function! s:to_hex_color(color)
    let r = float2nr(round(a:color.r))
    let g = float2nr(round(a:color.g))
    let b = float2nr(round(a:color.b))

    let r = r > 255 ? 255 : r
    let g = g > 255 ? 255 : g
    let b = b > 255 ? 255 : b

    return printf('#%02x%02x%02x', r, g, b)
endfunction
" }}}

if !exists("g:rcabralc#transparent_background")
    let g:rcabralc#transparent_background = 0
endif

if !exists("g:rcabralc#use_default_term_colors")
    let g:rcabralc#use_default_term_colors = 0
endif

if !exists("g:rcabralc#prominent_search_highlight")
    let g:rcabralc#prominent_search_highlight = 1
endif

if !exists("g:rcabralc#allow_italics")
    let g:rcabralc#allow_italics = 0
endif

" Note: The "blue" color is not used in this colorscheme because there's no
" equivalent in the original Monokai, and it's not needed anyway.  It is
" defined here as a matter of standardization; since it's recommended to change
" the terminal colorscheme for better color fidelity, it's worth to specify a
" blueish color to be used as a replacement for the 4th terminal color.
let s:none      = { 'gui': 'NONE',    'term': 'NONE', 'term_default': 'NONE' }
let s:black     = { 'gui': '#24231d', 'term': 235,    'term_default': 0      }
let s:darkgray  = { 'gui': '#36342b', 'term': 236,    'term_default': 8      }
let s:lightgray = { 'gui': '#6e6a57', 'term': 241,    'term_default': 7      }
let s:white     = { 'gui': '#fff6cd', 'term': 230,    'term_default': 15     }
let s:lime      = { 'gui': '#9fd304', 'term': 148,    'term_default': 10     }
let s:yellow    = { 'gui': '#ebcc66', 'term': 185,    'term_default': 11     }
let s:blue      = { 'gui': '#6f82d9', 'term': 68,     'term_default': 12     }
let s:purple    = { 'gui': '#a773e2', 'term': 140,    'term_default': 13     }
let s:cyan      = { 'gui': '#60bda8', 'term': 73,     'term_default': 14     }
let s:orange    = { 'gui': '#f66d04', 'term': 202,    'term_default': 3      }
let s:magenta   = { 'gui': '#f60461', 'term': 197,    'term_default': 9      }

" These are only defined for GUI.
let s:darklime    = { 'gui': s:blend(s:lime.gui,    s:black.gui, 48) }
let s:darkyellow  = { 'gui': s:blend(s:yellow.gui,  s:black.gui, 48) }
let s:darkpurple  = { 'gui': s:blend(s:purple.gui,  s:black.gui, 48) }
let s:darkcyan    = { 'gui': s:blend(s:cyan.gui,    s:black.gui, 48) }
let s:darkmagenta = { 'gui': s:blend(s:magenta.gui, s:black.gui, 48) }

if g:rcabralc#transparent_background == 1
    let s:blackbg = { 'gui': 'NONE', 'term': 'NONE', 'term_default': 'NONE' }
else
    let s:blackbg = {
        \ 'gui': s:black.gui,
        \ 'term': s:black.term,
        \ 'term_default': s:black.term_default
    \ }
endif

if g:rcabralc#use_default_term_colors == 1
    let s:term_key = 'term_default'
else
    let s:term_key = 'term'
endif

function! rcabralc#hl(group, fg, bg, ...)
    let fg_color = a:fg
    let bg_color = a:bg
    let gui_fg = fg_color.gui
    let gui_bg = bg_color.gui
    let term_fg = fg_color[s:term_key]
    let term_bg = bg_color[s:term_key]
    let gui_sp = ''

    if a:0 > 0
        let gui_mod = a:1
        if a:0 > 1
            let term_mod = a:2
        else
            let term_mod = a:1
        endif

        if a:0 > 2
            let gui_sp = ' guisp=' . a:3.gui
        endif
    else
        let gui_mod = 'NONE'
        let term_mod = 'NONE'
    endif

    if term_mod == 'bold' && (term_fg == 3 || term_fg == 7)
        let term_mod = 'NONE'
    endif

    exe "hi! " . a:group .
        \ " ctermfg=" . term_fg .
        \ " ctermbg=" . term_bg .
        \ " cterm="   . term_mod .
        \ " guifg="   . gui_fg .
        \ " guibg="   . gui_bg .
        \ " gui="     . gui_mod .
        \ gui_sp
endfunction
let s:hl = function('rcabralc#hl')

function! rcabralc#hlgui(group, fg, bg, ...)
    let gui_fg = a:fg.gui
    let gui_bg = a:bg.gui
    let gui_sp = ''

    if a:0 > 0
        let gui_mod = a:1

        if a:0 > 2
            let gui_sp = ' guisp=' . a:3.gui
        endif
    else
        let gui_mod = 'NONE'
    endif

    exe "hi! " . a:group .
        \ " guifg="   . gui_fg .
        \ " guibg="   . gui_bg .
        \ " gui="     . gui_mod .
        \ gui_sp
endfunction
let s:hlgui = function('rcabralc#hlgui')

hi clear
if exists("syntax on")
    syntax reset
endif

set t_Co=256
let g:colors_name = "rcabralc"

" For relevant help:
" :help highlight-groups
" :help cterm-colors
" :help group-name

" For testing:
" :source $VIMRUNTIME/syntax/hitest.vim

call s:hl('Normal',         s:white,     s:blackbg)
call s:hl('Comment',        s:lightgray, s:none)

if g:rcabralc#allow_italics
    "            *Comment        any comment
    call s:hlgui('Comment', s:lightgray, s:none, 'italic')
else
    call s:hlgui('Comment', s:lightgray, s:none)
endif

call s:hl('Constant',       s:purple,    s:none, 'bold')
"         *Constant       any constant
"          String         a string constant: "this is a string"
"          Character      a character constant: 'c', '\n'
"          Number         a number constant: 234, 0xff
"          Boolean        a boolean constant: TRUE, false
"          Float          a floating point constant: 2.3e10
call s:hl('String',         s:yellow,    s:none)
call s:hl('Number',         s:purple,    s:none)
call s:hl('Boolean',        s:orange,    s:none)

call s:hl('Identifier',     s:lime,      s:none)
"         *Identifier     any variable name
"          Function       function name (also: methods for classes)

call s:hl('Statement',      s:magenta,   s:none, 'bold')
"         *Statement      any statement
"          Conditional    if, then, else, endif, switch, etc.
"          Repeat         for, do, while, etc.
"          Label          case, default, etc.
"          Operator       "sizeof", "+", "*", etc.
"          Keyword        any other keyword
"          Exception      try, catch, throw
call s:hl('Operator',       s:magenta,   s:none)
call s:hl('Exception',      s:lime,      s:none, 'bold')

call s:hl('PreProc',        s:magenta,   s:none, 'bold')
"         *PreProc        generic Preprocessor
"          Include        preprocessor #include
"          Define         preprocessor #define
"          Macro          same as Define
"          PreCondit      preprocessor #if, #else, #endif, etc.

call s:hl('Type',           s:cyan,      s:none, 'bold')
"         *Type           int, long, char, etc.
"          StorageClass   static, register, volatile, etc.
"          Structure      struct, union, enum, etc.
"          Typedef        A typedef
call s:hl('StorageClass',   s:magenta,   s:none, 'bold')

call s:hl('Special',        s:orange,    s:none)
"         *Special        any special symbol
"          SpecialChar    special character in a constant
"          Tag            you can use CTRL-] on this
"          Delimiter      character that needs attention
"          SpecialComment special things inside a comment
"          Debug          debugging statements
call s:hl('Tag',            s:magenta,   s:none, 'bold')
call s:hl('SpecialComment', s:white,     s:none, 'bold')

call s:hl('Underlined',     s:none,      s:none, 'underline')
"         *Underlined     text that stands out, HTML links

call s:hl('Ignore',         s:none,      s:none)
"         *Ignore         left blank, hidden |hl-Ignore|

call s:hl('Error',          s:magenta,   s:none, 'bold,reverse')
"         *Error          any erroneous construct

call s:hl('Todo',           s:white,     s:none, 'bold')
"         *Todo           anything that needs extra attention; mostly the
"                         keywords TODO FIXME and XXX


" Extended highlighting
call s:hl('SpecialKey',   s:orange,    s:none)
call s:hl('NonText',      s:lightgray, s:none)
call s:hl('StatusLine',   s:white,     s:darkgray,  'bold')
call s:hl('StatusLineNC', s:lightgray, s:darkgray)
call s:hl('Visual',       s:none,      s:darkgray)
call s:hl('Directory',    s:purple,    s:none)
call s:hl('ErrorMsg',     s:magenta,   s:blackbg,   'bold')
call s:hl('IncSearch',    s:none,      s:none,      'underline')

if g:rcabralc#prominent_search_highlight
    call s:hl('Search',       s:none,      s:none,      'reverse')
else
    call s:hl('Search',       s:none,      s:darkgray,  'underline')
endif

call s:hl('MoreMsg',      s:cyan,      s:blackbg)
call s:hl('ModeMsg',      s:lime,      s:blackbg)
call s:hl('LineNr',       s:lightgray, s:blackbg)
call s:hl('Question',     s:cyan,      s:none,      'bold')
call s:hl('VertSplit',    s:lightgray, s:darkgray)
call s:hl('Title',        s:white,     s:none,      'bold')
call s:hl('VisualNOS',    s:black,     s:white)
call s:hl('WarningMsg',   s:orange,    s:blackbg)
call s:hl('WildMenu',     s:cyan,      s:blackbg)
call s:hl('Folded',       s:lightgray, s:blackbg)
call s:hl('FoldColumn',   s:lightgray, s:blackbg)
call s:hl('DiffAdd',      s:lime,      s:none,      'bold')
call s:hl('DiffChange',   s:purple,    s:none,      'bold')
call s:hl('DiffDelete',   s:magenta,   s:none,      'bold')
call s:hl('DiffText',     s:yellow,    s:none,      'bold')
call s:hl('SignColumn',   s:lime,      s:blackbg)
call s:hl('Conceal',      s:darkgray,  s:none)
call s:hl('SpellBad',     s:none,      s:none,      'undercurl', 'NONE', s:magenta)
call s:hl('SpellCap',     s:none,      s:none,      'undercurl', 'NONE', s:cyan)
call s:hl('SpellRare',    s:none,      s:none,      'undercurl', 'NONE', s:white)
call s:hl('SpellLocal',   s:none,      s:none,      'undercurl', 'NONE', s:orange)
call s:hl('Pmenu',        s:darkgray,  s:white)
call s:hl('PmenuSel',     s:orange,    s:darkgray,  'bold')
call s:hl('PmenuSbar',    s:none,      s:lightgray)
call s:hl('PmenuThumb',   s:none,      s:darkgray)
call s:hl('TabLine',      s:black,     s:lightgray)
call s:hl('TabLineFill',  s:lightgray, s:lightgray)
call s:hl('TabLineSel',   s:white,     s:darkgray,  'bold')
call s:hl('CursorColumn', s:none,      s:darkgray)
call s:hl('CursorLine',   s:none,      s:darkgray)
call s:hl('CursorLineNr', s:lime,      s:blackbg)
call s:hl('ColorColumn',  s:none,      s:darkgray)
call s:hl('Cursor',       s:black,     s:white)
hi! link lCursor Cursor
call s:hl('MatchParen',   s:none,      s:none,      'reverse,underline')

call s:hlgui('DiffAdd',    s:none,        s:darklime)
call s:hlgui('DiffChange', s:none,        s:darkpurple)
call s:hlgui('DiffDelete', s:none,        s:darkmagenta)
call s:hlgui('DiffText',   s:white,       s:darkyellow, 'bold')

" Must be at the end due to a bug in VIM trying to figuring out automagically
" if the background set through Normal highlight group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark

" Additions for vim-gitgutter
call s:hl('GitGutterAdd',          s:lime,    s:none)
call s:hl('GitGutterChange',       s:purple,  s:none)
call s:hl('GitGutterDelete',       s:magenta, s:none)
call s:hl('GitGutterChangeDelete', s:magenta, s:none)

" Export palette
let g:rcabralc#palette = {}
let g:rcabralc#palette.none        = s:none
let g:rcabralc#palette.black       = s:black
let g:rcabralc#palette.darkgray    = s:darkgray
let g:rcabralc#palette.lightgray   = s:lightgray
let g:rcabralc#palette.white       = s:white
let g:rcabralc#palette.lime        = s:lime
let g:rcabralc#palette.yellow      = s:yellow
let g:rcabralc#palette.blue        = s:blue
let g:rcabralc#palette.purple      = s:purple
let g:rcabralc#palette.cyan        = s:cyan
let g:rcabralc#palette.orange      = s:orange
let g:rcabralc#palette.magenta     = s:magenta
let g:rcabralc#palette.darklime    = s:darklime
let g:rcabralc#palette.darkyellow  = s:darkyellow
let g:rcabralc#palette.darkpurple  = s:darkpurple
let g:rcabralc#palette.darkcyan    = s:darkcyan
let g:rcabralc#palette.darkmagenta = s:darkmagenta
let g:rcabralc#palette.blackbg     = s:blackbg
