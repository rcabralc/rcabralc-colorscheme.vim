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
0, Background  | `#2b241d`                  | `#f2cca0`
1              | `#c02c43`                  | `#cb2944`
2              | `#c0bf46`                  | `#6f6f27`
3              | `#f25824`                  | `#9f5840`
4              | `#97487a`                  | `#ad4e8e`
5              | `#b64d6e`                  | `#b1476a`
6              | `#7b92a9`                  | `#5b6e81`
7              | `#857058`                  | `#826e56`
8              | `#675744`                  | `#a3896c`
9              | `#e62e4d`                  | `#eb3652`
10             | `#e6e650`                  | `#706f29`
11             | `#f28561`                  | `#bb441c`
12             | `#b35092`                  | `#c55d9f`
13             | `#d95782`                  | `#bb4f71`
14             | `#8fadcc`                  | `#5c6d7f`
15, Foreground | `#f2cca0`                  | `#2b241d`

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
