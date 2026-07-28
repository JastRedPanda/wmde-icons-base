WMDE Base Icons
===============

**This is a modified fork of the [Qogir icon theme](https://github.com/vinceliuice/Qogir-icon-theme)
by Vince Liuice.** Forked and modified by the WMDE project starting 2026-07-28.

This art is the WMDE desktop's icon look. It installs the two user-facing themes and
falls through to `WMDE-Extra` (package `wmde-icons`) for the WMDE-specific names it has
no art for:

    WMDE-Dark (light ink) -> WMDE (all of the art) -> WMDE-Extra -> hicolor
    WMDE      (dark ink)  -> WMDE-Extra -> hicolor

## Changes from upstream

- Added `wmde-install.sh`, `justfile` and `PKGBUILD` for packaging. Upstream `install.sh`
  is left in place, unmodified.
- Installs two themes, `WMDE` (dark ink, for light backgrounds) and `WMDE-Dark` (light
  ink, for dark backgrounds), instead of upstream's `Qogir*` names.
- `WMDE-Dark` reaches the rest of the art through `Inherits=WMDE` rather than upstream's
  ~20 relative symlinks back into the base theme.
- Both themes fall through to `WMDE-Extra` and `hicolor`; upstream inherits `breeze`.
- `WMDE-Dark` is `Hidden=true` - the settings daemon switches to it by mode, it is not a
  separate choice in the icon-theme picker.
- The X cursor themes and the Manjaro/Ubuntu colour variants are not built or shipped.

No icon artwork has been altered.

## Licence

GPL-3.0. Upstream carries the plain GPLv3 text with no "or (at your option) any later
version" grant, so this is GPL-3.0-**only**.

The upstream `AUTHORS` file is preserved and installed alongside the theme. Attribution
for the art, per that file:

> "[Qogir icon theme](https://github.com/vinceliuice/Qogir-icon-theme)" by Vince Liuice,
> built from "[arc-icon-theme](https://github.com/horst3180/arc-icon-theme)" (GPL-3.0),
> "[faba-icon-theme](https://github.com/snwh/faba-icon-theme)" (GPLv3 or CC-BY-SA-4.0)
> and "[Tela icon theme](https://github.com/vinceliuice/Tela-icon-theme)" (GPL-3.0).

Kept as a separate package from `wmde-icons` on purpose: that one is CC-BY-SA art
(Cosmic, Pop, Adwaita) and CC-BY-SA-4.0 is only *one-way* compatible with GPLv3, while
CC-BY-SA-3.0 is not compatible at all. Merging the two sets into one tarball would force
the whole thing under the GPL and strand the Adwaita artwork.

## Upstream

Upstream README, install options and previews: https://github.com/vinceliuice/Qogir-icon-theme
