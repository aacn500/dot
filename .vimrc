" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin('~/.vim/plugged')

  Plug 'ntpeters/vim-better-whitespace'
  Plug 'altercation/vim-colors-solarized'
  " TODO add more plugins

  call plug#end()

  if has('gui_running')
      let g:solarized_termcolors=256
      set background=dark
      colorscheme solarized
  endif
endif

syntax enable

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

" set underscore as a non-word character
set iskeyword-=_
