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

## System stats (sysstats)

Local history of CPU / RAM / disk load, top processes and biggest folders, with HTML reports.
Package `sysstats/` (script `~/.local/bin/sysstats`, stdlib Python, system `/usr/bin/python3`)
and fish function `sysreport` (with completion).

- Every 5 min (`local.sysstats.collect`): load, CPU, RAM, swap, disk, top 25 processes, and the
  process tree (pid/ppid, user, state, threads, full command; CPU measured from the CPU time used
  between samples). Significant processes are kept with their whole parent chain (30 days).
- Daily at 23:55 (`local.sysstats.daily`): folder size scan + report of the day.
- Data: `~/.local/share/sysstats/` (`stats.db`, `reports/`, `*.log`), kept 90 days.
- Report: Catppuccin Latte / Macchiato, key figures, charts, rankings, biggest folders, and an
  htop/btop-like process explorer: parent → child tree with subtree totals (Σ), period or
  snapshot mode (slider, or click a chart), sort, filter, per-process detail with sparklines.

`bootstrap.sh` enables it automatically (post-stow hook). On an existing machine:

```fish
stow -R sysstats fish
sysreport install        # writes and loads the launchd agents
```

```fish
sysreport                # report of the last 24 h (opens it)
sysreport --days 7       # or --hours N, --date YYYY-MM-DD, --no-open
sysreport last           # last runs and launchd state
sysreport open           # open the reports folder
sysreport latest         # open the latest report
sysreport uninstall      # remove the launchd agents (keeps the data)
```

macOS may ask once to let `python3` access Documents / Desktop / Downloads during the folder scan.

## License

MIT / BSD
