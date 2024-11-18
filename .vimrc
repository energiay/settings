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
"autocmd FileType gitcommit setlocal spell
"set spell
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
"map <leader>ss :setlocal spell!<CR>

" копирование текста всего буфера
map <C-y> jggVG"+y<C-o><C-o>zzk

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
    Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install',
      \ 'for': ['javascript', 'typescript', 'css', 'json'] }
    "Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --tern-completer' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'codota/TabNine', { 'do': 'bash ./dl_binaries.sh' }
    Plug 'easymotion/vim-easymotion'
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'pangloss/vim-javascript'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'VundleVim/Vundle.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    "Plug 'dense-analysis/ale'
call plug#end()

" Включить поддержку JSX
let g:jsx_ext_required = 0
let g:javascript_plugin_jsx = 1

" Автоматическая настройка типов файлов
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact

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

"let g:gruvbox_contrast_light="hard"
set termguicolors
let g:gruvbox_guisp_fallback = "bg"
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



"установить волнистое подчеркивание для слов с ошибками
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
hi SpellBad guisp=red gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl ctermul=red
hi SpellCap guisp=gray gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl ctermul=gray
hi SpellRare guisp=gray gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl ctermul=gray
hi SpellLocal guisp=gray gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl ctermul=gray


let g:tabnine#config = {
\ 'completion': {
\   'enabled': v:true,
\ },
\ 'inline_suggestions': v:true
\ }

" Настройки для coc.nvim
" Выбор подсказок по tab
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

let g:gitblame_enabled = 1  " Включить плагин по умолчанию
let g:gitblame_message_template = '<author> • <date>'  " Шаблон сообщения


let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

" Включение иконок и подчеркивания ошибок
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'

" Включение отображения ошибок в статусной строке
"let g:ale_echo_cursor = 1

nnoremap <silent> ]e :ALENext<CR>
nnoremap <silent> [e :ALEPrevious<CR>
