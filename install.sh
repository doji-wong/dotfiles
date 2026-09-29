#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_dir="$repo_dir/packages"
dotfiles_only=false
dry_run=false
assume_yes=false

usage() {
    echo "Usage: $0 [--dotfiles-only] [--dry-run] [--yes]" >&2
}

for arg in "$@"; do
    case "$arg" in
        --dotfiles-only) dotfiles_only=true ;;
        --dry-run) dry_run=true ;;
        --yes) assume_yes=true ;;
        *) usage; exit 2 ;;
    esac
done

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is required. On Arch, run: sudo pacman -S stow" >&2
    exit 1
fi

if [[ ! -r "$package_dir/pacman.txt" || ! -r "$package_dir/aur.txt" || ! -r "$package_dir/flatpak.txt" ]]; then
    echo "Package manifests are missing or unreadable under $package_dir." >&2
    exit 1
fi

if [[ "$dotfiles_only" == false ]]; then
    if [[ ! -r /etc/os-release ]] || ! grep -q '^ID=arch$' /etc/os-release; then
        echo "Package installation is supported only on Arch Linux." >&2
        echo "Re-run with --dotfiles-only to install just the configuration." >&2
        exit 1
    fi

    if ! command -v pacman >/dev/null 2>&1; then
        echo "pacman is required for package installation." >&2
        exit 1
    fi
fi

if [[ "$dry_run" == true ]]; then
    echo ":: Dry run; no files or packages will be changed."
    if [[ "$dotfiles_only" == false ]]; then
        echo "sudo pacman -Syu --needed -- [packages from $package_dir/pacman.txt]"
        echo "yay -S --needed -- [packages from $package_dir/aur.txt] (if yay is installed)"
        echo "flatpak install --noninteractive --or-update flathub [apps from $package_dir/flatpak.txt] (if flatpak is installed)"
    fi
    stow --simulate --dir "$repo_dir" --target "$HOME" \
        --ignore='^config\.dotinst$' --restow com.ml4w.dotfiles
    exit 0
fi

if [[ "$assume_yes" == false ]]; then
    echo "This will install packages and/or replace conflicting files under $HOME."
    read -r -p "Continue? [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
fi

if [[ "$dotfiles_only" == false ]]; then
    mapfile -t official_packages < "$package_dir/pacman.txt"
    sudo pacman -Syu --needed -- "${official_packages[@]}"

    if command -v yay >/dev/null 2>&1; then
        mapfile -t aur_packages < "$package_dir/aur.txt"
        yay -S --needed -- "${aur_packages[@]}"
    else
        echo "Skipping AUR packages because yay is not installed."
    fi

    if command -v flatpak >/dev/null 2>&1; then
        mapfile -t flatpak_apps < "$package_dir/flatpak.txt"
        flatpak install --noninteractive --or-update flathub "${flatpak_apps[@]}"
    fi
fi

backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup_dir"

while IFS= read -r -d '' source_file; do
    relative_path="${source_file#"$repo_dir/com.ml4w.dotfiles/"}"
    target_file="$HOME/$relative_path"

    if [[ -e "$target_file" || -L "$target_file" ]]; then
        if [[ "$(readlink -f -- "$target_file")" == "$(readlink -f -- "$source_file")" ]]; then
            continue
        fi
        mkdir -p "$backup_dir/$(dirname -- "$relative_path")"
        mv -- "$target_file" "$backup_dir/$relative_path"
    fi
done < <(find "$repo_dir/com.ml4w.dotfiles" -type f -print0)

stow --dir "$repo_dir" --target "$HOME" \
    --ignore='^config\.dotinst$' --restow com.ml4w.dotfiles

if [[ -z "$(find "$backup_dir" -mindepth 1 -print -quit)" ]]; then
    rmdir "$backup_dir"
else
    echo "Previous files were saved in $backup_dir"
fi

echo "Dotfiles installed. Log out and back in to apply the full desktop session."
