#!bin/zsh

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# keyboard
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 1
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

# mouse
defaults write -g com.apple.mouse.scaling 3
defaults write -g com.apple.scrollwheel.scaling -int 1

# dock
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -float 128
defaults write com.apple.dock tilesize -float 40
defaults write com.apple.dock autohide -bool true

# trackpad
defaults write -g AppleEnableSwipeNavigateWithScrolls -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
