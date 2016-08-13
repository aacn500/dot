syntax enable

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

filetype indent on


" Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set laststatus=2
