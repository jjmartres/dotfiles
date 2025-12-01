## install homebrew
if ! which brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi;

PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH

## update brew
brew update

## upgrade all brew
brew upgrade

## install everything in Brewfile
brew bundle

## remove outdated versions from the cellar
brew cleanup
