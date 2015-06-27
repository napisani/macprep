#!/bin/bash
MACPREP_DIR=`dirname $0`


echo 'set backspace=indent,eol,start " backspace over everything in insert mode' >> ~/.vimrc

echo "alias grep='grep --color=auto'" >> ~/.bash_profile
echo "alias fgrep='fgrep --color=auto'" >> ~/.bash_profile
echo "alias egrep='egrep --color=auto'" >> ~/.bash_profile

echo "alias ll='ls -alF'" >> ~/.bash_profile
echo "alias la='ls -A'" >> ~/.bash_profile
echo "alias l='ls -CF'" >> ~/.bash_profile


echo "--> Installing Karabiner"
brew cask install karabiner
rsync -lv "$MACPREP_DIR/config/karabiner/private.xml" ~/Library/Application\ Support/Karabiner/private.xml
sh "$MACPREP_DIR/config/karabiner/import_profile.sh"


echo "--> Installing SVN"
brew install svn