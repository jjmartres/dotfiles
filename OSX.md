# jjmartres dotfiles

This repository contains everything to bootstrap my Macbook Pro.

## Preparations

### Git (XCode)

Install it on the command line first, it will ask for permission.

```
xcode-select --install
```

### Sudo

Note: I keep this disabled for improved security, though some sessions may require heavy sudo usage.

```
sudo vim /private/etc/sudoers.d/jjmartres

#jjmartres  ALL=(ALL) NOPASSWD: ALL
```

### Dot files

```console
git clone git@github.com:jjmartres/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
```

Bootstrap setup
```console
sh ./bootstrap.sh
```

## Preferences

These are manual settings as they require user awareness.

### FileVault

Enable Encryption ([required for GitLab team members](https://about.gitlab.com/handbook/business-ops/team-member-enablement/onboarding-access-requests/#full-disk-encryption) and recommended for everyone).
See [here](https://support.apple.com/en-us/HT204837) for detailed instructions.

CLI:

```
sudo fdesetup status

sudo fdesetup enable
```


### Keyboard

`Shortcuts`: Disable Spotlight in preparation for enabling Raycast as default shortcut using `cmd + space`.

### Raycast

Start Raycast from the Applications folder, and change the hotkey to `Cmd+Space`.
Ensure that Spotlight is disabled in the system preferences.

### Finder

`Preferences > Sidebar` and add

- User home
- System root

## Additional Hints

More insights can be found in these lists:

- [Setting examples](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
- [command overview](https://github.com/herrbischoff/awesome-macos-command-line).


## Upgrades

On major version upgrades, binaries might be incompatible or need a local rebuild.
You can enforce a reinstall by running the two commands below, the second command
only reinstalls all application casks.

```
brew reinstall $(brew list)

brew reinstall $(brew list --cask)
```

When Xcode and compilers break, re-install the command line tools.

```
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
```
## License

MIT / BSD
