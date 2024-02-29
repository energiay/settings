set encoding=utf-8

"set suffixesadd+=.js

set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

"set autoindent
"set smartindent

set colorcolumn=83

set list
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»,space:·",eol:¬

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd BufRead,BufNewFile *.js setlocal spell
autocmd FileType gitcommit setlocal spell
set spell
set spell spelllang=ru_ru,en_us

" backspace работает как в др.редакторах
set backspace=indent,eol,start

syntax on
set completeopt-=preview
set number
set relativenumber
set noswapfile

"отключить звук
set noerrorbells
set novisualbell

"переназначение кнопки лидер
"let mapleader="," 
"noremap \ ,  

nmap <leader>w :w!<cr> 
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>ss :setlocal spell!<CR>

" копирование текста всего буфера
map <C-y> ggVG"+y<C-o><C-o>zz

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
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'VundleVim/Vundle.vim'
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-surround'
call plug#end()

" включить расширенные возможности команды %
"set nocompatible
"filetype plugin on
"runtime macros/matchit.vim
":let loaded_matchit = 1
packadd! matchit

"биндим кнопки под NORDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

let g:UltiSnipsEditSplit="vertical"

"цветовая схема
set background=light
nnoremap <C-f> :NERDTreeFind<CR>

let g:gruvbox_contrast_light="hard"
colorscheme gruvbox
"set background=light
"let g:gruvbox_color_column="red"
"let g:gruvbox_termcolors=88

hi ColorColumn ctermbg=lightgrey guibg=lightgrey

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

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:UltiSnipsEditSplit="vertical"

"vmap cc :norm i//<CR>
"vmap uc :norm ^x^x<CR>


"syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_checkers_javascript= ['javascript']
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
