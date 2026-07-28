WMDE Base Icons
===============

**This is a modified fork of the [Qogir icon theme](https://github.com/vinceliuice/Qogir-icon-theme)
by Vince Liuice.** Forked and modified by the WMDE project starting 2026-07-28.

It provides the fallback icon art for the WMDE desktop. It is not a theme a user picks:
`wmde-icons` (the `WMDE` / `WMDE-Dark` themes) inherits from it for the plain icon names
Qt applications look up and which WMDE itself ships as `-symbolic` only.

## Changes from upstream

- Added `wmde-install.sh`, `justfile` and `PKGBUILD` for packaging. Upstream `install.sh`
  is left in place, unmodified.
- Installs two themes, `WMDE-Base` (dark ink, for light backgrounds) and `WMDE-Base-Dark`
  (light ink, for dark backgrounds), instead of upstream's `Qogir*` names.
- `WMDE-Base-Dark` reaches the rest of the art through `Inherits=WMDE-Base` rather than
  upstream's ~20 relative symlinks back into the base theme.
- Both themes inherit `hicolor` only; upstream also inherits `breeze`.
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
