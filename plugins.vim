call plug#begin('~/.vim/plugged')

if has('win32')
  let s:path_sep = '\\'
else
  let s:path_sep = '/'
endif

" {{{ Buffer Explorer
Plug 'jlanzarotta/bufexplorer'
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

let g:gruvbox_contrast_dark="hard"
set bg=dark
" }}}

" {{{ Multi Cursor
Plug 'terryma/vim-multiple-cursors'
"}}}

" {{{ Visual Star Search
Plug 'bronson/vim-visual-star-search'
" }}}

" {{{ TagBar
Plug 'majutsushi/tagbar'

" <Leader>+t to open Tagbar
nmap <leader>t :TagbarToggle<CR>
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

" {{{ Illuminate
Plug 'RRethy/vim-illuminate'
    let g:Illuminate_delay = 150
    let g:Illuminate_ftblacklist = ['nerdtree']
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

"{{{ COC
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
au CursorHold * silent call CocActionAsync('highlight')
au CursorHoldI * silent call CocActionAsync('showSignatureHelp')
nmap <silent> K :call CocActionAsync('doHover')<cr>
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> <C-y> :CocList symbols<cr>
nmap <silent> [f :CocPrev<cr>
nmap <silent> ]f :CocNext<cr>
nmap <silent> [c <Plug>(coc-git-prevchunk)
nmap <silent> ]c <Plug>(coc-git-nextchunk)
nmap <silent> <leader>cs :CocCommand git.chunkStage<cr>
nmap <silent> <leader>cp :CocCommand git.chunkInfo<cr>
nmap <silent> <leader>cu :CocCommand git.chunkUndo<cr>

" use <tab> for trigger completion and navigate to the next completion item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use Tab and Shift+Tab to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use Enter to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Make Enter pick first completion item and confirm when no items have been
" selected
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Close the preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


Plug 'jackguo380/vim-lsp-cxx-highlight'
"}}}

"{{{ coc-explorer coc-plugin
let g:coc_explorer_global_presets = {
\   '.vim': {
\      'root-uri': '~/.vim',
\   },
\   'floating': {
\      'position': 'floating',
\   },
\   'floatingLeftside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'floatingRightside': {
\      'position': 'floating',
\      'floating-position': 'right-center',
\      'floating-width': 50,
\   },
\   'simplify': {
\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }

" Use preset argument to open it
nmap <leader>o :CocCommand explorer<CR>
nmap <leader>el :CocCommand explorer --preset floatingRightside<CR>
nmap <leader>eh :CocCommand explorer --preset floatingLeftside<CR>

" List all presets
nmap <space>ea :CocList explPresets<CR>
"}}}

" Required:
filetype plugin indent on

call plug#end()

" vim: set foldmethod=marker:
