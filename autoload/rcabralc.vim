function! rcabralc#hl(group, fg, bg, ...)
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

function! rcabralc#build_color(color, ...)
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

    if has_key(options, 'name')
        let color.name = options.name
    endif

    if color.term_default
        if color.term >= 0 && color.term <= 15
            exe "let g:terminal_color_" . color.term . " = '" . color.gui . "'"
        end
    endif

    return color
endfunction
let s:build_color = function('rcabralc#build_color')

function! rcabralc#blend(fg, bg, opacity, ...)
    let options = a:0 == 1 ? a:1 : {}

    return s:build_color({
        \ 'r': a:fg.r * a:opacity + a:bg.r * (1 - a:opacity),
        \ 'g': a:fg.g * a:opacity + a:bg.g * (1 - a:opacity),
        \ 'b': a:fg.b * a:opacity + a:bg.b * (1 - a:opacity),
    \ }, options)
endfunction

function! rcabralc#print_colors(palette)
    let sorted = sort(sort(values(filter(a:palette, "v:key != 'none'")), 's:sort_by_term_index'), 's:sort_by_term_default')
    for color in sorted
        echo color.term . ' ' . color.gui
    endfor
endfunction

function! s:sort_by_lab_light(color1, color2)
    return a:color1.lab.l - a:color2.lab.l
endfunction

function! s:sort_by_term_default(color1, color2)
    return a:color2.term_default - a:color1.term_default
endfunction

function! s:sort_by_term_index(color1, color2)
    return a:color1.term - a:color2.term
endfunction

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

function! s:xterm_index(color)
    let best = { 'dist2': 3 * pow(255, 2) + 1 }

    for index in sort(keys(s:xterm_palette))
        let xterm_color = s:xterm_palette[index]
        let dist2 = s:lab_distance2(xterm_color, a:color)
        " let dist2 = s:rgb_distance2(xterm_color, a:color)

        if dist2 == 0
            return index
        end

        if dist2 < best.dist2
            let best = { 'index': index, 'dist2': dist2 }
        endif
    endfor

    return best.index
endfunction

function! s:rgb_distance2(c1, c2)
    return pow(a:c1.r - a:c2.r, 2) + pow(a:c1.g - a:c2.g, 2) + pow(a:c1.b - a:c2.b, 2)
endfunction

function! s:lab_distance2(c1, c2)
    return pow(a:c1.lab.l - a:c2.lab.l, 2) + pow(a:c1.lab.a - a:c2.lab.a, 2) + pow(a:c1.lab.b - a:c2.lab.b, 2)
endfunction

function! s:build_16_255_palette(color_components, gray_components)
    let palette = {}
    let size = len(a:color_components)

    for ir in range(size)
        for ig in range(size)
            for ib in range(size)
                let index = 16 + size * size * ir + size * ig + ib
                let palette[index] = s:build_color({
                    \ 'r': a:color_components[ir],
                    \ 'g': a:color_components[ig],
                    \ 'b': a:color_components[ib],
                \ }, { 'term': index, 'name': 'xterm' . index })
            endfor
        endfor
    endfor

    let index = 16 + 6 * 6 * 6
    for i in range(len(a:gray_components) - 1)
        let palette[index + i] = s:build_color({
            \ 'r': a:gray_components[i],
            \ 'g': a:gray_components[i],
            \ 'b': a:gray_components[i],
        \ }, { 'term': index + i, 'name': 'xterm' . (index + i) })
    endfor

    return palette
endfunction

let s:xterm_color_components = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]
let s:xterm_gray_components  = [ 0x08, 0x12, 0x1C, 0x26, 0x30, 0x3A,
                               \ 0x44, 0x4E, 0x58, 0x62, 0x6C, 0x76,
                               \ 0x80, 0x8A, 0x94, 0x9E, 0xA8, 0xB2,
                               \ 0xBC, 0xC6, 0xD0, 0xDA, 0xE4, 0xEE ]

let s:xterm_palette = s:build_16_255_palette(
    \ s:xterm_color_components,
    \ s:xterm_gray_components
\ )
