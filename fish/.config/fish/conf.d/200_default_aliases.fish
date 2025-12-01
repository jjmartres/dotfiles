alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../../'
alias ..... 'cd ../../../../'

alias l 'eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first --show-symlinks'
alias ll 'eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -l --git -h'
alias la 'eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a'
alias lla 'eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a -l --git -h'
alias ls l

alias f 'fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'

alias mkdir 'mkdir -pv'
alias top btop
alias c clear
alias xa exit
alias h history
alias grep 'grep --color=auto'

alias bluetooth_restart 'blueutil -p 0 && blueutil -p 1'

alias finder spf

alias meet 'yabai -m rule --apply app="Chrome" space=2'
alias unmeet 'yabai -m rule --apply app="Chrome" space=6'
