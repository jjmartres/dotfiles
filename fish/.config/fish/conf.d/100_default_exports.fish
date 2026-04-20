set -gx K9S_CONFIG_DIR "$HOME/.config/k9s"

if test -d /home/linuxbrew/.linuxbrew # Linux
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
else if test -d /opt/homebrew # MacOS
    set -gx HOMEBREW_PREFIX /opt/homebrew
end

$HOMEBREW_PREFIX/bin/yq -i ".k9s.ui.skin = \"$DEFAULT_THEME\"" $K9S_CONFIG_DIR/config.yaml

# FZF THEME
set -gx FZF_DEFAULT_OPTS_CATPUCCIN_LATTE " \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

set -gx FZF_DEFAULT_OPTS_CATPUCCIN_FRAPPE " \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

set -gx FZF_DEFAULT_OPTS_CATPUCCIN_MACCHIATO " \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

set -gx FZF_DEFAULT_OPTS_CATPUCCIN_MOCHA " \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

switch $DEFAULT_THEME
    case catppuccin-latte
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_CATPUCCIN_LATTE"
        set -gx KUBECOLOR_CONFIG "$HOME/.config/kubecolor/catppuccin-latte.yaml"
        set -gx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/latte/sky.yml"
        set -gx BAT_THEME "Catppuccin Latte"
    case catppuccin-frappe
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_CATPUCCIN_FRAPPE"
        set -gx KUBECOLOR_CONFIG "$HOME/.config/kubecolor/catppuccin-frappe.yaml"
        set -gx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/frappe/sky.yml"
        set -gx BAT_THEME "Catppuccin Frappe"
    case catppuccin-macchiato
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_CATPUCCIN_MACCHIATO"
        set -gx KUBECOLOR_CONFIG "$HOME/.config/kubecolor/catppuccin-macchiato.yaml"
        set -gx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/macchiato/sky.yml"
        set -gx BAT_THEME "Catppuccin Macchiato"
    case catppuccin-mocha
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_CATPUCCIN_MOCHA"
        set -gx KUBECOLOR_CONFIG "$HOME/.config/kubecolor/catppuccin-mocha.yaml"
        set -gx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/mocha/sky.yml"
        set -gx BAT_THEME "Catppuccin Mocha"
end

# CTRL-Y to copy the command into clipboard using pbcopy
set -gx FZF_CTRL_R_OPTS " \
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
  --color header:italic \
  --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat (https://github.com/sharkdp/bat)
set -gx FZF_CTRL_T_OPTS " \
  --walker-skip .git,node_modules,target \
  --preview 'bat -n --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
set -gx FZF_ALT_C_OPTS " \
  --walker-skip .git,node_modules,target \
  --preview 'tree -C {}'"

set -gx EDITOR /opt/homebrew/bin/nvim

set -gx KUBE_CONFIG nvim

set -gx ZK_NOTEBOOK_DIR "$HOME/.notes"

set -gx _ZO_DATA_DIR "$HOME/.local/share/zoxide"
