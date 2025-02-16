#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

brew bundle --global

# brew update
# brew bundle --file '~/.Brewfile'
# brew bundle cleanup --force --file '~/.Brewfile'
# brew upgrade
# brew cleanup
