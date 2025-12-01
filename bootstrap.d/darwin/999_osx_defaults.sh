# close any system preference windows first
osascript -e 'tell application "System Preferences" to quit'

# become root
sudo -v

# stay root
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

## System

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

## Trackpad, keyboard
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# use keyboard navigation to move focus between controls (tab-tab for everything)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Non-breaking spaces: https://superuser.com/questions/78245/how-to-disable-the-option-space-key-combination-for-non-breaking-spaces
mkdir -p ~/Library/KeyBindings
cat >~/Library/KeyBindings/DefaultKeyBinding.dict <<EOF
{
"~ " = ("insertText:", " ");
}
EOF

## UI
## Set specific feature for Yabai
## 1. In the Desktop & Dock tab, inside the Mission Control pane, the setting "Automatically rearrange Spaces based on most recent use" should be disabled for commands that rely on the ordering of spaces to work reliably.
## 2. In the Desktop & Dock tab, inside the Desktop & Stage Manager pane, the setting "Show Items On Desktop" should be enabled for display and space focus commands to work reliably in multi-display configurations.
## 3. In the Desktop & Dock tab, inside the Desktop & Stage Manager pane, the setting "Click wallpaper to reveal Desktop" should be set to "Only in Stage Manager" for display and space focus commands to work reliably.
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.WindowManager GloballyEnabled -bool true
defaults write com.apple.universalaccess reduceMotion -bool false

## Touch ID
sudo sed '$ s/^#//' /etc/pam.d/sudo_local

## Screen

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## Locations

# Screenshot location
test -d "${HOME}/Pictures/screenshots" || mkdir -p "${HOME}/Pictures/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/screenshots"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes
