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
- Two artwork changes, both applied at install time so that upstream's own files stay
  untouched and merges from Qogir remain trivial:
  - `wmde-art/places/default-user-desktop.svg` replaces upstream's `user-desktop` in the
    colour-style sizes (32, 48, 96, 128, scalable). Upstream draws it as a grey window at
    every size - the one `places` icon that is not the blue folder the rest of the set
    uses, which makes it read as a dark blob in a sidebar full of folders. Ours is the
    stock `default-folder` with a monitor emblem drawn in Qogir's own emblem style (black
    at `.3` for the outline and `.15` for the fill, in the same box the home and documents
    emblems use). The 16/22/24 sizes are the mono outline style and are left alone.
  - `user-trash` and `user-trash-full` are repainted in the folder palette (body `#6ba4e7`,
    outline `#003579` at `.561` - the exact values `default-folder.svg` uses), again only
    in the colour-style sizes. Upstream draws the bin in its appliance grey, which made it
    the one sidebar item that read as coming from a different set. The shape and the white
    recycle symbol are upstream's and are unchanged. The ~18 other trash names per size
    (`edittrash`, `gnome-fs-trash-*`, `xfce-trash_*`, ...) are symlinks to these two files
    and follow automatically.
  - `filter="url(#...)"` references with no matching filter definition are stripped (24
    files, 12 names). Per the SVG spec such an element is not rendered at all, and resvg -
    what the WMDE apps draw with - obeys that, so those icons came out blank while
    librsvg-based GTK applications showed them fine.

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
