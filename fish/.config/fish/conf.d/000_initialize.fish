# Set default theme
if type -q defaults
    defaults read -g AppleInterfaceStyle &>/dev/null
    if test $status -eq 0
        set -gx DEFAULT_THEME catppuccin-macchiato
    else
        set -gx DEFAULT_THEME catppuccin-latte
    end
else
    set -gx DEFAULT_THEME catppuccin-latte
end
