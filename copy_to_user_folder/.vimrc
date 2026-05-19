set number "Show number line
set mouse=a "Show mouse pointer
set numberwidth=1 "Define nuber line width 
set clipboard=unnamed "Allows access data to external clipboard
"set syntax on "Enable code syntax detector
set showcmd "Show commands in use
set ruler "Show ruler info file and cursor position
set encoding=utf-8 "Define encode
set showmatch "Show respective close key, for example {} or () or []
set sw=2 "Define tabulation to two spaces
"set relativenumber "Show relative number of cursor position line
set laststatus=2 "Show status bar
"set noshowmode "Hide editor mode bar (Insert, Replace or Visual) 

" Imports config files
so ~/.vim/plugins.vim

colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let NERDTreeQuitOnOpen = 1 " hidden NerdTree on open file
let mapleader = " " " Define key for 'leader' or main command key

" Keyboard shortcuts
" nmap <Leader>s <Plug>(easymotion-s2)
nmap <Leader>nt :NERDTreeFind<CR>
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>
