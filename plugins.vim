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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
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
  let $FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
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
    let g:esearch#adapter#rg#options = '--ignore-file ".$HOME."/.ignore -i --hidden'
    let g:esearch#out#win#open = 'vertical botright new'
    let g:esearch#out#win#buflisted = 1
    let g:esearch#util#trunc_omission = '|'
" }}}

" {{{ Gitgutter
Plug 'airblade/vim-gitgutter'
" }}}

" {{{ Illuminate
Plug 'RRethy/vim-illuminate'
    let g:Illuminate_delay = 150
    let g:Illuminate_ftblacklist = ['nerdtree']
" }}}

" {{{ puppet-syntax-vim
Plug 'puppetlabs/puppet-syntax-vim'
" }}}

" {{{ Eunuch
Plug 'tpope/vim-eunuch'
" }}}

" {{{ Obsession
Plug 'tpope/vim-obsession'
" }}}

" {{{ vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
" }}}

" {{{ vim-tmux-focus-events
Plug 'tmux-plugins/vim-tmux-focus-events'
" }}}

" {{{ vim-gutentags
Plug 'ludovicchabant/vim-gutentags'
" }}}

" Required:
filetype plugin indent on

call plug#end()

" vim: set foldmethod=marker:
