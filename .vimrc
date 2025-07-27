" ==============
" VIM-PLUG SETUP
" ==============

let dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo ' . dir . '/autoload/plug.vim --create-dirs ' .
				\  'https://raw.githubusercontent.com/junegunn/vim-plug/' .
				\  'master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =======
" PLUGINS
" =======

call plug#begin()
Plug 'bfrg/vim-c-cpp-modern'
Plug 'jasonccox/vim-wayland-clipboard'
Plug 'airblade/vim-gitgutter'
call plug#end()

" ==============
" BASIC SETTINGS
" ==============

filetype plugin indent on
syntax on
set termguicolors
color sorbet
set encoding=UTF-8
set fileencoding=UTF-8
set mouse=a
set hidden
set noswapfile
set nobackup
set undofile

" ================
" DISPLAY SETTINGS
" ================

set showcmd
set showmatch
set matchtime=2
set virtualedit=all
set foldmethod=marker
set scrolloff=4
set sidescrolloff=4
set splitbelow
set splitright
set cursorlineopt=screenline,number
set cursorline
set numberwidth=3
set relativenumber
set number
set signcolumn=yes
set laststatus=2
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect

" ====================
" INDENTATION SETTINGS
" ====================

set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set cinoptions=g0,(s,us,U1,ks,m1
set noexpandtab
set shiftround

" ===============
" SEARCH SETTINGS
" ===============

set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault

" ===============
" VISUAL SETTINGS
" ===============

set listchars=tab:│\ \ ,trail:·
set list
set wrap
set linebreak
set breakindent
set showbreak=↯\ 

" ====================
" PERFORMANCE SETTINGS
" ====================

set updatetime=250
set timeoutlen=500
set ttimeoutlen=50
set lazyredraw

" ============================
" BACKUP, TEMP & UNDO SETTINGS
" ============================

" Create robust, private directories for temp and undo files
let s:vimdir = has('nvim') ? stdpath('data') : expand('~/.vim')
let &undodir = s:vimdir . '/undodir'
let &directory = s:vimdir . '/tmp'
let &backupdir = s:vimdir . '/backup'

" Create the directories if they don't exist
if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif

" ===============
" CUSTOM MAPPINGS
" ===============

let mapleader = "\<space>"

" Config Management
nnoremap <leader>l :source $MYVIMRC<cr>
nnoremap <leader>v :tabnew $MYVIMRC<cr>

" File Operations
nnoremap <leader>w :w!<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <leader>x :x!<cr>
nnoremap <leader>q :bd<cr>

" Window Navigation
nnoremap <c-j> <c-w>j
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-k> <c-w>k
nnoremap <c-w>v :vsplit<cr>
nnoremap <c-w>s :split<cr>

" Tab Navigation
nnoremap H :tabprev<cr>
nnoremap L :tabnext<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>

" Utility Mappings
nnoremap <leader>s :set spell!<cr>
nnoremap <leader><leader> :nohlsearch<cr>
nnoremap <leader>tr :silent! %s/\s\+$//<cr> :nohlsearch<cr>

" Movement Mappings
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap 0 g0

" Terminal Mode
tnoremap <esc> <c-\><c-n>

" Copy/Paste Enhancements
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Text Manipulation
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>a ggVG
nnoremap <leader>d :t.<cr>

" =============
" AUTO COMMANDS
" =============

if has("autocmd")
	augroup autovimrc
		autocmd!
		" Return to last edit position when opening files
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	augroup END
endif

" =====================
" PLUGIN CONFIGURATIONS
" =====================

" GitGutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '↾'
let g:gitgutter_sign_removed_above_and_below = '⇌'
let g:gitgutter_sign_modified_removed = '±'
