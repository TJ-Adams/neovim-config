" Tim's minimal .vimrc

"{{{ BASIC VIM OPTIONS
" This is not an exhaustive list of options it is simply the
" ones that I like to use. I have commented out the ones that
" I feel would be user preference

" Compatibility options
set nocompatible " No (vi) compatibility mode. Necessary to use vim features
"set mouse=ar     " Enable mouse support
set backspace=2  " Fixes backspace cross-platform

set autoindent   " Enable auto-indentation
set hlsearch     " Highlight searches
set number       " Enable line numbers
set laststatus=2 "Always show status line

" Changes how tab completion on the command line works.
" This is linux style where it completes until there is
" an ambiguity then lists the possibilities
set wildmenu
set wildmode=list:longest

" Uncomment if you want to disable soft wrapping
"set nowrap

" Uncomment if you want virtual spaces
"set virtualedit=all

" tab/spaces configs
"set expandtab " use tabs instead of spaces
"set tabstop=4
"set softtabstop=4
"set shiftround
"set shiftwidth=4

" Whitespace visualization
if has('nvim')
	set listchars=tab:>-,space:∙
else
	set listchars=tab:>- " Vim can only do tabs
endif

set list

"set lazyredraw " Lazy redraw is useful if running complex macros

" Needed to fix cursor drawing issues in terminals
if !has('gui')
	set guicursor=
endif

" C indentation options (Garmin Style)
set cino=^-s,{1s
set cinw=if,else,while,do,for,switch
set cink=0{,0},0),:0#,!^F,o,O,e
"}}}

"{{{ PLUGINS
source ~/.vim/plugins.vim
"}}}

"{{{ CUSTOM KEY BINDINGS
" Disable arrow keys in normal mode
nnoremap <DOWN>  <NOP>
nnoremap <UP>    <NOP>
nnoremap <LEFT>  <NOP>
nnoremap <RIGHT> <NOP>

" Map leader to space instead of \
nnoremap <SPACE> <Nop>
let mapleader=" "

" Add buffer navigation commands
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bw :bp <BAR> bd #<CR>
nmap <leader>be :BufExplorer<CR>
"}}}

"{{{ Miscellaneous
" If there is a .project.vim in the pwd when vim is
" started then source it. This is useful for setting
" project specific indentation options, spaces vs. tabs
" etc.
if filereadable(".project.vim")
	source .project.vim
endif
"}}}

" Add buffer tab line across the top of the window
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"{{{ Auto relative line numbers
set number relativenumber

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
"}}}

colorscheme gruvbox
let g:gruvbox_contrast_dark="hard"
set bg=dark

" vim: set foldmethod=marker:
