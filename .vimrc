""" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'albertorestifo/github.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'sjl/badwolf'
call plug#end()

""" Color theme

" set termguicolors        " enable true colors support
" let ayucolor="light"     " or mirage/dark
" colo ayu

" colo elflord
" colo badwolf

colo github

""" Cursor

" if &term =~ "xterm\\|rxvt"
"   let &t_SI = "\e[6 q"
"   let &t_EI = "\e[2 q"
" endif

""" General options
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " spaces in newline start
set expandtab       " tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set timeoutlen=500      " timeout for key combinations

set so=5                " lines to cursor
set backspace=2         " make backspace work like most other apps
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " do case insensitive matching
set smartcase           " do smart case matching
