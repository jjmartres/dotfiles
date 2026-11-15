function update --description "Update Neovim plugins, Homebrew packages, and system (macOS & Linux)"
    set -l dotfiles_path "$HOME/Repositories/perso/dotfiles"
    set -l os (uname)
    set -l failed
    set -l mode default
    set -l unattended 0

    # Color codes for better readability
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l normal (set_color normal)

    for arg in $argv
        switch $arg
            case os
                set mode os
            case --unattended
                set unattended 1
            case -h --help
                echo "Usage: update [os] [--unattended]"
                echo "  os            Install OS updates and reboot"
                echo "  --unattended  Never prompt (for cron): skip sudo steps unless sudo works without a password"
                return 0
            case '*'
                echo $red"✗ Unknown argument: $arg"$normal
                return 1
        end
    end

    if test $mode = os; and test $unattended -eq 1
        echo $red"✗ 'update os' reboots the machine and cannot run unattended"$normal
        return 1
    end

    # sudo strategy: interactive by default; in unattended mode only use
    # sudo if it works without a password (e.g. NOPASSWD sudoers rule)
    set -l can_sudo 1
    set -l sudo_cmd sudo
    if test $unattended -eq 1
        set sudo_cmd sudo -n
        if not sudo -n true 2>/dev/null
            set can_sudo 0
        end
    end

    # OS updates + reboot
    if test $mode = os
        echo $blue"═══════════════════════════════════════"$normal
        echo $blue"  Installing OS Updates and Restarting"$normal
        echo $blue"═══════════════════════════════════════"$normal
        echo
        switch $os
            case Darwin
                echo $yellow"➤ Installing macOS updates..."$normal
                echo $red"⚠ System will restart after installation!"$normal
                sudo softwareupdate --install --os-only --restart
            case Linux
                echo $yellow"➤ Installing Linux updates..."$normal
                echo $red"⚠ System will restart after installation!"$normal
                sudo apt update
                and sudo apt full-upgrade -y
                and sudo apt autoremove --purge -y
                or begin
                    echo $red"✗ APT upgrade failed — not restarting"$normal
                    return 1
                end
                if type -q fwupdmgr
                    echo $yellow"➤ Installing firmware updates..."$normal
                    sudo fwupdmgr refresh --force
                    sudo fwupdmgr update -y --no-reboot-check
                end
                sudo systemctl reboot
            case '*'
                echo $red"✗ Unsupported OS: $os"$normal
                return 1
        end
        return
    end

    echo $blue"═══════════════════════════════════════"$normal
    echo $blue"  Starting System Update ("(date '+%Y-%m-%d %H:%M')")"$normal
    echo $blue"═══════════════════════════════════════"$normal
    echo

    # Update Neovim plugins
    if type -q nvim
        echo $yellow"➤ Updating Neovim plugins..."$normal
        nvim --headless "+Lazy! sync" +qa
        and echo $green"✓ Neovim plugins updated"$normal
        or begin
            echo $red"✗ Neovim update failed"$normal
            set -a failed "Neovim plugins"
        end

        echo $yellow"➤ Updating Mason packages..."$normal
        nvim --headless +"Lazy load mason.nvim" +"MasonUpdate" +qa
        and echo $green"✓ Mason packages updated"$normal
        or begin
            echo $red"✗ Mason update failed"$normal
            set -a failed "Mason"
        end
    else
        echo $yellow"⚠ nvim not found, skipping Neovim updates"$normal
    end
    echo

    # OS-level package updates
    switch $os
        case Darwin
            echo $yellow"➤ Checking Command Line Tools..."$normal
            if softwareupdate --list | grep -q "Command Line Tools"
                if test $can_sudo -eq 1
                    $sudo_cmd softwareupdate --install "Command Line Tools for Xcode"
                    and echo $green"✓ Command Line Tools updated"$normal
                    or begin
                        echo $red"✗ Command Line Tools update failed"$normal
                        set -a failed "Command Line Tools"
                    end
                else
                    echo $yellow"⚠ Command Line Tools update available — skipped (sudo needs a password)"$normal
                end
            else
                echo $green"✓ Command Line Tools already up to date"$normal
            end
        case Linux
            if test $can_sudo -eq 1
                echo $yellow"➤ Updating APT packages..."$normal
                $sudo_cmd apt update
                and $sudo_cmd env DEBIAN_FRONTEND=noninteractive apt upgrade -y
                and $sudo_cmd env DEBIAN_FRONTEND=noninteractive apt autoremove --purge -y
                and echo $green"✓ APT packages updated"$normal
                or begin
                    echo $red"✗ APT update failed"$normal
                    set -a failed "APT"
                end
            else
                echo $yellow"⚠ APT skipped (sudo needs a password)"$normal
            end

            if type -q flatpak
                echo $yellow"➤ Updating Flatpak apps..."$normal
                flatpak update -y --noninteractive
                and flatpak uninstall --unused -y --noninteractive
                and echo $green"✓ Flatpak apps updated"$normal
                or begin
                    echo $red"✗ Flatpak update failed"$normal
                    set -a failed "Flatpak"
                end
            end

            if type -q snap
                if test $can_sudo -eq 1
                    echo $yellow"➤ Updating Snap packages..."$normal
                    $sudo_cmd snap refresh
                    and echo $green"✓ Snap packages updated"$normal
                    or begin
                        echo $red"✗ Snap update failed"$normal
                        set -a failed "Snap"
                    end
                else
                    echo $yellow"⚠ Snap skipped (sudo needs a password)"$normal
                end
            end
    end
    echo

    # Update asdf plugins
    if type -q asdf
        echo $yellow"➤ Updating asdf plugins..."$normal
        asdf plugin update --all
        and echo $green"✓ Asdf plugins updated"$normal
        or begin
            echo $red"✗ Asdf plugins update failed"$normal
            set -a failed "asdf plugins"
        end
        echo
    end

    # Update spec-kit from github
    if type -q uv
        echo $yellow"➤ Updating Github Spec-kit..."$normal
        uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
        and echo $green"✓ Spec-kit updated"$normal
        or begin
            echo $red"✗ Spec-kit update failed"$normal
            set -a failed "Spec-kit"
        end
        echo
    end

    if type -q brew
        # Disable interactive prompts during Homebrew operations
        set -lx HOMEBREW_NO_ASK 1

        # Disable gcloud CLI prompts during updates
        set -lx CLOUDSDK_CORE_DISABLE_PROMPTS 1

        echo $yellow"➤ Updating Homebrew packages..."$normal

        brew update
        and echo $green"✓ Brew updated"$normal
        or begin
            echo $red"✗ Brew update failed"$normal
            set -a failed "brew update"
        end

        # Install missing Brewfile entries only; upgrades happen once below
        if test -f "$dotfiles_path/Brewfile"
            brew bundle --no-upgrade --file="$dotfiles_path/Brewfile"
            and echo $green"✓ Brew bundle completed"$normal
            or begin
                echo $red"✗ Brew bundle failed"$normal
                set -a failed "brew bundle"
            end
        else
            echo $yellow"⚠ Brewfile not found at $dotfiles_path"$normal
        end

        brew upgrade
        and echo $green"✓ Packages upgraded"$normal
        or begin
            echo $red"✗ Package upgrade failed"$normal
            set -a failed "brew upgrade"
        end

        # Upgrade casks (including auto-updating casks) — macOS only
        if test $os = Darwin
            echo $yellow"➤ Upgrading casks..."$normal
            brew upgrade --cask --greedy-auto-updates
            and echo $green"✓ Casks upgraded"$normal
            or begin
                echo $red"✗ Cask upgrade failed"$normal
                set -a failed "brew upgrade --cask"
            end
        end

        brew cleanup --prune=all
        set -l cleanup_status $status

        # Brewfile is the source of truth on macOS only: on Linux, cleanup
        # would uninstall Linux-specific formulae missing from the Brewfile
        if test $os = Darwin; and test -f "$dotfiles_path/Brewfile"
            brew bundle cleanup --file="$dotfiles_path/Brewfile" --force
            or set cleanup_status 1
        end

        if test $cleanup_status -eq 0
            echo $green"✓ Cleanup completed"$normal
        else
            echo $red"✗ Cleanup failed"$normal
            set -a failed "brew cleanup"
        end

        brew doctor
        and echo $green"✓ Brew doctor complete!"$normal
        or echo $yellow"⚠ Brew doctor found warnings"$normal
    else
        echo $yellow"⚠ brew not found, skipping Homebrew updates"$normal
    end

    echo
    echo $blue"═══════════════════════════════════════"$normal
    if test (count $failed) -eq 0
        echo $green"✓ System update complete!"$normal
        echo $blue"═══════════════════════════════════════"$normal
        return 0
    end

    echo $yellow"⚠ System update finished with "(count $failed)" failed step(s):"$normal
    for step in $failed
        echo $red"  ✗ $step"$normal
    end
    echo $blue"═══════════════════════════════════════"$normal
    return 1
end
