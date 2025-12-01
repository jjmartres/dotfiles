# jjmartres dotfiles

This repository contains everything to bootstrap my Macbook Pro.

## Preparations

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

## License

MIT / BSD
