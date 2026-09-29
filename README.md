# doji's Arch + Hyprland dotfiles

Personal configuration for an Arch Linux workstation running Hyprland and the
[ML4W dotfiles](https://github.com/mylinuxforwork/dotfiles) base.

This repository is the source of truth for the active configuration. GNU Stow
links the files under `com.ml4w.dotfiles/` into `$HOME`; the directory name is
kept for compatibility with existing ML4W paths.

## Fresh-machine setup

The full installer supports Arch Linux. Install Git and GNU Stow, clone this
repository, then run the bootstrap script:

```bash
sudo pacman -S --needed git stow
git clone git@github.com:doji-wong/dotfiles.git ~/.mydotfiles
~/.mydotfiles/install.sh
```

If SSH authentication is not configured, clone with HTTPS instead:

```bash
git clone https://github.com/doji-wong/dotfiles.git ~/.mydotfiles
```

The script installs packages listed in `packages/pacman.txt`, optionally
installs the AUR and Flatpak lists when `yay` and `flatpak` are available, and
links the files into `$HOME` using GNU Stow. Existing conflicting files are
moved to a timestamped directory under `~/.dotfiles-backup/` before linking.

Use `~/.mydotfiles/install.sh --dotfiles-only` when the software is already
installed or when running on a non-Arch system. This skips package installation
but still requires GNU Stow.

Before installing, use `--dry-run` to inspect the planned Stow operation and
package commands without changing files. Add `--yes` only for an unattended
run after reviewing the dry-run output:

```bash
~/.mydotfiles/install.sh --dry-run
~/.mydotfiles/install.sh --yes
```

The installer may update the system package database with `pacman -Syu`.
Review the package manifests before accepting that operation.

## Updating an existing machine

Pull the latest changes, inspect the dry run, then re-run the installer:

```bash
cd ~/.mydotfiles
git pull --ff-only
./install.sh --dotfiles-only --dry-run
./install.sh --dotfiles-only
```

If the new links replace files, the previous versions are retained under
`~/.dotfiles-backup/`. Do not delete that directory until the desktop session
has been checked.

## Validation and troubleshooting

Run the repository check after editing configuration or before committing:

```bash
./scripts/dotfiles-check.sh
```

It verifies required configuration files, Bash syntax, removed-script
references, and hard-coded paths tied to this machine. If Stow reports a
conflict, stop and inspect the target file and the matching backup directory;
do not force the link manually until you know which copy should win.

Log out and back in after installation so the full Hyprland session reloads.

## Repository layout

| Path | Purpose |
| --- | --- |
| `com.ml4w.dotfiles/` | Stow package containing the active configuration |
| `packages/` | Official, AUR, and Flatpak package manifests |
| `install.sh` | Package installation, backup, and Stow orchestration |
| `scripts/dotfiles-check.sh` | Static repository validation |
| `docs/` | Ownership and maintenance boundaries |
| `tasks/` | Migration plan and remaining work |

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
