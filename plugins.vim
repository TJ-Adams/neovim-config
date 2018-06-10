call plug#begin('~/.vim/plugged')

if has('win32')
  let s:path_sep = '\\'
else
  let s:path_sep = '/'
endif

" {{{ Buffer Explorer
Plug 'jlanzarotta/bufexplorer'
" }}}

" {{{ NerdTree
Plug 'scrooloose/nerdtree'
" }}}

" {{{ Airline
Plug 'bling/vim-airline'
	let g:airline_theme='dark'
	let g:airline_powerline_fonts=1
" }}}

" {{{ Fugitive
Plug 'tpope/vim-fugitive'
" }}}

" {{{ Gruvbox
Plug 'morhetz/gruvbox'
" }}}

" {{{ Multi Cursor
Plug 'terryma/vim-multiple-cursors'
"}}}

" {{{ Visual Star Search
Plug 'bronson/vim-visual-star-search'
" }}}

" {{{ TagBar
Plug 'majutsushi/tagbar'
" }}}

" {{{ FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

if executable('rg')
  let $FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --follow --glob "!.git/*"'
endif

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
\ 'header': ['fg', 'Comment'] }

nmap <silent> <C-p> :FZF<CR>
" }}}

" {{{ Grepper
"Plug 'mhinz/vim-grepper'
"    let g:grepper = {
"        \ 'tools': ['rg'],
"        \ 'rg':        { 'grepprg':    'rg -H --ignore-file --no-heading --vimgrep --no-ignore-vcs',
"        \                'grepformat': '%f:%l:%c:%m',
"        \                'escape':     '\^$.*+?()[]{}|' }
"        \ }
" }}}

" {{{ Bitbake File Support
Plug 'kergoth/vim-bitbake'
" }}}

" {{{ ESearch
Plug 'eugen0329/vim-esearch'
    let g:esearch = {
    \  'adapter':       'rg',
    \  'backend':       'nvim',
    \  'out':           'win',
    \  'batch_size':    1000,
    \  'use':           ['visual', 'hlsearch', 'word_under_cursor'],
    \ }
    let g:esearch#adapter#rg#options = '--no-ignore-vcs --ignore-file ".$HOME."/.ignore -i --hidden'
    let g:esearch#out#win#open = 'vertical botright new'
    let g:esearch#out#win#buflisted = 1
    let g:esearch#util#trunc_omission = '|'
" }}}

" {{{ Gitgutter
Plug 'airblade/vim-gitgutter'
" }}}

" Required:
filetype plugin indent on

call plug#end()

" vim: set foldmethod=marker:
