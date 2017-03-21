execute pathogen#infect()
"vim-better-whitespace
"vim-colors-solarized
"vim-javascript-syntax
"vim-pug

syntax enable
if has('gui_running')
    let g:solarized_termcolors=256
    set background=dark
    colorscheme solarized
endif

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set number
set showcmd
filetype plugin indent on
set showmatch

" move up/down vertically by visual line
nnoremap j gj
nnoremap k gk

map <F7> :tabp <CR>
map <F8> :tabn <CR>

" syntax for ejs files as if they were html
au BufNewFile,BufRead *.ejs set filetype=html
