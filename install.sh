#!/bin/bash
#Thank you to Mathias Bynens for defining the defaults within his dots repository.
MACPREP_DIR=`dirname $0`

echo "Please set a password for your user"
#change password
#passwd

#install xcode packages
echo "--> installing xcode packages..."
xcode-select --install

read -p "continue after the install finishes [ENTER]"

#install brew
echo "--> installing homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

echo "--> installing coreutils..."
brew tap homebrew/dupes
brew install coreutils

echo "--> installing findutils + bash..."
#install locate, updatedb, etc.
brew install findutils
brew install bash

#give the coreutils precedence over other versions in the path
brew install homebrew/dupes/grep
echo '# give coreutils precedence over other versions in the path' >> ~/.bash_profile
echo 'export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH' >> ~/.bash_profile

#get cask
echo "--> installing cask + chrome..."
brew tap caskroom/cask
brew install brew-cask
brew cask install google-chrome
brew update && brew upgrade brew-cask && brew cleanup

#install quicklook customizations
echo "--> installing quicklook customizations..."
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install webpquicklook
brew cask install suspicious-package

echo "--> installing quicklook sublime-text + iterm2..."
brew cask install sublime-text
brew cask install iterm2

echo "--> installing and personalizing git..."
brew install git
git config --global user.name "napisani"
git config --global user.email "napisani@yahoo.com"
git config --global github.user napisani 
git config --global core.editor "vim" 
git config --global color.ui true 
git config --global push.default simple

echo "--> installing and jenv..."
brew tap jenv/jenv
brew install jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(jenv init -)"' >> ~/.bash_profile

echo "--> installing Java..."
brew cask install java

echo "--> installing the-unarchiver..."
brew cask install the-unarchiver

echo "--> installing node, npm, etc..."
brew install node
brew install npm
npm install yo -g
npm install grunt-cli -g
npm install gulp -g



echo "--> Customizing mac defaults..."
 #mac os customizations
 # Save to HD instead of icloud by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# quit printer when job finishes
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the 'are you sure you want to open this' messages
defaults write com.apple.LaunchServices LSQuarantine -bool false


# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1




# Finder: disable animations
#defaults write com.apple.finder DisableAllAnimations -bool true

# show mounts on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# disable disk verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

#add host entry for my local nas box
sudo -i
echo "192.168.1.250 nas" >> /etc/hosts
exit

#----------------------------------------------------------------

#SSD Tweaks
# Disable local Time Machine snapshots
sudo tmutil disablelocal
# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0
# Remove the sleep image file to save disk space
sudo rm /Private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /Private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /Private/var/vm/sleepimage
# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0


#Other mac defaults
# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Add iOS Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"




# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4


#set iterm theme - may need to be enabled through the preferences after this

rsync -lv "$MACPREP_DIR/config/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist

PREVIOUS_DIR=`pwd`
cd ~
git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git
open "iTerm2-Color-Schemes/schemes/DimmedMonokai.itermcolors"
open "iTerm2-Color-Schemes/schemes/Monokai Soda.itermcolors"
open "iTerm2-Color-Schemes/schemes/Dracula.itermcolors"
git clone https://github.com/sickill/vim-monokai.git
#enable monokai vim color
mkdir -p .vim/colors
cp vim-monokai/colors/monokai.vim .vim/colors/
cat <<EOF >> .vimrc
syntax enable
colorscheme monokai
set backspace=indent,eol,start " backspace over everything in insert mode
EOF
cd "$PREVIOUS_DIR"

cat <<EOF >> ~/.bash_profile

# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Set the bash prompt styling
export PS1="\[$(tput bold)\]\[$(tput setaf 4)\][\[$(tput setaf 5)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 5)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\]]\\$ \[$(tput sgr0)\]"

alias ls="ls --color=auto"
EOF


# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

#Activity Monitor Changes
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0


# App store changes

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true


# Chrome changes
# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false


#---

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

#Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"


###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null



echo "--> Setting up .inputrc and .zshrc"
# in bash shell - allow ^ LEFT ARROW to skip backward and ^ RIGHT ARROW to skip forward
echo '"\e[1;5D": backward-word' >> ~/.inputrc
echo '"\e[1;5C": forward-word' >> ~/.inputrc


# in zsh - allow ^ LEFT ARROW to skip backward and ^ RIGHT ARROW to skip forward
echo "bindkey '^[[1;5C' forward-word" >> ~/.zshrc
echo "bindkey '^[[1;5D' backward-word" >> ~/.zshrc

echo "--> Installing Karabiner"
brew cask install karabiner
rsync -lv "$MACPREP_DIR/config/karabiner/private.xml" ~/Library/Application\ Support/Karabiner/private.xml
sh "$MACPREP_DIR/config/karabiner/import_profile.sh"

echo "--> Installing vim + tree..."
brew install vim --override-system-vi
brew install tree


echo "--> Installing docker + virtualbox..."
#install docker
brew cask install virtualbox
brew install docker
brew install boot2docker
boot2docker init

echo "--> Setting up bash completion..."
#Bash completion
brew install bash-completion

cat <<EOF >> ~/.bash_profile

#Enable bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
EOF

echo "--> Installing idea + webstorm IDEs..."
brew cask install webstorm
brew cask install intellij-idea

echo "--> Installing vpn utilities"
brew cask install tunnelblick
brew cask install private-internet-access

echo "--> Installing skype"
brew cask install skype

echo "--> Installing ssh-copy-id"
brew install ssh-copy-id
echo "--> Generating ssh keys"
ssh-keygen
echo "--> Copying key to NAS"
ssh-copy-id -i ~/.ssh/id_rsa.pub nick@nas

echo "--> Installing Maven"
brew install maven

echo "Java JDKs will need to be installed manually from Oracal"
echo "Please reboot to apply changes..."
