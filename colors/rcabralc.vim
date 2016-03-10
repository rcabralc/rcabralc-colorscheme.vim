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

function! s:merge_term(options, term)
    if s:options.use_default_term_colors
        let a:options.term = a:term
    endif
    return a:options
endfunction

let s:none    = { 'gui': 'NONE', 'term': 'NONE', }
let s:black   = s:build_color('#26231d', s:merge_term({}, 0))
let s:white   = s:build_color('#f5e2bc', s:merge_term({}, 15))
let s:lime    = s:build_color('#9fd304', s:merge_term({}, 10))
let s:yellow  = s:build_color('#ebcc66', s:merge_term({}, 11))
let s:blue    = s:build_color('#73a1e1', s:merge_term({}, 12))
let s:purple  = s:build_color('#b482ff', s:merge_term({}, 13))
let s:cyan    = s:build_color('#73e1b3', s:merge_term({}, 14))
let s:orange  = s:build_color('#f66d04', s:merge_term({}, 3))
let s:magenta = s:build_color('#f60461', s:merge_term({}, 9))

let s:background = &bg
let s:fg = s:background == 'dark' ? s:white : s:black
let s:bg = s:background == 'dark' ? s:black : s:white
let s:bgfg = s:bg

if !has('gui_running') && s:options.transparent_background == 1
    let s:bg = { 'gui': 'NONE', 'term': 'NONE' }
endif

let g:rcabralc#palette = {}

function! s:define_color_shades(term_codes)
    let opacities = { 0: 0.125 , 1: 0.25, 2: 0.375, 3: 0.5, 4: 0.625, 5: 0.75 }
    for name in ['magenta', 'lime', 'orange', 'blue', 'purple', 'cyan']

        if s:background == 'dark'
            let color2 = s:black
            exe 'let color1 = s:' . name
        else
            let color1 = s:black
            exe 'let color2 = s:' . name
        endif

        for [index, opacity] in items(opacities)
            let color_name = name . index

            if has_key(a:term_codes[s:background], color_name)
                let options = s:merge_term({}, a:term_codes[s:background][color_name])
            else
                let options = {}
            endif

            let shade = s:blend(color1, color2, opacity, options)

            exe 'let s:' . color_name . ' = shade'
            exe 'let g:rcabralc#palette.' . color_name . ' = shade'
        endfor
    endfor
endfunction

call s:define_color_shades({
    \ 'dark':  { 'magenta5': 1, 'lime5': 2, 'blue5': 4, 'purple5': 5, 'cyan5': 6 },
    \ 'light': { 'magenta1': 1, 'lime3': 2, 'blue1': 4, 'purple1': s:purple.term, 'cyan3': 6 },
\ })

delfunction s:define_color_shades

if s:background != 'dark'
    let s:lime   = s:build_color(s:lime2.rgb,   s:merge_term({}, s:lime.term))
    let s:orange = s:build_color(s:orange1.rgb, s:merge_term({}, s:orange.term))
    let s:purple = s:build_color(s:purple3.rgb, s:merge_term({}, 5))
    let s:cyan   = s:build_color(s:cyan2.rgb,   s:merge_term({}, s:cyan.term))
    let s:yellow = s:blend(s:yellow, s:black, 0.625, s:merge_term({}, 11))
endif

if s:background == 'dark'
    let s:gray0 = s:blend(s:white, s:black, 0.04)
    let s:gray1 = s:blend(s:white, s:black, 0.12, s:merge_term({}, 8))
else
    let s:gray0 = s:blend(s:black, s:white, 0.08)
    let s:gray1 = s:blend(s:black, s:white, 0.16, s:merge_term({}, 8))
endif
let s:gray2 = s:blend(s:white, s:black, 0.33, s:merge_term({}, 7))

let s:limebg    = s:blend(s:lime,    s:bg, 0.125)
let s:cyanbg    = s:blend(s:cyan,    s:bg, 0.125)
let s:purplebg  = s:blend(s:purple,  s:bg, 0.125)
let s:magentabg = s:blend(s:magenta, s:bg, 0.125)

delfunction s:merge_term

" Export the rest of the palette
let g:rcabralc#palette.none    = s:none
let g:rcabralc#palette.black   = s:black
let g:rcabralc#palette.gray0   = s:gray0
let g:rcabralc#palette.gray1   = s:gray1
let g:rcabralc#palette.gray2   = s:gray2
let g:rcabralc#palette.white   = s:white
let g:rcabralc#palette.lime    = s:lime
let g:rcabralc#palette.yellow  = s:yellow
let g:rcabralc#palette.blue    = s:blue
let g:rcabralc#palette.purple  = s:purple
let g:rcabralc#palette.cyan    = s:cyan
let g:rcabralc#palette.orange  = s:orange
let g:rcabralc#palette.magenta = s:magenta

function! s:name_colors(palette)
    for [name, color] in items(a:palette)
        let color.name = name
    endfor
endfunction
call s:name_colors(rcabralc#palette)
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
call s:hl('Constant',  s:purple, s:none, 'bold')
if s:background == 'dark'
    call s:hl('String', s:yellow, s:none)
else
    call s:hl('String', s:yellow, s:none, 'bold')
endif
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
call s:hl('SpecialComment', s:fg,      s:none, 'bold')
call s:hl('Debug',          s:purple,  s:none)

"        *Underlined     text that stands out, HTML links
call s:hl('Underlined', s:none, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call s:hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call s:hl('Error', s:magenta, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call s:hl('Todo', s:fg, s:none, 'bold')


" Extended highlighting
if s:background == 'dark'
    call s:hl('SpecialKey', s:gray2, s:none)
else
    call s:hl('SpecialKey', s:orange, s:none)
endif
call s:hl('NonText',      s:gray2,   s:none)
call s:hl('StatusLine',   s:fg,      s:gray0, 'bold')
call s:hl('StatusLineNC', s:gray2,   s:gray0)
call s:hl('Visual',       s:none,    s:purplebg)
call s:hl('Directory',    s:purple,  s:none)
call s:hl('ErrorMsg',     s:magenta, s:bg,    'bold')
call s:hl('IncSearch',    s:none,    s:gray1)

if s:options.prominent_search_highlight
    call s:hl('Search', s:none, s:none, 'reverse')
else
    call s:hl('Search', s:none, s:gray1)
endif

call s:hl('MoreMsg',      s:cyan,    s:bg)
call s:hl('ModeMsg',      s:lime,    s:bg)
call s:hl('LineNr',       s:gray2,   s:bg)
call s:hl('Question',     s:cyan,    s:none,     'bold')
call s:hl('VertSplit',    s:gray2,   s:gray0)
call s:hl('Title',        s:magenta, s:none,     'bold')
call s:hl('VisualNOS',    s:bgfg,    s:fg)
call s:hl('WarningMsg',   s:orange,  s:bg)
call s:hl('WildMenu',     s:cyan,    s:bg)
call s:hl('Folded',       s:gray2,   s:bg)
call s:hl('FoldColumn',   s:gray2,   s:bg)
call s:hl('DiffAdd',      s:none,    s:limebg)
call s:hl('DiffChange',   s:none,    s:cyanbg)
call s:hl('DiffDelete',   s:none,    s:magentabg)
call s:hl('DiffText',     s:none,    s:cyanbg,  'underline')
call s:hl('SignColumn',   s:lime,    s:bg)
call s:hl('Conceal',      s:gray1,   s:none)
call s:hl('SpellBad',     s:none,    s:none,     'undercurl', 'NONE', s:magenta)
call s:hl('SpellCap',     s:none,    s:none,     'undercurl', 'NONE', s:cyan)
call s:hl('SpellRare',    s:none,    s:none,     'undercurl', 'NONE', s:white)
call s:hl('SpellLocal',   s:none,    s:none,     'undercurl', 'NONE', s:orange)
call s:hl('Pmenu',        s:gray1,   s:fg)
call s:hl('PmenuSel',     s:orange,  s:gray1,    'bold')
call s:hl('PmenuSbar',    s:none,    s:gray2)
call s:hl('PmenuThumb',   s:none,    s:gray1)
call s:hl('TabLine',      s:bgfg,    s:gray2)
call s:hl('TabLineFill',  s:gray2,   s:gray2)
call s:hl('TabLineSel',   s:fg,      s:gray1,    'bold')
call s:hl('CursorColumn', s:none,    s:gray0)
call s:hl('CursorLine',   s:none,    s:gray0)
call s:hl('CursorLineNr', s:lime,    s:bg)
call s:hl('ColorColumn',  s:none,    s:gray0)
call s:hl('Cursor',       s:bgfg,    s:fg)
hi! link lCursor Cursor
call s:hl('MatchParen',   s:none,    s:none,     'reverse,underline')

" Must be at the end due to a bug in VIM trying to figuring out automagically
" if the background set through Normal highlight group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
exe "set background=" . s:background
