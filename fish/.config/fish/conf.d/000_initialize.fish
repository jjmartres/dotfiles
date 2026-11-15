# Initialize Homebrew (macOS or Linux)
for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew $HOME/.linuxbrew/bin/brew
    if test -x $brew_bin
        $brew_bin shellenv | source
        break
    end
end
set --erase brew_bin

# Set default theme
set -gx DEFAULT_THEME catppuccin-latte
if type -q defaults
    defaults read -g AppleInterfaceStyle &>/dev/null
    if test $status -eq 0
        set -gx DEFAULT_THEME catppuccin-macchiato
    end
else if type -q gsettings
    if string match -q "*dark*" (gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        set -gx DEFAULT_THEME catppuccin-macchiato
    end
end
