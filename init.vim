" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif

" Show trailing spaces
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" Use deoplete. https://github.com/Shougo/deoplete.nvim
"let g:deoplete#enable_at_startup = 1
syntax on
colorscheme delek

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
"set autoindent		" Auto Indent
"set smartindent
"set cindent 		" C indent
set number		" Line number
"set backup
"set cursorline
"set list       " show invisible characters
"set spell spelllang=en_us         " Enable spell check
"set nospell
set modeline

"set expandtab
set ts=4
set shiftwidth=4
set scrolloff=7
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileformats=unix,dos,mac
set ruler

" vim-airline configuration
"let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1

" FZF integration
source /usr/share/doc/fzf/examples/fzf.vim
map <silent> F :FZF<CR>

" for Neovide
colorscheme molokai
set guifont=Operator\ Mono\ Book:h22
let g:neovide_cursor_antialiasing=v:true
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_vfx_particle_density = 37.0
