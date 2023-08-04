set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set showcmd
set number
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=2
set autoindent
set formatoptions=c,q,r,t
set ruler
set mouse=a
set background=dark
set t_Co=256

execute pathogen#infect()
syntax on
filetype plugin indent on

map <F2> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeWinPos='left'
let g:NERDTreeWinSize=30
let g:NERDTreeShowLineNumbers=0
let g:NERDTreeHidden=0
autocmd vimenter * if !argc() | NERDTree | endif
