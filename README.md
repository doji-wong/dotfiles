# doji's Arch + Hyprland dotfiles

Personal configuration for an Arch Linux workstation running Hyprland and the
[ML4W dotfiles](https://github.com/mylinuxforwork/dotfiles) base.

## Fresh-machine setup

Install Git, clone this repository, then run the bootstrap script:

```bash
sudo pacman -S --needed git
git clone git@github.com:doji-wong/dotfiles.git ~/.mydotfiles
~/.mydotfiles/install.sh
```

The script installs the official packages, optionally installs AUR and Flatpak
packages, and links the files into `$HOME` using GNU Stow. Existing conflicting
files are moved to a timestamped directory under `~/.dotfiles-backup/`.

Use `~/.mydotfiles/install.sh --dotfiles-only` when the software is already
installed. Package installation is intended for Arch Linux.

Use `--dry-run` to inspect the planned Stow operation without changing files,
and add `--yes` for unattended installation after reviewing the command.

Run `./scripts/dotfiles-check.sh` after editing the configuration. It checks
required files, Bash syntax, stale references, and user-specific absolute paths.

See [`docs/OWNERSHIP.md`](docs/OWNERSHIP.md) for the boundary between files
owned by this repository and optional external applications.

## What is intentionally excluded

SSH and GPG keys, browser/application profiles, shell histories, credentials,
tokens, caches, logs, and machine-specific monitor settings are not backed up.
Secrets should be transferred separately with an encrypted password manager or
another secure channel.

Large wallpaper files are included because they are part of the desktop theme.

Generated colors, wallpaper selections, monitor layouts, and runtime state are
machine-local. The repository tracks portable defaults and templates; generated
files may appear modified after running Matugen or desktop tools.
