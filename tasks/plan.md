# Implementation Plan: Owned Hyprland Dotfiles

## Overview

Make this personal Hyprland/ML4W-derived configuration reproducible from a
fresh clone, safer to install, and increasingly independent of upstream ML4W
files while preserving the current desktop behavior.

## Architecture decisions

- Keep the existing Stow package as the owned runtime configuration.
- Track safe defaults and keep monitor, wallpaper, and generated theme state
  machine-local unless it is deliberately promoted to a theme source.
- Preserve ML4W-compatible paths during the transition so existing bindings and
  applications continue to work.
- Replace upstream dependencies incrementally; do not copy the entire upstream
  project or vendor unrelated features.

## Task list

### Phase 1: Reproducible baseline — complete

- [x] Add a tracked monitor default and make the active monitor source work from
      a fresh clone.
- [x] Remove or guard references to absent diagnosis, VM, and Qtile scripts.
- [x] Remove committed backup artifacts and document generated/local state.

### Phase 2: Safer installation — complete

- [x] Add installer preflight, dry-run, confirmation, and safer backup behavior.
- [x] Keep package metadata out of the Stow package root.

### Phase 3: Own the active runtime

- [ ] Inventory active ML4W scripts and replace the highest-value wrappers with
      small locally owned equivalents.
- [ ] Add validation for configuration references and shell syntax.
- [ ] Split package manifests into base, hardware, and optional profiles.

## Verification checkpoints

- Fresh-clone reference check has no required missing files.
- Bash syntax and repository hygiene checks pass.
- Installer dry-run makes no filesystem changes.
- Existing uncommitted theme changes remain untouched.

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Generated theme files are overwritten | Medium | Do not edit current generated colors in this phase |
| Machine-local monitor files are lost | High | Keep them ignored and add a tracked default |
| Upstream-compatible paths change | Medium | Preserve current paths until replacements are verified |
| Installer migration fails midway | High | Preflight, dry-run, and backup before Stow |
