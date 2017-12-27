" Taken from example vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set background=dark
" colorscheme evening

" TERM should be xterm-256color for this to work
set t_Co=256

" colorscheme lucius
" LuciusBlack

set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nobackup
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

set hidden      " Switch buffers without saving
set number      " Always show line numbers

set modeline
set modelines=5

set tabstop=4
"set softtabstop=2
"set shiftwidth=2
set expandtab
filetype plugin indent on
set laststatus=2
set updatetime=250

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
"vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  let python_highlight_all=1
  syntax on
  set hlsearch
endif

" https://github.com/junegunn/vim-plug/
" VimPlug start
call plug#begin('~/.vim/plugged')
" Plugins
Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'
Plug 'airblade/vim-gitgutter'
" Initialize plugin system
call plug#end()

" Some specifics based on file type ...
autocmd FileType phtml set syntax=php expandtab tabstop=4
autocmd FileType sh,php,inc,apache,conf,html,json,groovy set expandtab tabstop=4 sw=4
autocmd FileType pl set noexpandtab
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType markdown set tw=110
autocmd FileType javascript,yaml,ruby set expandtab tabstop=2 sw=2

 " In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78

augroup cprog
  " Remove all cprog autocommands
  au!
  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql nocindent comments=sr:/*,mb:*,el:*/,:// noexpandtab
augroup END

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  " use "gzip -d", gunzip isn't always available
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gzip -d")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bzip2 -d")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gzip -d")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bzip2 -d")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    " set 'cmdheight' to two, to avoid the hit-return prompt
    let ch_save = &ch
    set ch=3
    " when filtering the whole buffer, it will become empty
    let empty = line("'[") == 1 && line("']") == line("$")
    let tmp = tempname()
    let tmpe = tmp . "." . expand("<afile>:e")
    " write the just read lines to a temp file "'[,']w tmp.gz"
    execute "'[,']w " . tmpe
    " uncompress the temp file: call system("gzip -d tmp.gz")
    call system(a:cmd . " " . tmpe)
    " delete the compressed lines
    '[,']d
    " read in the uncompressed lines "'[-1r tmp"
    set nobin
    execute "'[-1r " . tmp
    " if buffer became empty, delete trailing blank line
    if empty
      normal Gdd''
    endif
    " delete the temp file
    call delete(tmp)
    let &ch = ch_save
    " When uncompressed the whole buffer, do autocommands
    if empty
      execute ":doautocmd BufReadPost " . expand("%:r")
    endif
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      call system(a:cmd . " " . expand("<afile>:r"))
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    call system(a:cmd . " " . expand("<afile>"))
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

augroup END

" This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
" back to positions in previous files more than once.
if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
endif

" Ctrl-n to toggle nerdtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" lightline-ale
let g:lightline = {}
let g:lightline.component_expand = { 'linter_warnings': 'lightline#ale#warnings', 'linter_errors': 'lightline#ale#errors', 'linter_ok': 'lightline#ale#ok' }
let g:lightline.component_type = { 'linter_warnings': 'warning', 'linter_errors': 'error', }
let g:lightline.active = { 'right': [[ 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

" vim-slime
let g:slime_default_config = {"sessionname": "slime", "windowname": "0"}
let g:slime_python_ipython = 1
