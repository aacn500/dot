" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/plugged')

    Plug 'ntpeters/vim-better-whitespace'
    Plug 'altercation/vim-colors-solarized'
    Plug 'airblade/vim-gitgutter'
    Plug 'jelera/vim-javascript-syntax'
    Plug 'digitaltoad/vim-pug'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer --tern-completer' }
    Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoInstallBinaries' }
    Plug 'derekwyatt/vim-scala'
    Plug 'editorconfig/editorconfig-vim'

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
filetype plugin indent on

set number
set showcmd
set showmatch

" move up/down vertically by visual line
nnoremap j gj
nnoremap k gk

" switch tabs
map <F7> :tabp <CR>
map <F8> :tabn <CR>

" toggle highlight search
nnoremap <Leader>h :set hlsearch!<CR>

" syntax for ejs files as if they were html
au BufNewFile,BufRead *.ejs set filetype=html

" set underscore as a non-word character
set iskeyword-=_

" vim-go
autocmd FileType go map <C-.> :cnext<CR>
autocmd FileType go map <C-,> :cprevious<CR>
autocmd FileType go nnoremap <leader>q :cclose<CR>
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
