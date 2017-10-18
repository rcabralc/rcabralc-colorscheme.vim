function! s:rgb2hsv(in)
    let out = {}

    let min = a:in.r < a:in.g ? a:in.r : a:in.g
    let min = min  < a:in.b ? min  : a:in.b

    let max = a:in.r > a:in.g ? a:in.r : a:in.g
    let max = max  > a:in.b ? max  : a:in.b

    let v = 100.0 * max / 255
    let delta = max - min

    " if delta < 0.00001
    "     return { 'h': 0.0, 's': 0.0, 'v': v }
    " endif
    "
    if max > 0.0
        let s = 100.0 * delta / max
    else
        " if max is 0, then r = g = b = 0              
        " s = 0, h is undefined but we'll let it zero
        return { 'h': 0.0, 's': 0.0, 'v': 0.0 }
    endif

    if a:in.r == max
        let h = (a:in.g - a:in.b) / delta
    else
        if a:in.g == max
            let h = 2.0 + (a:in.b - a:in.r) / delta
        else
            let h = 4.0 + (a:in.r - a:in.g) / delta
        endif
    endif

    let h = h * 60.0

    if h < 0.0
        let h = h + 360.0
    endif

    return { 'h': h, 's': s , 'v': v }
endfunction

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
        let color = { 'r': a:color.r, 'g': a:color.g, 'b': a:color.b }
        let color.gui = s:to_hex_color(color)
    endif

    let color.xyz = s:xyz(color)
    let color.lab = s:lab(color.xyz)
    let color.rgb = { 'r': color.r, 'g': color.g, 'b': color.b }
    let color.hsv = s:rgb2hsv(color.rgb)
    let rgb = { 'r': color.r / 255.0, 'g': color.g / 255.0, 'b': color.b / 255.0 }
    let RGB = {
        \ 'R': rgb.r <= 0.03928 ? rgb.r / 12.92 : pow((rgb.r + 0.055)/1.055, 2.4),
        \ 'G': rgb.g <= 0.03928 ? rgb.g / 12.92 : pow((rgb.g + 0.055)/1.055, 2.4),
        \ 'B': rgb.b <= 0.03928 ? rgb.b / 12.92 : pow((rgb.b + 0.055)/1.055, 2.4)
    \ }
    let color.relative_luminance = 0.2126 * RGB.R + 0.7152 * RGB.G + 0.0722 * RGB.B
    let color.term_aware = function('s:color_term_aware')
    let color.blend = function('s:color_blend')
    let color.distance = function('s:color_distance')
    let color.contrast_to = function('s:color_contrast_to')

    if a:0 == 1
        let options = a:1
    else
        let options = {}
    endif

    if has_key(options, 'term')
        return color.term_aware(options.term)
    endif

    return color
endfunction
let s:build_color = function('rcabralc#build_color')

function! s:color_term_aware(...) dict
    let new_color = copy(self)
    let use_default_term_colors = exists('g:rcabralc') &&
        \ has_key(g:rcabralc, 'use_default_term_colors') &&
        \ g:rcabralc.use_default_term_colors

    if use_default_term_colors && a:0 == 1
        let new_color.term = a:1
    else
        let new_color.term = s:xterm_index(self)
    endif

    return new_color
endfunction

function! s:color_contrast_to(other) dict
    let l1 = self.relative_luminance > a:other.relative_luminance ? self.relative_luminance : a:other.relative_luminance
    let l2 = self.relative_luminance < a:other.relative_luminance ? self.relative_luminance : a:other.relative_luminance
    return (l1 + 0.05) / (l2 + 0.05)
endfunction

function! s:color_blend(color, opacity, ...) dict
    let options = a:0 == 1 ? a:1 : {}

    return s:build_color({
        \ 'r': self.r * a:opacity + a:color.r * (1 - a:opacity),
        \ 'g': self.g * a:opacity + a:color.g * (1 - a:opacity),
        \ 'b': self.b * a:opacity + a:color.b * (1 - a:opacity),
    \ }, options)
endfunction

function! s:color_distance(color) dict
    return pow(s:lab_distance2(self, color), 0.5)
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

function! s:lab(xyz)
    let xn = 0.95047
    let yn = 1.0
    let zn = 1.08883

    return {
        \ 'l': 116 * s:lab_aux_f(a:xyz.y/yn) - 16,
        \ 'a': 500 * (s:lab_aux_f(a:xyz.x/xn) - s:lab_aux_f(a:xyz.y/yn)),
        \ 'b': 200 * (s:lab_aux_f(a:xyz.y/yn) - s:lab_aux_f(a:xyz.z/zn)),
    \ }
endfunction

function! s:lab_aux_f(t)
    return a:t > pow(6.0/29.0, 3) ? pow(a:t, 1.0/3.0) : ((1.0/3.0) * pow(29.0/6.0, 2) * a:t + (4.0/29.0))
endfunction

function! s:xyz(rgb)
    let coefficients = [
        \ [ 0.4124, 0.3576, 0.1805 ],
        \ [ 0.2126, 0.7152, 0.0722 ],
        \ [ 0.0193, 0.1192, 0.9505 ],
    \ ]

    let xyz = s:matrix_multiply(coefficients, [
        \ [s:linear_rgb_component(a:rgb.r / 255.0)],
        \ [s:linear_rgb_component(a:rgb.g / 255.0)],
        \ [s:linear_rgb_component(a:rgb.b / 255.0)]
    \ ])

    return {
        \ 'x': xyz[0][0],
        \ 'y': xyz[1][0],
        \ 'z': xyz[2][0],
    \ }
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
    let best = {}

    for index in sort(keys(s:xterm_palette))
        let xterm_color = s:xterm_palette[index]
        let dist2 = s:lab_distance2(xterm_color, a:color)

        if dist2 == 0
            return index
        end

        if !has_key(best, 'dist2')
            let best.index = index
            let best.dist2 = dist2
        endif

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
                \ }, { 'term': index })
            endfor
        endfor
    endfor

    let index = 16 + 6 * 6 * 6
    for i in range(len(a:gray_components) - 1)
        let palette[index + i] = s:build_color({
            \ 'r': a:gray_components[i],
            \ 'g': a:gray_components[i],
            \ 'b': a:gray_components[i],
        \ }, { 'term': index + i })
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

function! rcabralc#hsv(h, s, v)
    let h = (a:h >= 360 ? 0 : (a:h < 0 ? 0 : a:h)) * 1.0
    let s = (a:s > 100 ? 100 : (a:s < 0 ? 0 : a:s))/100.0
    let v = (a:v > 100 ? 100 : (a:v < 0 ? 0 : a:v))/100.0

    if s == 0
        return s:build_color({ 'r': v * 255, 'g': v * 255, 'b': v * 255 })
    endif

    let c = v * s
    let sector = float2nr(h / 60.0)
    let h1 = h / 60.0
    let x = c * (1 - abs(h1-(2*(float2nr(h1)/2)) - 1))

    if sector == 0
        let r1 = c
        let g1 = x
        let b1 = 0
    elseif sector == 1
        let r1 = x
        let g1 = c
        let b1 = 0
    elseif sector == 2
        let r1 = 0
        let g1 = c
        let b1 = x
    elseif sector == 3
        let r1 = 0
        let g1 = x
        let b1 = c
    elseif sector == 4
        let r1 = x
        let g1 = 0
        let b1 = c
    else
        let r1 = c
        let g1 = 0
        let b1 = x
    endif

    let m = v - c

    return s:build_color({ 'r': 255.0 * (r1 + m), 'g': 255.0 * (g1 + m), 'b': 255.0 * (b1 + m) })
endfunction
