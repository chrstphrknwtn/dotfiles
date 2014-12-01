set nocompatible
set t_Co=256
set encoding=utf-8
set term=xterm-256color
set mouse=a              " gimme mouse
set backspace=2          " let the backspace work normally
set scrolloff=3          " always keep some context when moving about
set synmaxcol=800        " Don't try to highlight lines longer than 800 characters.
set clipboard=unnamed    " share the clipboard
set expandtab            " white space
set tabstop=2
set shiftwidth=2
set softtabstop=2
set colorcolumn=51,73
set background=dark

" different cursor shapes for insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

hi ColorColumn ctermbg=234

" git
hi diffAdded ctermfg=65
hi diffRemoved ctermfg=167
hi gitcommitBranch ctermfg=110
