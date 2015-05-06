" Vim Settings -----------------------------------------------------------------
set t_Co=256
set encoding=utf-8
set term=xterm-256color
set laststatus=2         " always show status bar
set number               " show the current line number
set cursorline           " highlight current cursor line
set hlsearch             " highlight search results
set incsearch            " incremental search
set timeoutlen=700       " set no timeout when swapping modes
set ttimeoutlen=0
set nowrap               " no line wrap
set textwidth=0          " settings to stop automatic line wrapping when typing
set wrapmargin=0
set mouse=a              " gimme mouse
set splitbelow           " new split panes always on the bottom
set splitright           " new split panes always on the right
set scrolloff=3          " always keep some context when moving about
set hidden               " allow buffers to be hidden
set showcmd              " for easierness show the command in the bottom right
set autoindent           " smarter? indenting
set nowritebackup        " off for some reason, can't remember why...
set backupdir=~/.vim/tmp " don't dirty up my repos
set directory=~/.vim/tmp
set undodir=~/.vim/undo  " holy sheeet persistant undo
set undofile
set undolevels=10000     " howmany undos per file
set nostartofline        " dont move the cursor to the start of a line when switching buffers
set lazyredraw           " dont redraw when executing macros
set list                 " show me those ugly chars so i can kill them
set listchars=tab:❯—,nbsp:§
set synmaxcol=800        " Don't try to highlight lines longer than 800 characters.
set ignorecase           " case insensitive search
set smartcase            " pig == PIG, Pig == Pig, but Pig != pig
set clipboard=unnamed    " share the clipboard
set expandtab            " white space
set completeopt-=preview " dont show annoying preview window
set backspace=indent,eol,start         " let the backspace work normally
set fillchars=vert:\|
set tabstop=2
set shiftwidth=2
set softtabstop=2
set colorcolumn=81
set history=1000
set wildmenu

" different cursor shapes for insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
" let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"


" Status Line ------------------------------------------------------------------
set statusline=
set statusline+=%*[%n%H%M%R%W]%*\         " flags and buf no
set statusline+=%c\|%p%%                  " percentage through file
" set statusline+=%{ShowCount()}\           " show last search count
" set statusline+=%{getcwd()}\             " show current working directory of vim instance
set statusline+=%<                        " when the winow is too narrow, cut it here
set statusline+=%f                        " path & filename
set statusline+=%=                        " align from here on to the right

" Auto Commands ----------------------------------------------------------------
augroup georges_autocommands
  autocmd!
  autocmd FileType unite call s:unite_settings()

  " disable acp in unite windows
  autocmd WinEnter * :if &ft=='unite' | AcpDisable | else | AcpEnable | endif

  " auto source this .vimrc on save
  autocmd BufWritePost $MYVIMRC source $MYVIMRC

  " return to the last edited position when opening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " highlight colums in git commit messages
  autocmd filetype gitcommit set colorcolumn=51,73
  autocmd filetype gitcommit setlocal spell
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " when opening a new line in a comment, don't continue the comment, empty line please
  autocmd FileType * set formatoptions-=r formatoptions-=o

  " auto create global marks when leaving
  autocmd BufLeave,BufWritePost $MYVIMRC normal! mV
  autocmd BufLeave,BufWritePost $MYZSHRC normal! mZ

  " css completion
  autocmd FileType css setlocal iskeyword+=-
  autocmd FileType less setlocal iskeyword+=-
  autocmd FileType html setlocal iskeyword+=-
  autocmd FileType jade setlocal iskeyword+=-

  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

  autocmd BufNewFile,BufRead *.less set ft=less.css

  " golang
  autocmd filetype go setlocal listchars=tab:\ \ ,nbsp:§

  au BufLeave * if !&diff | let b:winview = winsaveview() | endif
  au BufEnter * if exists('b:winview') && !&diff | call   winrestview(b:winview) | endif

  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))

  au FileType qf call AdjustWindowHeight(3, 35)

  " <cr> is mapped to G normally, not so good here
  autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
augroup END



" Colors -----------------------------------------------------------------------
set background=dark
hi clear
syntax reset

"fg=71

" ui
hi ColorColumn ctermbg=234
hi CursorLine ctermbg=234 cterm=none
hi MatchParen ctermbg=none ctermfg=196
hi SneakPluginTarget ctermbg=203 ctermfg=233
hi SneakPluginTarget ctermbg=203 ctermfg=233
hi LineNr ctermfg=240
hi CursorLineNr ctermfg=255
hi Search ctermbg=214 ctermfg=232
hi IncSearch ctermfg=71 ctermbg=232
hi ExtraWhitespace ctermbg=124
hi SpellBad ctermfg=160 ctermbg=none
hi PMenu ctermbg=236 ctermfg=244
hi PMenuSel ctermbg=238 ctermfg=110
hi uniteMarkedLine ctermfg=65
hi DiffChange ctermbg=none
hi StatusLineNC ctermfg=234 ctermbg=240
hi VertSplit ctermfg=234
hi TabLine cterm=none ctermfg=235 ctermbg=234
hi TabLineSel cterm=none ctermfg=250 ctermbg=233
hi TabLineFill cterm=none ctermfg=235 ctermbg=234

" git
hi diffAdded ctermfg=65
hi diffRemoved ctermfg=124
hi gitcommitBranch ctermfg=110

" Text
hi Normal ctermfg=250
hi ErrorMsg ctermbg=160
hi Error ctermbg=160
hi NonText ctermfg=240
hi Comment ctermfg=236
hi Function ctermfg=242
hi Special ctermfg=245
hi SpecialKey ctermfg=17
hi Keyword ctermfg=247
hi Type ctermfg=246
hi Constant ctermfg=246
hi String ctermfg=110
hi Boolean ctermfg=110
hi Preproc ctermfg=246
hi Number ctermfg=110
hi Identifier ctermfg=242
hi Statement ctermfg=245
hi Title ctermfg=255
hi Todo ctermfg=234 ctermbg=249

" Language Specific
hi jsBooleanFalse ctermfg=124
hi jsBooleanTrue ctermfg=65
hi jsGlobalObjects ctermfg=65 " Math, Date, Number, console etc
hi jsStorageClass ctermfg=240 " var
hi jsFunction ctermfg=240 " function
hi jsFuncName ctermfg=247 " functionName
hi javascriptAngularMethods ctermfg=242
hi jsFutureKeys ctermfg=124

" custom sytax varibles
syn match jadeNbsp "nbsp"
hi jadeNbsp ctermfg=65

syntax enable
