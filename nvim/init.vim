if filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    call plug#begin('~/.config/nvim/plugged')

    Plug 'fidian/hexmode'
    Plug 'airblade/vim-gitgutter'
    Plug 'zefei/vim-wintabs'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --go-completer --js-completer' }

    Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoUpdateBinaries' }

    Plug 'Alvarocz/vim-northpole'

    call plug#end()

    set termguicolors
    colorscheme northpole

    " vim-wintabs
    map <C-H> <Plug>(wintabs_previous)
    map <C-L> <Plug>(wintabs_next)
    map <C-T>c <Plug>(wintabs_close)
    map <C-T>o <Plug>(wintabs_only)
    map <C-W>c <Plug>(wintabs_close_window)
    map <C-W>o <Plug>(wintabs_only_window)

    " vim-go
    function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
            call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
            call go#cmd#Build(0)
        endif
    endfunction

    let g:go_fmt_command = "goimports"
    autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd FileType go nmap <leader>r <Plug>(go-run)
    autocmd FileType go nmap <leader>t <Plug>(go-test)
    autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)

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

" move up to next visual line, ie. respect wrapped text
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" move between splits using Ctrl+hjkl
"nmap <C-H> <C-W>h
"nmap <C-J> <C-W>j
"nmap <C-K> <C-W>k
"nmap <C-L> <C-W>l

" helper keymaps for the quickfix window
map <C-M> :cnext<CR>
map <C-N> :cprevious<CR>
nnoremap <leader>q :cclose<CR>

inoremap jj <Esc>

nnoremap <Leader>h :set hlsearch!<CR>

autocmd FileType tex set spell spelllang=en_gb

"set iskeyword-=_
set mouse=a
