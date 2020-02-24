" TJ's minimal .vimrc

"{{{ BASIC VIM OPTIONS
" This is not an exhaustive list of options it is simply the
" ones that I like to use. I have commented out the ones that
" I feel would be user preference

" Compatibility options
set nocompatible    " No (vi) compatibility mode. Necessary to use vim features
set mouse=a         " Enable mouse support
set backspace=2     " Fixes backspace cross-platform

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
set nowrap

" Update at 300ms so coc works smoother
set updatetime=300

" Uncomment if you want virtual spaces
"set virtualedit=all

" tab/spaces configs
"set expandtab " use tabs instead of spaces
set tabstop=8
set softtabstop=4
"set shiftround
set shiftwidth=4
set noexpandtab

" Set the unnamed register as the clipboard. Whatever gets yanked
" will be available outside of the current vim session
set clipboard=unnamedplus

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

" Allow modified buffers to be hidden
set hidden
"}}}

" Map leader to space instead of \
nnoremap <SPACE> <Nop>
let mapleader=" "

"{{{ PLUGINS
source ~/.vim/plugins.vim
"}}}

"{{{ CUSTOM KEY BINDINGS
" Disable arrow keys in normal mode
nnoremap <DOWN>  <NOP>
nnoremap <UP>    <NOP>
nnoremap <LEFT>  <NOP>
nnoremap <RIGHT> <NOP>

" Add buffer navigation commands
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bw :bp <BAR> bd #<CR>
nmap <leader>be :BufExplorer<CR>

" Add window navigation commands
nmap <leader>wl :wincmd l<CR>
nmap <leader>wh :wincmd h<CR>
nmap <leader>wk :wincmd k<CR>
nmap <leader>wj :wincmd j<CR>

"}}}

"{{{ Miscellaneous
" If there is a .project.vim in the pwd when vim is
" started then source it. This is useful for setting
" project specific indentation options, spaces vs. tabs
" etc.
if filereadable(".project.vim")
	source .project.vim
endif

" This will prevent search under cursor from jumping
" to the next match
nnoremap * :keepjumps normal! mi*`i<CR>

"}}}

"{{{ Auto relative line numbers
set number relativenumber

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
"}}}

"{{{ Color Scheme
colorscheme gruvbox
"}}}

" vim: set foldmethod=marker:
