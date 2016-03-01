" vim: fdm=marker
" Name:   rcabralc's Colorscheme for Vim.
" Author: rcabralc <rcabralc@gmail.com>
" URL:    https://github.com/rcabralc/monokai.vim
" Note:   A vibrant, warmer variation of Monokai, with a litte bit more
"         contrast between colors and white.


if !exists('g:rcabralc')
    let g:rcabralc = {}
endif

if !exists("g:rcabralc.transparent_background")
    let g:rcabralc.transparent_background = 0
endif

if !exists("g:rcabralc.use_default_term_colors")
    let g:rcabralc.use_default_term_colors = 0
endif

if !exists("g:rcabralc.prominent_search_highlight")
    let g:rcabralc.prominent_search_highlight = 1
endif

if !exists("g:rcabralc.allow_italics")
    let g:rcabralc.allow_italics = 0
endif

" {{{
function! rcabralc#blend(fg, bg, opacity)
    return s:build_color({
        \ 'r': a:fg.r * a:opacity + a:bg.r * (1 - a:opacity),
        \ 'g': a:fg.g * a:opacity + a:bg.g * (1 - a:opacity),
        \ 'b': a:fg.b * a:opacity + a:bg.b * (1 - a:opacity),
    \ })
endfunction
let s:blend = function('rcabralc#blend')

function! s:rgb_from_hex_color(color)
    return {
        \ 'r': str2nr(a:color[1:2], 16),
        \ 'g': str2nr(a:color[3:4], 16),
        \ 'b': str2nr(a:color[5:], 16),
    \ }
endfunction

function! s:to_hex_color(color)
    let r = float2nr(round(a:color.r))
    let g = float2nr(round(a:color.g))
    let b = float2nr(round(a:color.b))

    let r = r > 255 ? 255 : (r < 0 ? 0 : r)
    let g = g > 255 ? 255 : (g < 0 ? 0 : g)
    let b = b > 255 ? 255 : (b < 0 ? 0 : b)

    return printf('#%02x%02x%02x', r, g, b)
endfunction

function! s:add_gui(color)
    if !exists('a:color.gui')
        let a:color.gui = s:to_hex_color(a:color)
    endif
    return a:color
endfunction

function! s:add_term(color)
    if !exists('a:color.term')
        let a:color.term = s:xterm_index(a:color)
    endif
    return a:color
endfunction

function! s:add_lab(color)
    if exists('a:color.lab')
        return a:color
    endif

    call s:add_xyz(a:color)

    let xn = 0.95047
    let yn = 1.0
    let zn = 1.08883

    let a:color.lab = {
        \ 'l': 116 * s:lab_aux_f(a:color.xyz.y/yn) - 16,
        \ 'a': 500 * (s:lab_aux_f(a:color.xyz.x/xn) - s:lab_aux_f(a:color.xyz.y/yn)),
        \ 'b': 200 * (s:lab_aux_f(a:color.xyz.y/yn) - s:lab_aux_f(a:color.xyz.z/zn)),
    \ }

    return a:color
endfunction

function! s:lab_aux_f(t)
    return a:t > pow(6.0/29.0, 3) ? pow(a:t, 1.0/3.0) : ((1.0/3.0) * pow(29.0/6.0, 2) * a:t + (4.0/29.0))
endfunction

function! s:add_xyz(color)
    if exists('a:color.xyz')
        return a:color
    endif

    let coefficients = [
        \ [ 0.4124, 0.3576, 0.1805 ],
        \ [ 0.2126, 0.7152, 0.0722 ],
        \ [ 0.0193, 0.1192, 0.9505 ],
    \ ]

    let xyz = s:matrix_multiply(coefficients, [
        \ [s:linear_rgb_component(a:color.r / 255.0)],
        \ [s:linear_rgb_component(a:color.g / 255.0)],
        \ [s:linear_rgb_component(a:color.b / 255.0)]
    \ ])

    let a:color.xyz = {
        \ 'x': xyz[0][0],
        \ 'y': xyz[1][0],
        \ 'z': xyz[2][0],
    \ }

    return a:color
endfunction

function! s:linear_rgb_component(c)
    return a:c <= 0.04045 ? a:c/12.92 : pow((a:c + 0.055)/(1 + 0.055), 2.4)
endfunction

function! s:matrix_multiply(a, b)
    let result = []
    let rows = len(a:a)
    let cols = len(a:b[0])
    let components = len(a:b)

    for row in range(rows)
        let line = []

        for col in range(cols)
            let value = 0.0

            for component in range(components)
                let value += (a:a[row][component] * a:b[component][col])
            endfor

            call add(line, value)
        endfor

        call add(result, line)
    endfor

    return result
endfunction

let s:xterm_color_components = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]
let s:xterm_gray_components  = [ 0x08, 0x12, 0x1C, 0x26, 0x30, 0x3A,
                               \ 0x44, 0x4E, 0x58, 0x62, 0x6C, 0x76,
                               \ 0x80, 0x8A, 0x94, 0x9E, 0xA8, 0xB2,
                               \ 0xBC, 0xC6, 0xD0, 0xDA, 0xE4, 0xEE ]

function! s:build_xterm_cube()
    let palette = {}
    let size = len(s:xterm_color_components)

    for ir in range(size)
        for ig in range(size)
            for ib in range(size)
                let index = 16 + size * size * ir + size * ig + ib
                let palette[index] = s:build_color({
                    \ 'r': s:xterm_color_components[ir],
                    \ 'g': s:xterm_color_components[ig],
                    \ 'b': s:xterm_color_components[ib],
                \ }, { 'term': index })
            endfor
        endfor
    endfor

    let index = 16 + 6 * 6 * 6
    for i in range(len(s:xterm_gray_components) - 1)
        let palette[index + i] = s:build_color({
            \ 'r': s:xterm_gray_components[i],
            \ 'g': s:xterm_gray_components[i],
            \ 'b': s:xterm_gray_components[i],
        \ }, { 'term': index + i })
    endfor

    return palette
endfunction

function! s:xterm_index(color)
    let best = { 'dist2': 3 * pow(255, 2) + 1 }

    for index in sort(keys(s:xterm_palette))
        let xterm_color = s:xterm_palette[index]
        let dist2 = s:distance2(xterm_color, a:color)

        if dist2 == 0
            return index
        end

        if dist2 < best.dist2
            let best = { 'index': index, 'dist2': dist2 }
        endif
    endfor

    return best.index
endfunction

function! s:distance2(color1, color2)
    return pow(a:color1.lab.l - a:color2.lab.l, 2) + pow(a:color1.lab.a - a:color2.lab.a, 2) + pow(a:color1.lab.b - a:color2.lab.b, 2)
endfunction

function! s:build_color(color, ...)
    if type(a:color) == type('')
        let color = s:rgb_from_hex_color(a:color)
        let color.gui = a:color
    else
        let color = a:color
    endif

    let color = s:add_lab(s:add_gui(color))

    if a:0 == 1
        let options = a:1
    else
        let options = {}
    endif

    if has_key(options, 'term')
        let color.term = options.term
        let color.term_default = 1

        if exists('s:xterm_palette') && !has_key(s:xterm_palette, color.term)
            let s:xterm_palette[color.term] = color
        endif
    else
        let color = s:add_term(color)
        let color.term_default = 0
    endif

    if has_key(options, 'terms')
        let terms = options.terms
        call add(terms, color.term)

        let color.terms = uniq(sort(terms))
    else
        let color.terms = [color.term]
    endif

    if color.term_default
        for term in color.terms
            if term >= 0 && term <= 15
                exe "let g:terminal_color_" . term . " = '" . color.gui . "'"
            end
        endfor
    endif

    return color
endfunction

let s:xterm_palette = s:build_xterm_cube()

function! g:rcabralc#hl(group, fg, bg, ...)
    let fg_color = a:fg
    let bg_color = a:bg
    let gui_fg = fg_color.gui
    let gui_bg = bg_color.gui
    let term_fg = fg_color.term
    let term_bg = bg_color.term
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

    exe "hi! " . a:group .
        \ " ctermfg=" . term_fg .
        \ " ctermbg=" . term_bg .
        \ " cterm="   . term_mod .
        \ " guifg="   . gui_fg .
        \ " guibg="   . gui_bg .
        \ " gui="     . gui_mod .
        \ gui_sp
endfunction
" }}}

" Note: The "blue" color is not used in this colorscheme because there's no
" equivalent in the original Monokai, and it's not needed anyway.  It is
" defined here as a matter of standardization; since it's recommended to change
" the terminal colorscheme for better color fidelity, it's worth to specify a
" blueish color to be used as a replacement for the 4th terminal color.
let s:def_term = g:rcabralc.use_default_term_colors

let s:none      = { 'gui': 'NONE', 'term': 'NONE', }
let s:black     = s:build_color('#25231d', s:def_term ? { 'term': 0  } : {})
let s:darkgray  = s:build_color('#36332a', s:def_term ? { 'term': 8  } : {})
let s:lightgray = s:build_color('#696352', s:def_term ? { 'term': 7  } : {})
let s:white     = s:build_color('#fff2c8', s:def_term ? { 'term': 15 } : {})
let s:lime      = s:build_color('#9fd304', s:def_term ? { 'term': 10 } : {})
let s:yellow    = s:build_color('#ebcc66', s:def_term ? { 'term': 11 } : {})
let s:blue      = s:build_color('#6f82d9', s:def_term ? { 'term': 12 } : {})
let s:purple    = s:build_color('#a773e2', s:def_term ? { 'term': 13 } : {})
let s:cyan      = s:build_color('#60bda8', s:def_term ? { 'term': 14 } : {})
let s:orange    = s:build_color('#f66d04', s:def_term ? { 'term': 3  } : {})
let s:magenta   = s:build_color('#f60461', s:def_term ? { 'term': 9  } : {})

let s:darklime    = s:blend(s:lime,    s:black, 0.0625)
let s:darkpurple  = s:blend(s:purple,  s:black, 0.0625)
let s:darkmagenta = s:blend(s:magenta, s:black, 0.0625)
let s:darkergray  = s:blend(s:white,   s:black, 0.04)

if g:rcabralc.transparent_background == 1
    let s:blackbg = { 'gui': 'NONE', 'term': 'NONE' }
else
    let s:blackbg = s:black
endif

hi clear
if exists("syntax on")
    syntax reset
endif

let g:colors_name = "rcabralc"

" For relevant help:
" :help highlight-groups
" :help cterm-colors
" :help group-name

" For testing:
" :source $VIMRUNTIME/syntax/hitest.vim

call g:rcabralc#hl('Normal', s:white, s:blackbg)

"        *Comment        any comment
if g:rcabralc.allow_italics
call g:rcabralc#hl('Comment', s:lightgray, s:none, 'italic')
else
call g:rcabralc#hl('Comment', s:lightgray, s:none)
endif

"        *Constant       any constant
"         String         a string constant: "this is a string"
"         Character      a character constant: 'c', '\n'
"         Number         a number constant: 234, 0xff
"         Boolean        a boolean constant: TRUE, false
"         Float          a floating point constant: 2.3e10
call g:rcabralc#hl('Constant',  s:purple, s:none, 'bold')
call g:rcabralc#hl('Character', s:purple, s:none)
call g:rcabralc#hl('String',    s:yellow, s:none)
call g:rcabralc#hl('Number',    s:purple, s:none)
call g:rcabralc#hl('Boolean',   s:orange, s:none)

"        *Identifier     any variable name
"         Function       function name (also: methods for classes)
call g:rcabralc#hl('Identifier', s:lime, s:none)

"        *Statement      any statement
"         Conditional    if, then, else, endif, switch, etc.
"         Repeat         for, do, while, etc.
"         Label          case, default, etc.
"         Operator       "sizeof", "+", "*", etc.
"         Keyword        any other keyword
"         Exception      try, catch, throw
call g:rcabralc#hl('Statement', s:magenta, s:none, 'bold')
call g:rcabralc#hl('Operator',  s:magenta, s:none)
call g:rcabralc#hl('Exception', s:lime,    s:none, 'bold')

"        *PreProc        generic Preprocessor
"         Include        preprocessor #include
"         Define         preprocessor #define
"         Macro          same as Define
"         PreCondit      preprocessor #if, #else, #endif, etc.
call g:rcabralc#hl('PreProc', s:magenta, s:none, 'bold')

"        *Type           int, long, char, etc.
"         StorageClass   static, register, volatile, etc.
"         Structure      struct, union, enum, etc.
"         Typedef        A typedef
call g:rcabralc#hl('Type',         s:cyan,    s:none, 'bold')
call g:rcabralc#hl('StorageClass', s:magenta, s:none, 'bold')

"        *Special        any special symbol
"         SpecialChar    special character in a constant
"         Tag            you can use CTRL-] on this
"         Delimiter      character that needs attention
"         SpecialComment special things inside a comment
"         Debug          debugging statements
call g:rcabralc#hl('Special',        s:orange,  s:none)
call g:rcabralc#hl('Tag',            s:cyan,    s:none, 'bold')
call g:rcabralc#hl('SpecialComment', s:white,   s:none, 'bold')
call g:rcabralc#hl('Debug',          s:purple,  s:none)

"        *Underlined     text that stands out, HTML links
call g:rcabralc#hl('Underlined', s:none, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call g:rcabralc#hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call g:rcabralc#hl('Error', s:magenta, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call g:rcabralc#hl('Todo', s:white, s:none, 'bold')


" Extended highlighting
call g:rcabralc#hl('SpecialKey',   s:orange,    s:none)
call g:rcabralc#hl('NonText',      s:lightgray, s:none)
call g:rcabralc#hl('StatusLine',   s:white,     s:darkergray,  'bold')
call g:rcabralc#hl('StatusLineNC', s:lightgray, s:darkergray)
call g:rcabralc#hl('Visual',       s:none,      s:darkgray)
call g:rcabralc#hl('Directory',    s:purple,    s:none)
call g:rcabralc#hl('ErrorMsg',     s:magenta,   s:blackbg,     'bold')
call g:rcabralc#hl('IncSearch',    s:none,      s:none,        'underline')

if g:rcabralc.prominent_search_highlight
call g:rcabralc#hl('Search',       s:none,      s:none,        'reverse')
else
call g:rcabralc#hl('Search',       s:none,      s:darkgray,    'underline')
endif

call g:rcabralc#hl('MoreMsg',      s:cyan,      s:blackbg)
call g:rcabralc#hl('ModeMsg',      s:lime,      s:blackbg)
call g:rcabralc#hl('LineNr',       s:lightgray, s:blackbg)
call g:rcabralc#hl('Question',     s:cyan,      s:none,        'bold')
call g:rcabralc#hl('VertSplit',    s:lightgray, s:darkergray)
call g:rcabralc#hl('Title',        s:white,     s:none,        'bold')
call g:rcabralc#hl('VisualNOS',    s:black,     s:white)
call g:rcabralc#hl('WarningMsg',   s:orange,    s:blackbg)
call g:rcabralc#hl('WildMenu',     s:cyan,      s:blackbg)
call g:rcabralc#hl('Folded',       s:lightgray, s:blackbg)
call g:rcabralc#hl('FoldColumn',   s:lightgray, s:blackbg)
call g:rcabralc#hl('DiffAdd',      s:none,      s:darklime)
call g:rcabralc#hl('DiffChange',   s:none,      s:darkpurple)
call g:rcabralc#hl('DiffDelete',   s:none,      s:darkmagenta)
call g:rcabralc#hl('DiffText',     s:none,      s:darkpurple,  'underline')
call g:rcabralc#hl('SignColumn',   s:lime,      s:blackbg)
call g:rcabralc#hl('Conceal',      s:darkgray,  s:none)
call g:rcabralc#hl('SpellBad',     s:none,      s:none,        'undercurl', 'NONE', s:magenta)
call g:rcabralc#hl('SpellCap',     s:none,      s:none,        'undercurl', 'NONE', s:cyan)
call g:rcabralc#hl('SpellRare',    s:none,      s:none,        'undercurl', 'NONE', s:white)
call g:rcabralc#hl('SpellLocal',   s:none,      s:none,        'undercurl', 'NONE', s:orange)
call g:rcabralc#hl('Pmenu',        s:darkgray,  s:white)
call g:rcabralc#hl('PmenuSel',     s:orange,    s:darkgray,    'bold')
call g:rcabralc#hl('PmenuSbar',    s:none,      s:lightgray)
call g:rcabralc#hl('PmenuThumb',   s:none,      s:darkgray)
call g:rcabralc#hl('TabLine',      s:black,     s:lightgray)
call g:rcabralc#hl('TabLineFill',  s:lightgray, s:lightgray)
call g:rcabralc#hl('TabLineSel',   s:white,     s:darkgray,    'bold')
call g:rcabralc#hl('CursorColumn', s:none,      s:darkergray)
call g:rcabralc#hl('CursorLine',   s:none,      s:darkergray)
call g:rcabralc#hl('CursorLineNr', s:lime,      s:blackbg)
call g:rcabralc#hl('ColorColumn',  s:none,      s:darkergray)
call g:rcabralc#hl('Cursor',       s:black,     s:white)
hi! link lCursor Cursor
call g:rcabralc#hl('MatchParen',   s:none,      s:none,        'reverse,underline')

" Must be at the end due to a bug in VIM trying to figuring out automagically
" if the background set through Normal highlight group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark

" Additions for vim-gitgutter
call g:rcabralc#hl('GitGutterAdd',          s:lime,    s:none)
call g:rcabralc#hl('GitGutterChange',       s:purple,  s:none)
call g:rcabralc#hl('GitGutterDelete',       s:magenta, s:none)
call g:rcabralc#hl('GitGutterChangeDelete', s:magenta, s:none)

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
let g:rcabralc#palette.darkpurple  = s:darkpurple
let g:rcabralc#palette.darkmagenta = s:darkmagenta
let g:rcabralc#palette.darkergray  = s:darkergray
let g:rcabralc#palette.blackbg     = s:blackbg
