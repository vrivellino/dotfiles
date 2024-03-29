" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" TERM should be xterm-256color for this to work
set t_Co=256

" colorscheme lucius
" LuciusBlack

"" only set pythonhome, pythondll, pythonthreehome, and pythonthreedll if we're running macvim
"if has('gui_macvim')
"  if empty($VIRTUAL_ENV)
"    " Default to python 3.8 installed via homebrew
"    set pythonthreehome=/usr/local/Cellar/python@3.8/3.8.6/Frameworks/Python.framework/Versions/3.8
"    set pythonthreedll=/usr/local/Cellar/python@3.8/3.8.6/Frameworks/Python.framework/Versions/3.8/Python
"    let python_ver='3.8'
"  else
"    if filereadable($VIRTUAL_ENV . '/bin/python2.7')
"      set pythonhome=$VIRTUAL_ENV
"      let &pythondll=$VIRTUAL_ENV . '/PythonHome/Python'
"      let python_ver='2.7'
"    endif
"    if filereadable($VIRTUAL_ENV . '/bin/python3')
"      set pythonthreehome=$VIRTUAL_ENV
"      let &pythonthreedll=$VIRTUAL_ENV . '/PythonHome/Python'
"      let python_minor_ver=split(split(system('python3 --version 2>&1'))[1], '\.')[1]
"      let python_ver='3.' . python_minor_ver
"    endif
"    " set PYTHONPATH because sys.path isn't getting setup right
"    let env_python_path = $VIRTUAL_ENV.'/PythonHome/lib/python' . python_ver . ':' . $VIRTUAL_ENV . '/PythonHome/lib/python' . 'python_ver' . '3.8/lib-dynload'
"    if empty($PYTHONPATH)
"      let $PYTHONPATH = env_python_path
"    else
"      let $PYTHONPATH .= env_python_path
"    endif
"    " activate virtualenv
"    if python_ver == '2.7'
"      py << EOF
"import os
"import sys
"project_base_dir = os.environ['VIRTUAL_ENV']
"activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"execfile(activate_this, dict(__file__=activate_this))
"EOF
"    else
"      py3 << EOF
"import os
"import sys
"project_base_dir = os.environ['VIRTUAL_ENV']
"activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"exec(open(activate_this).read(), dict(__file__=activate_this))
"EOF
"    endif
"  endif
"  if python_ver == '3.7'
"  endif
"endif

" allow backspacing over everything in insert mode
set bs=2
" always set autoindenting on
set ai
" no backup~ files
set nobackup

set visualbell

set viminfo=%,<800,'20,/50,:100,h,f0,n~/.viminfo
"           | |    |   |   |    | |  + viminfo file path
"           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | |    |   |   + command-line history saved
"           | |    |   + search history saved
"           | |    + files marks saved
"           | + lines saved each register (old name for <, vi6.2)
"           + save/restore buffer list

" keep 10 lines of command line history
set history=100
" show the cursor position all the time
set ruler
" Switch buffers without saving
set hidden
" Always show line numbers
set number

" Modeline magic: http://vim.wikia.com/wiki/Modeline_magic
set modeline
set modelines=5

" Always shot status line
set laststatus=2
" milliseconds Vim waits after you stop typing before it triggers plugins
set updatetime=250

" set terminal title
set title

" completion
set wildmode=full
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*.pyc
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  let python_highlight_all=1
  syntax on
  set hlsearch
endif

" Disable Polygot for Go
let g:polyglot_disabled = ['go.plugin']

if filereadable(expand("~/.vim/autoload/plug.vim"))
  " https://github.com/junegunn/vim-plug/
  " VimPlug start
  call plug#begin('~/.vim/plugged')
  " Plugins
  Plug 'ervandew/supertab'
  Plug 'scrooloose/nerdtree'
  Plug 'xuyuanp/nerdtree-git-plugin'
  Plug 'w0rp/ale'
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'jpalardy/vim-slime'
  Plug 'airblade/vim-gitgutter'
  Plug 'sheerun/vim-polyglot'
  Plug 'altercation/vim-colors-solarized'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  " Plug 'psf/black', { 'branch': 'stable' }
  " Initialize plugin system
  call plug#end()
endif

if has("gui_running")
  set background=light
  if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
    colorscheme solarized
  endif
  set gfn=Monaco:h12
else
  set background=dark
  "if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
  "  let g:solarized_termcolors=256
  "  colorscheme solarized
  "endif
endif

" Softtab of 4 spaces is default for me...
set tabstop=4
"set softtabstop=2
"set shiftwidth=2
set expandtab

filetype plugin indent on

" Some specifics based on file type ...
autocmd FileType phtml set syntax=php expandtab tabstop=4
autocmd FileType sh,php,inc,apache,conf,html,json,groovy,python set expandtab tabstop=4 sw=4
autocmd FileType pl set noexpandtab
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType markdown set tw=110
autocmd FileType javascript,yaml,ruby set expandtab tabstop=2 sw=2
autocmd FileType vim set expandtab tabstop=2 sw=2
autocmd FileType go set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab nolist

 " In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78

if filereadable(expand("~/.vim/plugged/nerdtree/autoload/nerdtree.vim"))
  " Ctrl-n to toggle nerdtree
  map <C-n> :NERDTreeToggle<CR>
  let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_go_golangci_lint_package = 1
let g:ale_pattern_options = {
\   '.*\.go$': {'ale_enabled': 0},
\}
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

" vim-slime
let g:slime_default_config = {"sessionname": "slime", "windowname": "0"}
let g:slime_python_ipython = 1

" vim-go
let g:go_metalinter_autosave = 1
