# Dotfiles ownership boundary

This repository owns the active configuration under `com.ml4w.dotfiles/`.
The `com.ml4w` path is retained for compatibility with existing application
paths and Hyprland bindings; it does not mean the files are fetched from or
updated by ML4W.

## Owned here

- Hyprland configuration, bindings, monitor defaults, scripts, and effects.
- Waybar, Rofi, Kitty, GTK, SwayNC, Walker, Wlogout, Matugen, and shell config.
- Wallpapers and theme assets intentionally committed to this repository.
- Installation, package manifests, validation, and backup behavior.

## Still external

- Hyprland and desktop applications installed by the package manifests.
- Optional ML4W Flatpak applications such as the welcome screen, settings,
  calendar, sidebar, and Hyprland settings UI.
- Third-party shell installers and plugins used by optional shell setup flows.

The intended migration path is to replace external behavior only when this
repository actively uses it. Unused upstream metadata and stale references
should not be copied back into the tree.
