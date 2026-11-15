function update --description "Update Neovim plugins, Homebrew packages, and system (macOS & Linux)"
    set -l dotfiles_path "$HOME/Repositories/perso/dotfiles"
    set -l os (uname)
    set -l failed

    # Color codes for better readability
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l normal (set_color normal)

    # Check if 'os' argument is passed
    if test (count $argv) -gt 0; and test "$argv[1]" = "os"
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
    echo $blue"  Starting System Update"$normal
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
                sudo softwareupdate --install "Command Line Tools for Xcode"
                and echo $green"✓ Command Line Tools updated"$normal
                or begin
                    echo $red"✗ Command Line Tools update failed"$normal
                    set -a failed "Command Line Tools"
                end
            else
                echo $green"✓ Command Line Tools already up to date"$normal
            end
        case Linux
            echo $yellow"➤ Updating APT packages..."$normal
            sudo apt update
            and sudo apt upgrade -y
            and sudo apt autoremove --purge -y
            and echo $green"✓ APT packages updated"$normal
            or begin
                echo $red"✗ APT update failed"$normal
                set -a failed "APT"
            end

            if type -q flatpak
                echo $yellow"➤ Updating Flatpak apps..."$normal
                flatpak update -y
                and flatpak uninstall --unused -y
                and echo $green"✓ Flatpak apps updated"$normal
                or begin
                    echo $red"✗ Flatpak update failed"$normal
                    set -a failed "Flatpak"
                end
            end

            if type -q snap
                echo $yellow"➤ Updating Snap packages..."$normal
                sudo snap refresh
                and echo $green"✓ Snap packages updated"$normal
                or begin
                    echo $red"✗ Snap update failed"$normal
                    set -a failed "Snap"
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
