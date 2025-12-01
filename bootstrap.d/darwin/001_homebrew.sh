# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew not installed. Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Attempt to set up Homebrew PATH automatically for this session
  if [ -x "/opt/homebrew/bin/brew" ]; then
    # For Apple Silicon Macs
    echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
    export PATH="/opt/homebrew/bin:$PATH"
  fi
else
  echo "Homebrew is already installed. Getting updates... "
  /opt/homebrew/bin/brew update
  /opt/homebrew/bin/brew doctor
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
  echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
  exit 1
fi

echo ">>> Installing brew packages.."
/opt/homebrew/bin/brew bundle install --file ~/Brewfile

# Get the path to Homebrew's zsh
BREW_ZSH="$(brew --prefix)/bin/zsh"
# Check if Homebrew's zsh is already the default shell
if [ "$SHELL" != "$BREW_ZSH" ]; then
  echo "Changing default shell to Homebrew zsh"
  # Check if Homebrew's zsh is already in allowed shells
  if ! grep -Fxq "$BREW_ZSH" /etc/shells; then
    echo "Adding Homebrew zsh to allowed shells"
    echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
  fi
  # Set the Homebrew zsh as default shell
  chsh -s "$BREW_ZSH"
  echo "Default shell changed to Homebrew zsh."
else
  echo "Homebrew zsh is already the default shell. Skipping configuration."
fi
