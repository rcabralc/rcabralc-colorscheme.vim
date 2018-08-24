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

function! s:complete(color, ...)
    if a:0 > 0
        let factor = a:1
    else
        let factor = 1
    endif

    if has_key(a:color, 'actual')
        return { 'actual': a:color.actual, 'dark': a:color.actual, 'light': a:color.actual }
    endif

    let dark = a:color.dark

    if !has_key(a:color, 'light')
        let target_contrast = factor*s:black.actual.contrast_to(dark)
        " if target_contrast > 3.5
        "     let target_contrast = 3.5
        " endif
        let min_v = 0.0
        let max_v = 100.0
        let v = (min_v + max_v) / 2.0
        let light = rcabralc#hsv(dark.hsv.h, dark.hsv.s, v)
        let current_contrast = s:white.actual.contrast_to(light)
        while abs(current_contrast - target_contrast) >= 0.03125 && (max_v - min_v) > 1
            if target_contrast > current_contrast
                let max_v = v
            else
                let min_v = v
            endif
            let v = (min_v + max_v) / 2.0
            let light = rcabralc#hsv(dark.hsv.h, dark.hsv.s, v)
            let current_contrast = s:white.actual.contrast_to(light)
        endwhile

        if dark.term == 7
            let light = light.term_aware(7)
        elseif dark.term == 8
            let light = light.term_aware(8)
        elseif dark.term <= 15
            let light = light.term_aware(dark.term)
        else
            let light = light.term_aware()
        endif
    else
        let light = a:color.light
    endif

    return { 'actual': (&bg ==# 'dark') ? dark : light, 'dark': dark, 'light': light }
endfunction


" Palette definition
" ------------------

let s:none = { 'gui': 'NONE', 'term': 'NONE' }

let s:black = s:complete({
    \ 'dark':  rcabralc#hsv(34, 34, 17).term_aware(0),
    \ 'light': rcabralc#hsv(34, 34, 17).term_aware(15)
\ })
let s:white = s:complete({
    \ 'dark':  rcabralc#hsv(34, 34, 83).term_aware(15),
    \ 'light': rcabralc#hsv(34, 34, 83).term_aware(0)
\ })

let s:fg = s:complete({
    \ 'dark': s:white.actual.term_aware(15),
    \ 'light': s:black.actual.term_aware(15)
\ })
let s:opaquebg = (&bg ==# 'dark') ? s:black : s:white

let s:gray0 = s:complete({ 'dark': s:white.actual.blend(s:black.actual, 0.05).term_aware() })
let s:gray1 = s:complete({ 'dark': s:white.actual.blend(s:black.actual, 0.10).term_aware() })
let s:gray2 = s:complete({ 'dark': s:white.actual.blend(s:black.actual, 0.20).term_aware() })
let s:gray3 = s:complete({ 'dark': s:white.actual.blend(s:black.actual, 0.30).term_aware(8) })
let s:gray4 = s:complete({ 'dark': s:white.actual.blend(s:black.actual, 0.45).term_aware(7) })

if !has('gui_running') && s:options.transparent_background == 1
    let s:bg = s:complete({ 'actual': s:none })
else
    let s:bg = s:opaquebg
endif

let s:red0    = s:complete({ 'dark': rcabralc#hsv(350, 80, 90).term_aware(9) })
let s:green0  = s:complete({ 'dark': rcabralc#hsv( 60, 65, 90).term_aware(10) }, 0.5)
let s:orange0 = s:complete({ 'dark': rcabralc#hsv( 15, 85, 95).term_aware(3) })
let s:yellow0 = s:complete({ 'dark': rcabralc#hsv( 15, 60, 95).term_aware(11) }, 0.75)
let s:purple0 = s:complete({ 'dark': rcabralc#hsv(320, 55, 70).term_aware(12) })
let s:pink0   = s:complete({ 'dark': rcabralc#hsv(340, 60, 85).term_aware(13) })
let s:cyan0   = s:complete({ 'dark': rcabralc#hsv(210, 30, 80).term_aware(14) })

let s:red1 = s:complete({ 'dark': s:red0.dark.blend(s:black.actual, 0.8).term_aware(1) })
let s:green1 = s:complete({ 'dark': s:green0.dark.blend(s:black.actual, 0.8).term_aware(2) }, 0.5)
let s:orange1 = s:complete({ 'dark': s:orange0.dark.blend(s:black.actual, 0.8).term_aware() })
let s:yellow1 = s:complete({ 'dark': s:yellow0.dark.blend(s:black.actual, 0.8).term_aware() }, 0.75)
let s:purple1 = s:complete({ 'dark': s:purple0.dark.blend(s:black.actual, 0.8).term_aware(4) })
let s:pink1 = s:complete({ 'dark': s:pink0.dark.blend(s:black.actual, 0.8).term_aware(5) })
let s:cyan1 = s:complete({ 'dark': s:cyan0.dark.blend(s:black.actual, 0.8).term_aware(6) })

let s:red2 = s:complete({ 'dark': s:red0.dark.blend(s:black.actual, 0.5).term_aware() })
let s:green2 = s:complete({ 'dark': s:green0.dark.blend(s:black.actual, 0.3).term_aware() })
let s:orange2 = s:complete({ 'dark': s:orange0.dark.blend(s:black.actual, 0.4).term_aware() })
let s:yellow2 = s:complete({ 'dark': s:yellow0.dark.blend(s:black.actual, 0.4).term_aware() })
let s:purple2 = s:complete({ 'dark': s:purple0.dark.blend(s:black.actual, 0.4).term_aware() })
let s:pink2 = s:complete({ 'dark': s:pink0.dark.blend(s:black.actual, 0.3).term_aware() })
let s:cyan2 = s:complete({ 'dark': s:cyan0.dark.blend(s:black.actual, 0.3).term_aware() })

let s:red3 = s:complete({ 'dark': s:red0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:green3 = s:complete({ 'dark': s:green0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:orange3 = s:complete({ 'dark': s:orange0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:yellow3 = s:complete({ 'dark': s:yellow0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:purple3 = s:complete({ 'dark': s:purple0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:pink3 = s:complete({ 'dark': s:pink0.dark.blend(s:black.actual, 0.2).term_aware() })
let s:cyan3 = s:complete({ 'dark': s:cyan0.dark.blend(s:black.actual, 0.2).term_aware() })

" Export the palette
let g:rcabralc#palette = {}
let g:rcabralc#palette.none = s:none
let g:rcabralc#palette.bg = s:opaquebg
let g:rcabralc#palette.fg = s:fg
let g:rcabralc#palette.black = s:black
let g:rcabralc#palette.gray0 = s:gray0
let g:rcabralc#palette.gray1 = s:gray1
let g:rcabralc#palette.gray2 = s:gray2
let g:rcabralc#palette.gray3 = s:gray3
let g:rcabralc#palette.gray4 = s:gray4
let g:rcabralc#palette.white = s:white
let g:rcabralc#palette.red0 = s:red0
let g:rcabralc#palette.green0 = s:green0
let g:rcabralc#palette.orange0 = s:orange0
let g:rcabralc#palette.yellow0 = s:yellow0
let g:rcabralc#palette.purple0 = s:purple0
let g:rcabralc#palette.pink0 = s:pink0
let g:rcabralc#palette.cyan0 = s:cyan0
let g:rcabralc#palette.red1 = s:red1
let g:rcabralc#palette.green1 = s:green1
let g:rcabralc#palette.orange1 = s:orange1
let g:rcabralc#palette.yellow1 = s:yellow1
let g:rcabralc#palette.pink1 = s:pink1
let g:rcabralc#palette.purple1 = s:purple1
let g:rcabralc#palette.cyan1 = s:cyan1
let g:rcabralc#palette.red2 = s:red2
let g:rcabralc#palette.green2 = s:green2
let g:rcabralc#palette.orange2 = s:orange2
let g:rcabralc#palette.yellow2 = s:yellow2
let g:rcabralc#palette.purple2 = s:purple2
let g:rcabralc#palette.pink2 = s:pink2
let g:rcabralc#palette.cyan2 = s:cyan2
let g:rcabralc#palette.red3 = s:red3
let g:rcabralc#palette.green3 = s:green3
let g:rcabralc#palette.orange3 = s:orange3
let g:rcabralc#palette.yellow3 = s:yellow3
let g:rcabralc#palette.purple3 = s:purple3
let g:rcabralc#palette.pink3 = s:pink3
let g:rcabralc#palette.cyan3 = s:cyan3

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
" Save background value: workaround for Vim bug, restored (enforced) at the
" end.
let s:is_dark = (&bg ==# 'dark')

call s:hl('Normal', s:fg.actual, s:bg.actual)

"        *Comment        any comment
if s:options.allow_italics
    call s:hl('Comment', s:gray4.actual, s:none, 'italic')
else
    call s:hl('Comment', s:gray4.actual, s:none)
endif

"        *Constant       any constant
"         String         a string constant: "this is a string"
"         Character      a character constant: 'c', '\n'
"         Number         a number constant: 234, 0xff
"         Boolean        a boolean constant: TRUE, false
"         Float          a floating point constant: 2.3e10
call s:hl('Constant', s:pink0.actual, s:none)
call s:hl('String', s:yellow0.actual, s:none)
call s:hl('Number', s:purple0.actual, s:none)
call s:hl('Boolean', s:purple0.actual, s:none)

"        *Identifier     any variable name
"         Function       function name (also: methods for classes)
call s:hl('Identifier', s:pink0.actual, s:none)
call s:hl('Function', s:red0.actual, s:none)

"        *Statement      any statement
"         Conditional    if, then, else, endif, switch, etc.
"         Repeat         for, do, while, etc.
"         Label          case, default, etc.
"         Operator       "sizeof", "+", "*", etc.
"         Keyword        any other keyword
"         Exception      try, catch, throw
call s:hl('Statement', s:pink0.actual, s:none, 'bold')
call s:hl('Operator', s:cyan0.actual, s:none)
call s:hl('Exception', s:red0.actual, s:none, 'bold')

"        *PreProc        generic Preprocessor
"         Include        preprocessor #include
"         Define         preprocessor #define
"         Macro          same as Define
"         PreCondit      preprocessor #if, #else, #endif, etc.
call s:hl('PreProc', s:purple0.actual, s:none, 'bold')

"        *Type           int, long, char, etc.
"         StorageClass   static, register, volatile, etc.
"         Structure      struct, union, enum, etc.
"         Typedef        A typedef
call s:hl('Type', s:green0.actual, s:none)
call s:hl('StorageClass', s:red0.actual, s:none, 'bold')

"        *Special        any special symbol
"         SpecialChar    special character in a constant
"         Tag            you can use CTRL-] on this
"         Delimiter      character that needs attention
"         SpecialComment special things inside a comment
"         Debug          debugging statements
call s:hl('Special', s:orange0.actual, s:none)
call s:hl('Tag', s:cyan0.actual, s:none)
call s:hl('Delimiter', s:orange0.actual, s:none, 'bold')
call s:hl('SpecialComment', s:cyan0.actual, s:none, 'bold')
call s:hl('Debug', s:cyan0.actual, s:none)

"        *Underlined     text that stands out, HTML links
call s:hl('Underlined', s:cyan0.actual, s:none, 'underline')

"        *Ignore         left blank, hidden  |hl-Ignore|
call s:hl('Ignore', s:none, s:none)

"        *Error          any erroneous construct
call s:hl('Error', s:red0.actual, s:none, 'bold,reverse')

"        *Todo           anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
call s:hl('Todo', s:orange0.actual, s:none, 'bold')


" Extended highlighting
call s:hl('SpecialKey', s:purple0.actual, s:none)
call s:hl('NonText', s:gray2.actual, s:none)
call s:hl('StatusLine', s:fg.actual, s:gray0.actual, 'bold')
call s:hl('StatusLineNC', s:gray3.actual, s:gray0.actual)
call s:hl('Visual', s:none, s:pink3.actual)
call s:hl('Directory', s:pink0.actual, s:none)
call s:hl('ErrorMsg', s:red0.actual, s:bg.actual, 'bold')
call s:hl('IncSearch', s:opaquebg.actual, s:yellow0.actual)
call s:hl('Search', s:opaquebg.actual, s:yellow0.actual)
call s:hl('QuickFixLine', s:none, s:orange3.actual)
call s:hl('MoreMsg', s:green0.actual, s:bg.actual)
call s:hl('ModeMsg', s:orange0.actual, s:bg.actual)
call s:hl('LineNr', s:gray3.actual, s:bg.actual)
call s:hl('Question', s:green0.actual, s:none, 'bold')
call s:hl('VertSplit', s:gray2.actual, s:gray0.actual)
call s:hl('Title', s:red0.actual, s:none, 'bold')
call s:hl('VisualNOS', s:opaquebg.actual, s:fg.actual)
call s:hl('WarningMsg', s:orange0.actual, s:bg.actual)
call s:hl('WildMenu', s:green0.actual, s:bg.actual)
call s:hl('Folded', s:gray3.actual, s:bg.actual)
call s:hl('FoldColumn', s:gray3.actual, s:bg.actual)
call s:hl('DiffAdd', s:none, s:green3.actual)
call s:hl('DiffChange', s:none, s:yellow3.actual)
call s:hl('DiffDelete', s:none, s:red3.actual)
call s:hl('DiffText', s:none, s:cyan3.actual, 'underline')
call s:hl('SignColumn', s:orange0.actual, s:bg.actual)
call s:hl('Conceal', s:gray1.actual, s:none)
if has('gui_running')
    call s:hl('SpellBad', s:none, s:red3.actual, 'undercurl', 'NONE', s:red0.actual)
    call s:hl('SpellCap', s:none, s:gray3.actual, 'undercurl', 'NONE', s:yellow0.actual)
    call s:hl('SpellRare', s:none, s:gray3.actual, 'undercurl', 'NONE', s:fg.actual)
    call s:hl('SpellLocal', s:none, s:gray3.actual, 'undercurl', 'NONE', s:orange0.actual)
else
    call s:hl('SpellBad', s:none, s:red3.actual)
    call s:hl('SpellCap', s:none, s:yellow3.actual)
    call s:hl('SpellRare', s:none, s:none, 'underline')
    call s:hl('SpellLocal', s:none, s:orange3.actual)
endif
call s:hl('Pmenu', s:fg.actual, s:gray2.actual)
call s:hl('PmenuSel', s:opaquebg.actual, s:pink0.actual, 'bold')
call s:hl('PmenuSbar', s:none, s:gray2.actual)
call s:hl('PmenuThumb', s:none, s:gray3.actual)
call s:hl('TabLine', s:gray4.actual, s:gray2.actual)
call s:hl('TabLineFill', s:none, s:gray0.actual)
call s:hl('TabLineSel', s:fg.actual, s:gray3.actual, 'bold')
call s:hl('CursorColumn', s:none, s:gray1.actual)
call s:hl('CursorLine', s:none, s:gray1.actual)
call s:hl('CursorLineNr', s:orange0.actual, s:bg.actual)
call s:hl('ColorColumn', s:none, s:gray0.actual)
call s:hl('Cursor', s:none, s:none, 'reverse')
hi! link lCursor Cursor
call s:hl('MatchParen', s:cyan0.actual, s:none, 'bold,underline')

" Restore background saved.  Must be at the end due to a bug in VIM trying to
" figuring out automagically if the background set through Normal highlight
" group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
exe "set background=" . (s:is_dark ? 'dark' : 'light')

" Define terminal colors
function! s:define_term_colors(palette)
    for color in values(a:palette)
        if has_key(color, 'actual') && color.actual.term >= 0 && color.actual.term <= 15
            exe 'let g:terminal_color_' . color.actual.term . ' = "' . color.actual.gui . '"'
        end
    endfor
endfunction
call s:define_term_colors(g:rcabralc#palette)
delfunction s:define_term_colors

function! rcabralc#print_palette(...)
    let color_tone = a:0 > 0 ? a:1 : 'actual'
    let named_colors = map(filter(copy(g:rcabralc#palette), "v:key != 'none'"), "v:val.".color_tone)
    let sorted = sort(items(copy(named_colors)), function('s:sort_by_term_index'))
    let lines = []
    for [name, color] in sorted
        call add(lines, printf(
            \ '  { "name": %12s, "term": %3d, "hex": "%s", "rgb": "rgb(%.0f,%.0f,%.0f)" }',
            \ '"'.name.'"',
            \ color.term,
            \ color.gui,
            \ round(color.r),
            \ round(color.g),
            \ round(color.b)
        \ ))
    endfor
    call append(line('.') - 1, extend(['[', ']'], split(join(lines, ",\n"), "\n"), 1))
endfunction

function! s:sort_by_term_index(colorpair1, colorpair2)
    let color1 = a:colorpair1[1]
    let color2 = a:colorpair2[1]

    return color1.term - color2.term
endfunction
