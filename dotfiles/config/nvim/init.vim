" Turn off vi support
set nocompatible

" Plugins
call plug#begin('~/.vim/plugged')

" Buffers modification
"Plug 'fholgado/minibufexpl.vim'

" UI
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mbbill/undotree', { 'on':  'UndotreeToggle' }
Plug 'majutsushi/tagbar', { 'on':  'TagbarToggle' }

" Additional visual elements and highlight
Plug 'ntpeters/vim-better-whitespace'
Plug 'kshenoy/vim-signature'
Plug 'Yggdroot/indentLine'

" Functionality
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/a.vim'
Plug 'godlygeek/tabular'
Plug 'andymass/vim-matchup'
"Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clangd-completer', 'for' : ['c', 'cpp', 'python', 'shell', 'bash', 'zsh', 'vim'] }
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clangd-completer'}
Plug 'easymotion/vim-easymotion'

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" SQL
"Plug 'vim-scripts/dbext.vim'
Plug 'tpope/vim-dadbod'

" Colorschemes
Plug 'cseelus/vim-colors-lucid'
" Syntax
Plug 'bfrg/vim-cpp-modern'
Plug 'justinmk/vim-syntax-extra'
" Masm
Plug 'gcollura/vim-masm'

" Tmux support
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'

" LaTeX
Plug 'lervag/vimtex', { 'for' : 'tex' }

call plug#end()

" True color support
set termguicolors

" Syntax highlight
syntax on
set background=dark
" Highlight cur row
set cursorline
colorscheme lucid

highlight Comment cterm=italic
highlight String cterm=italic
highlight Operator cterm=italic
highlight Statement cterm=italic

highlight PreProc cterm=bold
highlight PreCondit cterm=bold

" Row
set number
set signcolumn=yes " Left offset for sign like ycm's or syntastic's `>>`

" Default encoding
set termencoding=utf8

" Visual instead of sound bell
set visualbell

" Indents
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent

" Indents for makefiles
au FileType make set noexpandtab

" Search
set ic
set hls
set is
set incsearch
set inccommand=nosplit " only neovim feature

" Mouse support
set mouse=a
set mousemodel=popup

" Turn off line wrap
set nowrap

" Show typing commands in status-bar
set showcmd

" Airline
" Theme
let g:airline_theme = 'lucid'
" Don't show current mode in defualt status-bar
set noshowmode
" Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" NERDTree
nnoremap <F2> :NERDTreeToggle <bar> AirlineRefresh<CR>

" Undotree
nnoremap <F3> :UndotreeToggle<cr>
let g:undotree_WindowLayout = 3

" Tagbar
nnoremap <F4> :TagbarToggle<CR>

" YouCompleteMe
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" Disable preview:
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0

" Indentline
let g:indentLine_color_gui = '#36323d'
let g:indentLine_concealcursor = 1
let g:indentLine_char = '┆'

" EasyMotion
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" VimTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode = 0

" SQL
"let g:dbext_default_profile = 'SQLSRV'
"let g:dbext_default_SQLSRV_bin = 'sqlcmd'
"let g:dbext_default_profile_SQLSRV = 'type=SQLSRV:user=frs:passwd=_RflBan_:host=localhost:replace_title=1'

" Indents for Qt
function! QtCppIndent()
  " Patterns used to recognise labels and search for the start
  " of declarations
  let labelpat='signals:\|slots:\|public:\|protected:\|private:\|Q_OBJECT'
  let declpat='\(;\|{\|}\)\_s*.'
  " If the line is a label, it's a no brainer
  if match(getline(v:lnum),labelpat) != -1
    return 0
  endif
  " If the line starts with a closing brace, it's also easy: use cindent
  if match(getline(v:lnum),'^\s*}') != -1
    return cindent(v:lnum)
  endif
  " Save cursor position and move to the line we're indenting
  let pos=getpos('.')
  call setpos('.',[0,v:lnum,1,0])
  " Find the beginning of the previous declaration (this is what
  " cindent will mimic)
  call search(declpat,'beW',v:lnum>10?v:lnum-10:0)
  let prevlnum = line('.')
  " Find the beginning of the next declaration after that (this may
  " just get us back where we started)
  call search(declpat,'eW',v:lnum<=line('$')-10?v:lnum+10:0)
  let nextlnum = line('.')
  " Restore the cursor position
  call setpos('.',pos)
  " If we're not after a label, cindent will do the right thing
  if match(getline(prevlnum),labelpat)==-1
    return cindent(v:lnum)
  " It will also do the right thing if we're in the middle of a
  " declaration; this occurs when we are neither at the beginning of
  " the next declaration after the label, nor on the (non-blank) line
  " directly following the label
  elseif nextlnum != v:lnum && prevlnum != prevnonblank(v:lnum-1)
    return cindent(v:lnum)
  endif
  " Otherwise we adjust so the beginning of the declaration is one
  " shiftwidth in
  return &shiftwidth
endfunc
set indentexpr=QtCppIndent()

" For dos-asm
au FileType asm setlocal fenc=cp1251
au FileType asm setlocal ff=dos
au FileType asm setlocal tabstop=8
au FileType asm setlocal shiftwidth=8
au FileType asm setlocal syntax=masm

