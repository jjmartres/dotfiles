function update --description "Update Neovim plugins, Homebrew packages, and system"
    set -l dotfiles_path "$HOME/Repositories/perso/dotfiles"

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
        echo $yellow"➤ Installing macOS updates..."$normal
        echo $red"⚠ System will restart after installation!"$normal
        sudo softwareupdate --install --os-only --restart
        return
    end

    echo $blue"═══════════════════════════════════════"$normal
    echo $blue"  Starting System Update"$normal
    echo $blue"═══════════════════════════════════════"$normal
    echo

    # Update Neovim plugins
    echo $yellow"➤ Updating Neovim plugins..."$normal
    if nvim --headless "+Lazy! sync" +qa
        echo $green"✓ Neovim plugins updated"$normal
    else
        echo $red"✗ Neovim update failed"$normal
    end

    echo $yellow"➤ Updating Mason packages..."$normal
    if nvim --headless +"Lazy load mason.nvim" +"MasonUpdate" +qa
        echo $green"✓ Mason packages updated"$normal
    else
        echo $red"✗ Mason update failed"$normal
    end
    echo

    # Update Command Line Tools
    echo $yellow"➤ Checking Command Line Tools..."$normal
    if softwareupdate --list | grep -q "Command Line Tools"
        sudo softwareupdate --install "Command Line Tools for Xcode"
        and echo $green"✓ Command Line Tools updated"$normal
        or echo $red"✗ Command Line Tools update failed"$normal
    else
        echo $green"✓ Command Line Tools already up to date"$normal
    end
    echo

    # Update asdf plugins
    echo $yellow"➤ Updating asdf plugins..."$normal
    if asdf plugin update --all
        echo $green"✓ Asdf plugins updated"$normal
    else
        echo $red"✗ Asdf plugins update failed"$normal
    end
    echo

    # Update spec-kit from github
    echo $yellow"➤ Updating Github Spec-kit..."$normal
    uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
    and echo $green"✓ Spec-kit updated"$normal
    or echo $red"✗ Spec-kit update failed"$normal
    echo

    # Set Homebrew to not require tap trust to prevent bundle/cleanup failures
    set -x HOMEBREW_NO_REQUIRE_TAP_TRUST 1

    # Update Homebrew
    echo $yellow"➤ Updating Homebrew packages..."$normal

    brew update
    and echo $green"✓ Brew updated"$normal
    or echo $red"✗ Brew update failed"$normal

    # Run brew bundle if Brewfile exists
    if test -f "$dotfiles_path/Brewfile"
        brew bundle --file="$dotfiles_path/Brewfile"
        and echo $green"✓ Brew bundle completed"$normal
        or echo $red"✗ Brew bundle failed"$normal
    else
        echo $yellow"⚠ Brewfile not found at $dotfiles_path"$normal
    end

    brew upgrade
    and echo $green"✓ Packages upgraded"$normal
    or echo $red"✗ Package upgrade failed"$normal

    # Check if brew-cask-upgrade is installed
    if brew tap | grep -q buo/cask-upgrade
        brew cu --all --yes --cleanup
        and echo $green"✓ Casks upgraded"$normal
        or echo $red"✗ Cask upgrade failed"$normal
    else
        echo $yellow"⚠ brew-cask-upgrade not installed (run: brew tap buo/cask-upgrade)"$normal
    end

    brew cleanup --prune=all
    set -l cleanup_status $status

    if test -f "$dotfiles_path/Brewfile"
        brew bundle cleanup --file="$dotfiles_path/Brewfile" --force
        if test $status -ne 0
            set cleanup_status 1
        end
    end

    if test $cleanup_status -eq 0
        echo $green"✓ Cleanup completed"$normal
    else
        echo $red"✗ Cleanup failed"$normal
    end

    brew doctor
    if test $status -eq 0
        echo $green"✓ Brew doctor complete!"$normal
    else
        echo $yellow"⚠ Brew doctor found warnings"$normal
    end

    echo
    echo $blue"═══════════════════════════════════════"$normal
    echo $green"✓ System update complete!"$normal
    echo $blue"═══════════════════════════════════════"$normal
end
