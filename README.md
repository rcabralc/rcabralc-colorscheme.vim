# rcabralc's color scheme for Vim

A vibrant, warmer variation of Monokai, for GUI and terminals.  A light
version is also provided.  Some inspiration taken from
[gruvbox](https://github.com/morhetz/gruvbox).


## Configuration

Set the background and color scheme in your `vimrc`/`init.vim` file:

```vim
set background=dark " or light
colorscheme rcabralc
```


## Colors in terminals

This color scheme was primarily built for the GUI version.  For terminals
which can render 256 colors, the color scheme colors are approximated to the
closest terminal color available (Xterm palette is assumed).  If this
approximation is good enough for you (just test it in a
`xterm-256color`-compatible terminal and see), you don't need to configure
anything else.  Just be sure to `set t_Co=256` in your `vimrc`/`init.vim`.

However, for more fidelity to the GUI version, customize your default terminal
colors as the following:

Color index    | Color value (dark version) | Color value (light version)
-------------- | -------------------------- | ---------------------------
0, Background  | `#2c241d`                  | `#f5c9a2`
1              | `#ae1a36`                  | `#ce173c`
2              | `#76920f`                  | `#5a6915`
3              | `#ff5f02`                  | `#966c0f`
4              | `#587096`                  | `#6383b4`
5              | `#8e4566`                  | `#a74d78`
6              | `#93bab7`                  | `#606f6a`
7              | `#866e59`                  | `#9b7f66`
8              | `#4a3d31`                  | `#d7b08e`
9              | `#ce173c`                  | `#d63b50`
10             | `#88ad0c`                  | `#797c31`
11             | `#ffb300`                  | `#c04d0a`
12             | `#6383b4`                  | `#8091b0`
13             | `#a74d78`                  | `#b76680`
14             | `#addfde`                  | `#7d8175`
15, Foreground | `#f5c9a2`                  | `#2c241d`

Then set this in your `vimrc`/`init.vim` file (before setting the color
scheme):

```vim
let g:rcabralc = {}
let g:rcabralc.use_default_term_colors = 1
```

Then finally set the background and color scheme:

```vim
set background=dark " or light
colorscheme rcabralc
```

The colors above are not the exhaustive list.  More of them are used, but
normally terminals only allow customization of the sixteen first colors.
Because of this, even with this customization, some of the colors, specially
those used in the bundled
[lightline](https://github.com/itchyny/lightline.vim) theme and some shades of
gray, will still be approximations to the 256 colors palette.  Therefore, a
proper `xterm-256color`-compatible terminal is still recommended.

Please note that if you skip the terminal palette customization but set
`g:rcabralc.use_default_term_colors` to `1`, the results will likely be very
wrong.  Don't set this variable if you don't want to customize your terminal's
palette (and stick with the provided approximated colors).


## Transparent background

As a bonus, for terminals which are emulated under a compositing environment
and have transparency enabled, it's possible to use a transparent background
inside Vim.  Set this in your `vimrc`/`init.vim` file (before setting the
color scheme):

```vim
let g:rcabralc = {}
let g:rcabralc.transparent_background = 1
```

This sets the `Normal` background to `NONE`, which makes Vim not to render a
background, allowing you to see the terminal background color, which can have
transparency.  Note that this only works in emulated terminals, not in GUI.


## Highlight optimizations

This color scheme does not include any hightlight group besides the default
ones.  It's encouraged that users put this kind of configuration in
`vimrc`/`init.vim`.  The palette and highlight function are exposed to allow
these settings.

Example:

```vim
function! s:improve_highlights(p)
    hi! link cssClassName Type
    hi! link cssFunctionName Function
    hi! link cssIdentifier Identifier

    hi! link markdownItalic Type
    hi! link markdownBold Statement

    hi! link javaScriptParens Delimiter

    hi! link rubyPseudoVariable Special

    " For things which cannot be configured through hi link, use the colors in
    " the palette and the highlight function.  This function takes care of
    " setting the closest Xterm color available.
    call rcabralc#hl('GitGutterAdd',           a:p.yellow, a:p.none)
    call rcabralc#hl('GitGutterChange',        a:p.cyan,   a:p.none)
    call rcabralc#hl('GitGutterDelete',        a:p.red,    a:p.none)
    call rcabralc#hl('GitGutterChangeDelete',  a:p.red,    a:p.none)

    " An example for indent guides plugin.
    if !exists('g:indent_guides_auto_colors')
      let g:indent_guides_auto_colors = 0
    endif
    if g:indent_guides_auto_colors == 0
      call rcabralc#hl('IndentGuidesOdd',  a:p.none, a:p.gray0)
      call rcabralc#hl('IndentGuidesEven', a:p.none, a:p.gray1)
    endif
endfunction

augroup Colors
    autocmd!
    autocmd ColorScheme rcabralc call s:improve_highlights(g:rcabralc#palette)
augroup END
```

To view a comprehensive list of colors, their names, hex values, terminal
codes, etc, inspect it in Vim:

```vim
:echo rcabralc#palette
```

This is a dictionary with color names as keys and their data as nested
dictionaries.

**TODO**: Provide a better way to show/inspect the palette.
