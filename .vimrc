set encoding=utf-8

set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set autoindent
set smartindent

" backspace работает как в др.редакторах
set backspace=indent,eol,start

syntax on
set number
set noswapfile

"отключить звук
set noerrorbells
set novisualbell

"переназначение кнопки лидер
let mapleader="," 

nmap <leader>w :w!<cr> 
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>ss :setlocal spell!<CR>

"игнорировать регистр при поиске
set ignorecase
set smartcase

"подсветить результат поиска
set hlsearch

"nohl - убрать выделение после поиска
set incsearch

call plug#begin()
    Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'morhetz/gruvbox'
    Plug 'prettier/vim-prettier', { 'do': 'npm install' }
    Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --tern-completer' }
    Plug 'easymotion/vim-easymotion'
    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
call plug#end()

"биндим кнопки под NORDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

"цветовая схема
set background=light
nnoremap <C-f> :NERDTreeFind<CR>

let g:gruvbox_contrast_light="hard"
colorscheme gruvbox
"set background=light
"let g:gruvbox_color_column="red"
"let g:gruvbox_termcolors=88

let g:prettier#exec_cmd_path = "~/.vim/plugged/vim-prettier/autoload/prettier.vim"
let NERDTreeShowHidden=1
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'

"закрытие скобок
"imap [ []<LEFT>
"imap ( ()<LEFT>
"imap { {}<LEFT>
"закрытие кавычек
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

let python_highlight_all = 1
