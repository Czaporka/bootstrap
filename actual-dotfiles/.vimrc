set number

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
colorscheme delek

set encoding=utf-8

set hlsearch
syntax on
filetype plugin indent on

execute pathogen#infect()

let g:jedi#show_call_signatures=1

map <F5> <Esc>:w<CR>:!python3 %<CR>

