# Disable the fish greeting message
set fish_greeting ""

# Setup brew
if test -d /home/linuxbrew/.linuxbrew # Linux
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
    fish_add_path -g "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" "$HOME/.local/bin" "$HOME/go/bin"

    ! set -q MANPATH; and set MANPATH ''
    set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

    ! set -q INFOPATH; and set INFOPATH ''
    set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

else if test -d /opt/homebrew # MacOS
    eval (/opt/homebrew/bin/brew shellenv)
end

if status is-interactive
    atuin init fish | source
end

# Clear line on CTRL + C
# Sometimes it still doesn't work well enough on node.js scripts :(
bind --preset \cC cancel-commandline

# Extends PATH
fish_add_path -g $HOME/.local/bin \
    $HOMEBREW_PREFIX/share/google-cloud-sdk/bin \
    $HOME/go/bin \
    $HOME/.cargo/bin \
    $HOME/.config/zellij/scripts \
    $HOMEBREW_PREFIX/opt/libpq/bin \
    $HOMEBREW_PREFIX/opt/mysql-client/bin

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Initialize fzf
fzf --fish | source

# Initialize starship
starship init fish | source
starship config palette $DEFAULT_THEME

set -gx LS_COLORS (vivid generate $DEFAULT_THEME)
set -gx EZA_COLORS (vivid generate $DEFAULT_THEME)

# Make spinnaker use spin's completions
complete -c spinnaker -w spin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc' ]
    . '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
end

# Initialize zoxide
zoxide init fish | source
