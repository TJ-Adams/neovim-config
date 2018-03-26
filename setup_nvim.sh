#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

confirm() {
    read -p "$1 [y/N]? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return 0
    fi
    return 1
}

if sudo echo "--- Install Nvim ---"; then
    # Neovim
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get -y update

    if sudo apt-get install neovim; then
        echo
        echo
	confirm "Would you like to update alternatives for nvim (provide vi, vim, editor)" && \
        sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
        sudo update-alternatives --config vi && \
        sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 && \
        sudo update-alternatives --config vim && \
        sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 && \
        sudo update-alternatives --config editor
    fi
else
    echo "Sudo required to run this script"
    exit 1
fi

echo
echo

#
# Nvim/Vim compatibility symlink
#
echo "--- Create Nvim/Vim compatibility symlink ---"
if [[ ! -d $HOME/.config/nvim ]]; then
    mkdir -p $HOME/.config && echo " - Creating symlink $(ln -sv $HOME/.vim $HOME/.config/nvim)"
else
    echo " - Up to date"
fi
echo

