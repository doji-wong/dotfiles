#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
package_dir="$repo_dir/com.ml4w.dotfiles"
errors=0

error() {
    printf 'ERROR: %s\n' "$1" >&2
    errors=$((errors + 1))
}

required_files=(
    "$package_dir/.config/hypr/hyprland.conf"
    "$package_dir/.config/hypr/conf/monitor.conf"
    "$package_dir/.config/hypr/conf/monitors/default.conf"
    "$package_dir/.config/waybar/launch.sh"
    "$repo_dir/install.sh"
)

for file in "${required_files[@]}"; do
    [[ -f "$file" ]] || error "missing required file: ${file#"$repo_dir/"}"
done

while IFS= read -r -d '' file; do
    if ! bash -n "$file"; then
        error "Bash syntax failed: ${file#"$repo_dir/"}"
    fi
done < <(find "$repo_dir" -path "$repo_dir/.git" -prune -o -type f \( -name '*.sh' -o -name '.bashrc*' -o -name '.zshrc*' \) -print0)

if rg -n --hidden '(diagnosis\.sh|launchvm\.sh|my_monitors\.conf)' "$package_dir" >/dev/null; then
    error 'repository still references removed machine-specific or missing scripts'
fi

if rg -n --hidden '/home/doji/(Downloads|\.local|\.config)' "$package_dir" >/dev/null; then
    error 'configuration contains a user-specific runtime path'
fi

if (( errors > 0 )); then
    printf '%d check(s) failed.\n' "$errors" >&2
    exit 1
fi

echo 'dotfiles checks passed.'
