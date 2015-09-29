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
"
" The dark colors are blends of the respective normal colors with alpha = 48
" (0-255) over the 'black' color.
let s:palette = {
    \ 'NONE':        { 'gui': 'NONE',    'term': 'NONE', 'term_default': 'NONE' },
    \ 'black':       { 'gui': '#24231d', 'term': 235,    'term_default': 0      },
    \ 'darkgray':    { 'gui': '#36342b', 'term': 236,    'term_default': 8      },
    \ 'lightgray':   { 'gui': '#6e6a57', 'term': 241,    'term_default': 7      },
    \ 'white':       { 'gui': '#fff6cd', 'term': 230,    'term_default': 15     },
    \ 'lime':        { 'gui': '#9fd304', 'term': 148,    'term_default': 2      },
    \ 'yellow':      { 'gui': '#ebcc66', 'term': 185,    'term_default': 11     },
    \ 'blue':        { 'gui': '#6f82d9', 'term': 68,     'term_default': 4      },
    \ 'purple':      { 'gui': '#a773e2', 'term': 140,    'term_default': 5      },
    \ 'cyan':        { 'gui': '#60bda8', 'term': 73,     'term_default': 6      },
    \ 'orange':      { 'gui': '#f66d04', 'term': 202,    'term_default': 3      },
    \ 'magenta':     { 'gui': '#ff0569', 'term': 197,    'term_default': 1      },
    \ 'darklime':    { 'gui': '#3b4318' },
    \ 'darkyellow':  { 'gui': '#49422b' },
    \ 'darkpurple':  { 'gui': '#3c3142' },
    \ 'darkcyan':    { 'gui': '#2f3f37' },
    \ 'darkmagenta': { 'gui': '#4d1c2b' }
\ }

if !exists("g:rcabralc_colorscheme#transparent_background")
    let g:rcabralc_colorscheme#transparent_background = 0
endif

if !exists("g:rcabralc_colorscheme#use_default_term_colors")
    let g:rcabralc_colorscheme#use_default_term_colors = 0
endif

if g:rcabralc_colorscheme#transparent_background == 1
    let s:palette['blackbg'] = { 'gui': 'NONE', 'term': 'NONE', 'term_default': 'NONE' }
else
    let s:palette['blackbg'] = {
        \ 'gui': s:palette['black']['gui'],
        \ 'term': s:palette['black']['term'],
        \ 'term_default': s:palette['black']['term_default']
    \ }
endif

if g:rcabralc_colorscheme#use_default_term_colors == 1
    let s:term_key = 'term_default'
else
    let s:term_key = 'term'
endif

function! s:hl(group, fg, bg, ...)
    let fg_color = s:palette[a:fg]
    let bg_color = s:palette[a:bg]
    let gui_fg = fg_color['gui']
    let gui_bg = bg_color['gui']
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
            let gui_sp = ' guisp=' . s:palette[a:3]['gui']
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

function! s:hl_gui(group, fg, bg, ...)
    let gui_fg = s:palette[a:fg]['gui']
    let gui_bg = s:palette[a:bg]['gui']
    let gui_sp = ''

    if a:0 > 0
        let gui_mod = a:1

        if a:0 > 2
            let gui_sp = ' guisp=' . s:palette[a:3]['gui']
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

call s:hl('Normal',         'white',     'blackbg')
call s:hl('Comment',        'lightgray', 'NONE')
"         *Comment        any comment

call s:hl('Constant',       'purple',    'NONE', 'bold')
"         *Constant       any constant
"          String         a string constant: "this is a string"
"          Character      a character constant: 'c', '\n'
"          Number         a number constant: 234, 0xff
"          Boolean        a boolean constant: TRUE, false
"          Float          a floating point constant: 2.3e10
call s:hl('String',         'yellow',    'NONE')
call s:hl('Number',         'blue',      'NONE', 'bold')
call s:hl('Boolean',        'blue',      'NONE')

call s:hl('Identifier',     'lime',      'NONE')
"         *Identifier     any variable name
"          Function       function name (also: methods for classes)

call s:hl('Statement',      'magenta',   'NONE', 'bold')
"         *Statement      any statement
"          Conditional    if, then, else, endif, switch, etc.
"          Repeat         for, do, while, etc.
"          Label          case, default, etc.
"          Operator       "sizeof", "+", "*", etc.
"          Keyword        any other keyword
"          Exception      try, catch, throw
call s:hl('Operator',       'magenta',   'NONE')
call s:hl('Exception',      'lime',      'NONE', 'bold')

call s:hl('PreProc',        'magenta',   'NONE', 'bold')
"         *PreProc        generic Preprocessor
"          Include        preprocessor #include
"          Define         preprocessor #define
"          Macro          same as Define
"          PreCondit      preprocessor #if, #else, #endif, etc.

call s:hl('Type',           'cyan',      'NONE', 'bold')
"         *Type           int, long, char, etc.
"          StorageClass   static, register, volatile, etc.
"          Structure      struct, union, enum, etc.
"          Typedef        A typedef
call s:hl('StorageClass',   'magenta',   'NONE', 'bold')

call s:hl('Special',        'orange',    'NONE')
"         *Special        any special symbol
"          SpecialChar    special character in a constant
"          Tag            you can use CTRL-] on this
"          Delimiter      character that needs attention
"          SpecialComment special things inside a comment
"          Debug          debugging statements
call s:hl('Tag',            'magenta',   'NONE', 'bold')
call s:hl('SpecialComment', 'white',     'NONE', 'bold')

call s:hl('Underlined',     'NONE',      'NONE', 'underline')
"         *Underlined     text that stands out, HTML links

call s:hl('Ignore',         'NONE',      'NONE')
"         *Ignore         left blank, hidden |hl-Ignore|

call s:hl('Error',          'magenta',   'NONE', 'bold,reverse')
"         *Error          any erroneous construct

call s:hl('Todo',           'white',     'NONE', 'bold')
"         *Todo           anything that needs extra attention; mostly the
"                         keywords TODO FIXME and XXX


" Extended highlighting
call s:hl('SpecialKey',   'orange',    'NONE')
call s:hl('NonText',      'darkgray',  'NONE')
call s:hl('StatusLine',   'white',     'darkgray',  'bold')
call s:hl('StatusLineNC', 'black',     'lightgray')
call s:hl('Visual',       'NONE',      'darkgray')
call s:hl('Directory',    'purple',    'NONE')
call s:hl('ErrorMsg',     'white',     'magenta',   'bold')
call s:hl('IncSearch',    'black',     'yellow')
call s:hl('Search',       'NONE',      'darkgray',  'underline')
call s:hl('MoreMsg',      'black',     'cyan')
call s:hl('ModeMsg',      'lime',      'blackbg')
call s:hl('LineNr',       'lightgray', 'blackbg')
call s:hl('Question',     'cyan',      'NONE',      'bold')
call s:hl('VertSplit',    'lightgray', 'darkgray')
call s:hl('Title',        'white',     'NONE',      'bold')
call s:hl('VisualNOS',    'black',     'white')
call s:hl('WarningMsg',   'black',     'orange')
call s:hl('WildMenu',     'cyan',      'blackbg')
call s:hl('Folded',       'lightgray', 'blackbg')
call s:hl('FoldColumn',   'lightgray', 'blackbg')
call s:hl('DiffAdd',      'lime',      'NONE',      'bold')
call s:hl('DiffChange',   'purple',    'NONE',      'bold')
call s:hl('DiffDelete',   'magenta',   'NONE',      'bold')
call s:hl('DiffText',     'yellow',    'NONE',      'bold')
call s:hl('SignColumn',   'lime',      'blackbg')
call s:hl('Conceal',      'darkgray',  'NONE')
call s:hl('SpellBad',     'NONE',      'NONE',      'undercurl', 'NONE', 'magenta')
call s:hl('SpellCap',     'NONE',      'NONE',      'undercurl', 'NONE', 'cyan')
call s:hl('SpellRare',    'NONE',      'NONE',      'undercurl', 'NONE', 'white')
call s:hl('SpellLocal',   'NONE',      'NONE',      'undercurl', 'NONE', 'orange')
call s:hl('Pmenu',        'darkgray',  'white')
call s:hl('PmenuSel',     'orange',    'darkgray',  'bold')
call s:hl('PmenuSbar',    'NONE',      'lightgray')
call s:hl('PmenuThumb',   'NONE',      'darkgray')
call s:hl('TabLine',      'black',     'lightgray')
call s:hl('TabLineFill',  'lightgray', 'lightgray')
call s:hl('TabLineSel',   'white',     'darkgray',  'bold')
call s:hl('CursorColumn', 'NONE',      'darkgray')
call s:hl('CursorLine',   'NONE',      'darkgray')
call s:hl('CursorLineNr', 'lime',      'blackbg')
call s:hl('ColorColumn',  'NONE',      'darkgray')
call s:hl('Cursor',       'black',     'white')
hi! link lCursor Cursor
call s:hl('MatchParen',   'NONE',      'NONE',      'reverse,underline')

call s:hl_gui('DiffAdd',    'NONE',        'darklime')
call s:hl_gui('DiffChange', 'NONE',        'darkpurple')
call s:hl_gui('DiffDelete', 'darkmagenta', 'darkmagenta')
call s:hl_gui('DiffText',   'white',       'darkyellow', 'bold')

" Must be at the end due to a bug in VIM trying to figuring out automagically
" if the background set through Normal highlight group is dark or light.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark

" Additions for vim-gitgutter
call s:hl('GitGutterAdd',          'lime',    'NONE')
call s:hl('GitGutterChange',       'purple',  'NONE')
call s:hl('GitGutterDelete',       'magenta', 'NONE')
call s:hl('GitGutterChangeDelete', 'magenta', 'NONE')
