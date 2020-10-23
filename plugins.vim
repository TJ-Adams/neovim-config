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

" {{{ Color Schemes
Plug 'morhetz/gruvbox'

let g:gruvbox_contrast_dark="hard"

Plug 'rafi/awesome-vim-colorschemes'
" }}}

" {{{ Multi Cursor
Plug 'terryma/vim-multiple-cursors'
"}}}

" {{{ Visual Star Search
Plug 'bronson/vim-visual-star-search'
" }}}

" {{{ Vista.vim
Plug 'liuchengxu/vista.vim'

" Use coc as the default to gather symbols etc from
let g:vista_default_executive = 'coc'

" Mappings to close or Open Vista
nmap <leader>vo :Vista<CR>
nmap <leader>vc :Vista!<CR>

" Use specified unicode for icons
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "enum": "\uf77a",
\   "variable": "\u03c7",
\   "enummember": "#",
\  }
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
    let g:esearch = {}

    "Use RipGrep for my searches
    let g:esearch.adapter = 'rg'

    " Use regex matching with the smart case mode by default and avoid matching text-objects.
    let g:esearch.regex   = 1
    let g:esearch.textobj = 0
    let g:esearch.case    = 'smart'

    " Set the initial pattern content using the highlighted search pattern (if
    " v:hlsearch is true), or the last searched pattern.
    let g:esearch.prefill = ['hlsearch', 'last']

    " Open the search window in a vertical split and reuse it for all searches.
    let g:esearch.name = '[esearch]'
    let g:esearch.win_new = {esearch -> esearch#buf#goto_or_open(esearch.name, 'vnew')}

    " Save applied changes if :write! with '!' was used. Open modified buffers
    " in background otherwise.
    let g:esearch.write_cb = {buf, bang -> bang ? buf.write(bang) : buf.open('')}

    "   Keymap |     What it does
    " ---------+---------------------------------------------------------------------------------------------
    "    yf    | Yank a hovered file absolute path.
    "    t     | Use a custom command to open the file in a tab.
    "    +     | Render [count] more lines after a line with matches. Ex: + adds 1 line, 10+ adds 10.
    "    -     | Render [count] less lines after a line with matches. Ex: - hides 1 line, 10- hides 10.
    "    gq    | Populate QuickFix list using results of the current pattern search.
    "    gsp   | Sort the results by path. NOTE that it's search util-specific.
    "    gsd   | Sort the results by modification date. NOTE that it's search util-specific.

    " Each definition contains nvim_set_keymap() args: [{modes}, {lhs}, {rhs}].
    let g:esearch.win_map = [
     \ ['n', 'yf',  ':call setreg(esearch#util#clipboard_reg(), b:esearch.filename())<cr>'],
     "\ ['n', 't',   ':call b:esearch.open("NewTabdrop")<cr>'                              ],
     \ ['n', '+',   ':call esearch#init(extend(b:esearch, AddAfter(+v:count1)))<cr>'      ],
     \ ['n', '-',   ':call esearch#init(extend(b:esearch, AddAfter(-v:count1)))<cr>'      ],
     "\ ['n', 'gq',  ':call esearch#init(extend(copy(b:esearch), {"out": "qflist"}))<cr>'  ],
     \ ['n', 'gsp', ':call esearch#init(extend(b:esearch, sort_by_path))<cr>'             ],
     \ ['n', 'gsd', ':call esearch#init(extend(b:esearch, sort_by_date))<cr>'             ],
     \]

    " Helpers to use in keymaps.
    " Funny? The triple curly braces at the end must be spaced out otherwise,
    " it closes out the esearch section
    let g:sort_by_path = {'adapters': {'rg': {'options': '--sort path'} } }
    let g:sort_by_date = {'adapters': {'rg': {'options': '--sort modified'} } }
    " {'backend': 'system'} means synchronous reload using system() call to stay within the
    " same context
    let g:AddAfter = {n -> {'after': b:esearch.after + n, 'backend': 'system'}}

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

"{{{ coc-plugin: coc-explorer
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

"{{{ coc-plugin: coc-lists
nmap <space>cl :CocList<CR>
"}}}

" Required:
filetype plugin indent on

call plug#end()

" vim: set foldmethod=marker:
