# Dotfiles ownership boundary

This repository owns the active configuration under `com.ml4w.dotfiles/`.
`install.sh` treats that directory as a GNU Stow package and links its contents
into `$HOME`. The `com.ml4w` path is retained for compatibility with existing
application paths and Hyprland bindings; it does not mean the files are
fetched from or updated by ML4W.

## Owned here

- Hyprland configuration, bindings, monitor defaults, scripts, and effects.
- Waybar, Rofi, Kitty, GTK, SwayNC, Walker, Wlogout, Matugen, and shell config.
- Wallpapers and theme assets intentionally committed to this repository.
- Installation, package manifests, validation, and backup behavior.

Changes to an owned file should be made here first, then validated with
`./scripts/dotfiles-check.sh`. Generated theme output and machine-local state
should remain outside the repository unless they are intentionally promoted to
a portable default.

## Still external

- Hyprland and desktop applications installed by the package manifests.
- Optional ML4W Flatpak applications such as the welcome screen, settings,
  calendar, sidebar, and Hyprland settings UI.
- Third-party shell installers and plugins used by optional shell setup flows.

Package availability is separate from configuration ownership: the lists under
`packages/` describe what the installer may request, but the repository does
not maintain the packages themselves or guarantee that optional AUR and
Flatpak tools are installed.

The intended migration path is to replace external behavior only when this
repository actively uses it. Unused upstream metadata and stale references
should not be copied back into the tree.
