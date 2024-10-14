" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"	filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
set autoindent		" Auto Indent
set smartindent
"set cindent 		" C indent
set number		" Line number
"set backup
"set cursorline
"set list       " show invisible characters
set spell spelllang=en_us         " Enable spell check
set nospell
set modeline

set expandtab
set ts=4
set shiftwidth=4
set scrolloff=7
set cc=80 " setting right margin to 80 characters, cc==colorcolumn
"set listchars=tab:⋅⋅,trail:⋅
"set list " show white spaces and tabs
set re=1

" syntastic
let python_highlight_all=1

" Show trailing spaces
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileformats=unix,dos,mac
set ruler

" ycm  # https://github.com/ycm-core/YouCompleteMe/issues/1241
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

" colorscheme slate
"colorscheme ron

" pathogen
"execute pathogen#infect()
"let g:autopep8_disable_show_diff=1

" vim-airline configuration
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"""" Allow editing GPG files. http://vim.wikia.com/wiki/Edit_gpg_encrypted_files
""
"" Don't save backups of *.gpg files
"set backupskip+=*.gpg
"" To avoid that parts of the file is saved to .viminfo when yanking or
"" deleting, empty the 'viminfo' option.
"set viminfo=
""
"augroup encrypted
"  au!
"  " Disable swap files, and set binary file format before reading the file
"  autocmd BufReadPre,FileReadPre *.gpg
"    \ setlocal noswapfile bin
"  " Decrypt the contents after reading the file, reset binary file format
"  " and run any BufReadPost autocmds matching the file name without the .gpg
"  " extension
"  autocmd BufReadPost,FileReadPost *.gpg
"    \ execute "'[,']!gpg --quiet --decrypt --default-recipient-self" |
"    \ setlocal nobin |
"    \ execute "doautocmd BufReadPost " . expand("%:r")
"  " Set binary file format and encrypt the contents before writing the file
"  autocmd BufWritePre,FileWritePre *.gpg
"    \ setlocal bin |
"    \ '[,']!gpg --encrypt --default-recipient-self
"  " After writing the file, do an :undo to revert the encryption in the
"  " buffer, and reset binary file format
"  autocmd BufWritePost,FileWritePost *.gpg
"    \ silent u |
"    \ setlocal nobin
"augroup END

""""""""""""""""""""""
" Quick Run
"See filetype list at /usr/share/vim/vim80/filetype.vim
""""""""""""""""""""""
map <F5> :call CompileRun()<CR>
func! CompileRun()
	exec "w"
	if &filetype == 'c'
		exec "!gcc % -o %<"
		exec "!./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!./%<"
	elseif &filetype == 'sh'
		exec "!bash ./%"
	elseif &filetype == 'python'
		exec "!python3 %"
	elseif &filetype == 'perl'
		exec "!perl %"
	elseif &filetype == 'perl6'
		exec "!perl6 %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		exec "!go run %"
	elseif &filetype == 'markdown'
		exec "!2pdf -t -i %; evince %.pdf"
	elseif &filetype == 'rst'
		exec "!2pdf -t -i %; evince %.pdf"
	elseif &filetype == 'tex'
		exec "!2pdf -t -i %; evince %.pdf"
	elseif &filetype == 'plaintex'
		exec "!2pdf -t -i %; evince %.pdf"
	else
		echo "What is fileType " &filetype " ?"
	endif
endfunc

source /usr/share/doc/fzf/examples/fzf.vim
noremap <silent> F :FZF<CR>
map H :NERDTreeToggle<CR>

" Cursor Settings
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
"
"
colorscheme monokai
"set spell

"set foldmethod=indent
