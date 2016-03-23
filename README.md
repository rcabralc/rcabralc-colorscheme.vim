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


## Terminal colors

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
0, Background  | `#26231d`                  | `#26231d`
1              | `#b80d4d`                  | `#b80d4d`
2              | `#7b9e0c`                  | `#506114`
3              | `#f66d04`                  | `#c25b0a`
4              | `#5c7bac`                  | `#5c7ba6`
5              | `#8966bb`                  | `#644d80`
6              | `#5ca886`                  | `#48765f`
7              | `#6a6251`                  | `#6a6251`
8              | `#3f3a30`                  | `#d4c3a3`
9              | `#f60461`                  | `#f60461`
10             | `#9fd304`                  | `#72910d`
11             | `#ebcc66`                  | `#897842`
12             | `#73a1e1`                  | `#73a1e1`
13             | `#b482ff`                  | `#916ac7`
14             | `#73e1b3`                  | `#569a7b`
15, Foreground | `#f5e2bc`                  | `#f5e2bc`

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


## Using terminal Neovim

If you use Neovim in a terminal which supports true colors, the GUI values
will be used if you configure it accordingly:

```bash
$ NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim
```

You can set the variable above in `init.vim` if you use Neovim only in true
color terminals:

```vim
let $NVIM_TUI_ENABLE_TRUE_COLOR = '1'
```

If this environment variable is not set, it'll work just like Vim, and the
closest Xterm colors will be used instead.


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

    hi! link markdownCode Function
    hi! link markdownCodeBlock Function
    hi! link markdownItalic Type
    hi! link markdownBold Statement

    hi! link javaScriptParens Delimiter

    hi! link rubyPseudoVariable Special

    " For things which cannot be configured through hi link, use the colors in
    " the palette and the highlight function.  This function takes care of
    " setting the closest Xterm color available.
    call rcabralc#hl('GitGutterAdd',           a:p.lime,    a:p.none)
    call rcabralc#hl('GitGutterChange',        a:p.cyan,    a:p.none)
    call rcabralc#hl('GitGutterDelete',        a:p.magenta, a:p.none)
    call rcabralc#hl('GitGutterChangeDelete',  a:p.magenta, a:p.none)

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
