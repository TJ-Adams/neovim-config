if filereadable(glob("~/.vimrc"))
	source ~/.vimrc
elseif filereadable(glob("~/.vim/vimrc"))
	source ~/.vim/vimrc
endif

