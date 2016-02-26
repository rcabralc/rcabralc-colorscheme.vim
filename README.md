# rcabralc's Colorscheme for Vim

A vibrant, warmer variation of Monokai, with a litte bit more contrast between
colors and white.


## Configuration

Just set the colorscheme in your `vimrc` file:

```
colorscheme rcabralc
```


## Terminal colors

This color scheme was built mainly for the GUI version.  For terminals which
can render 256 colors, there is a palette which approximate the GUI version
colors to their equivalent ones in the Xterm 256 colors palette (this
approximation can be improved in further versions).  If that approximation is
good enough for you (just test it and see), you don't need to configure
anything else.  Just be sure to `set t_Co=256` in your `.vimrc`.

However, for more fidelity to the GUI version, customize your default terminal
colors as the following:

Color index    | Color value
-------------- | -----------
0, Background  | `#24231d`
1, 9           | `#ff0569`
2, 10          | `#9fd304`
3,             | `#f66d04`
4, 12          | `#6f82d9`
5, 13          | `#a773e2`
6, 14          | `#60bda8`
7              | `#6e6a57`
8              | `#36342b`
11             | `#ebcc66`
15, Foreground | `#fff6cd`

Then set this in your `vimrc` file (before setting the color scheme):

```
let g:rcabralc#use_default_term_colors = 1
```

Please note that if you skip the terminal palette customization, the results
will likely be very wrong.  Don't set the above variable if you don't want to
customize your terminal's palette (and stick with the provided approximated
colors).


### Transparent background

As a bonus, for terminals which are emulated under a compositing environment
and have transparency enabled, it's possible to use a transparent background
inside Vim.  Set this in your `vimrc` file (before setting the color scheme):

```
if !has('gui_running')
  let g:rcabralc#transparent_background = 1
endif
```

Note that this only works in terminals, not in GUI.
