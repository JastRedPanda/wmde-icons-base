#!/usr/bin/env bash
#
# wmde-install.sh - WMDE packaging installer for this icon theme.
#
# Upstream install.sh is left untouched (so merges from upstream stay trivial), but it
# does not fit packaging: it insists on gtk-update-icon-cache, builds the X cursor
# themes, installs the Manjaro/Ubuntu colour variants we do not ship, and its -n/--name
# option is only half-implemented (it seds ${name} in an index.theme that still says
# "Qogir", so a renamed theme keeps Name=Qogir).
#
# This art IS the WMDE look. The themes installed here own the user-facing names:
#   WMDE       full art, DARK ink (#5d656b) - the set for LIGHT backgrounds
#   WMDE-Dark  actions/places/devices recoloured to LIGHT ink (#d3dae3), the rest
#              inherited from WMDE - the set for DARK backgrounds
#
# Both fall through to WMDE-Extra (package wmde-icons), which carries the WMDE-specific
# art this theme has no name for: our own app icons, the distro logos, the
# wmde-illustration-* art, 111 places and 130 categories names.
#
# WMDE-Dark inherits WMDE, and the order that produces is exactly right:
#   WMDE-Dark (light ink) -> WMDE (all Qogir art) -> WMDE-Extra (ours) -> hicolor
# Depth-first resolution is unforgiving here - see the note in wmde-icons/index.theme.
#
# Usage: wmde-install.sh <icons-dir>      e.g. "$pkgdir/usr/share/icons"

set -euo pipefail

SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DEST=${1:?usage: wmde-install.sh <icons-dir>}

BASE=WMDE
DARK=WMDE-Dark
EXTRA=WMDE-Extra

# The two ink colours upstream art is drawn in.
INK_DARK='#5d656b'
INK_LIGHT='#d3dae3'

# cp -a throughout: links/ is a farm of relative same-directory symlinks (alias name ->
# real icon) and dereferencing them would multiply the theme size several times over.

install_base() {
  local dir="$DEST/$BASE"
  rm -rf "$dir"
  mkdir -p "$dir"

  cp -a "$SRC_DIR"/src/{16,22,24,32,48,96,128,scalable,symbolic} "$dir/"
  cp -a "$SRC_DIR"/links/{16,22,24,32,48,96,128,scalable,symbolic} "$dir/"

  # The one theme a user is meant to see in the picker, so no Hidden= here.
  write_index "$dir" "$BASE" 'WMDE Icons' "$EXTRA,hicolor" ''
  link_2x "$dir" 16 22 24 32 48 96 128 scalable
}

install_dark() {
  local dir="$DEST/$DARK"
  rm -rf "$dir"
  mkdir -p "$dir"/{16,22,24,32}

  cp -a "$SRC_DIR"/src/16/{actions,places,devices} "$dir/16/"
  cp -a "$SRC_DIR"/src/22/{apps,actions,places,devices} "$dir/22/"
  cp -a "$SRC_DIR"/src/24/{actions,places,devices} "$dir/24/"
  cp -a "$SRC_DIR"/src/32/actions "$dir/32/"

  # Recolour BEFORE the alias symlinks land: sed -i on a symlink replaces it with a
  # regular file, which would silently turn every alias into a private copy.
  sed -i "s/$INK_DARK/$INK_LIGHT/g" \
    "$dir"/{16,22,24,32}/actions/*.svg \
    "$dir"/{16,22,24}/{places,devices}/*.svg \
    "$dir"/22/apps/*.svg

  cp -a "$SRC_DIR"/links/16/{actions,places,devices} "$dir/16/"
  cp -a "$SRC_DIR"/links/22/{apps,actions,places,devices} "$dir/22/"
  cp -a "$SRC_DIR"/links/24/{actions,places,devices} "$dir/24/"
  cp -a "$SRC_DIR"/links/32/actions "$dir/32/"

  # Hidden: the settings daemon switches to this by mode, it is not a separate choice.
  write_index "$dir" "$DARK" 'WMDE Icons (dark)' "$BASE,hicolor" 'true'
  link_2x "$dir" 16 22 24 32
}

# The shipped index.theme names the theme and its fallback on three lines; the Directories
# list is the same for both variants (entries whose directory is absent are skipped by the
# icon loaders, which is what makes the Dark variant's inheritance work).
write_index() {
  local dir=$1 name=$2 comment=$3 inherits=$4 hidden=$5
  local inherits_block="Inherits=$inherits"
  [ -n "$hidden" ] && inherits_block="Hidden=$hidden\nInherits=$inherits"

  install -Dm0644 "$SRC_DIR/src/index.theme" "$dir/index.theme"
  sed -i \
    -e "s/^Name=.*/Name=$name/" \
    -e "s/^Comment=.*/Comment=$comment/" \
    -e "s/^Inherits=.*/$inherits_block/" \
    "$dir/index.theme"

  install -Dm0644 "$SRC_DIR/COPYING" "$dir/COPYING"
  install -Dm0644 "$SRC_DIR/AUTHORS" "$dir/AUTHORS"
}

link_2x() {
  local dir=$1; shift
  local d
  for d in "$@"; do
    ln -sfn "$d" "$dir/$d@2x"
  done
}

# Upstream bug: 28 files carry filter="url(#a)" while defining no such filter - the <defs>
# block was dropped somewhere in their tooling. Per the SVG spec a reference to a
# non-existent filter means the element is NOT RENDERED, so resvg (what libcosmic and iced
# draw with) shows nothing at all. librsvg forgives it, which is why the same icons look
# fine in GTK applications and vanish in ours. network-wired-symbolic is one of them, so a
# machine on ethernet had an empty slot in the panel.
#
# Only regular files: -type f without -L, because the alias symlinks must not be turned
# into private copies by sed -i.
strip_dangling_filters() {
  local dir=$1 f id
  local n=0
  while IFS= read -r f; do
    for id in $(grep -o 'filter="url(#[^)]*)"' "$f" | sed 's/.*#\(.*\))"/\1/' | sort -u); do
      grep -q "filter[^>]*id=\"$id\"" "$f" && continue
      sed -i "s/ filter=\"url(#$id)\"//g" "$f"
      n=$((n + 1))
    done
  done < <(grep -rl 'filter="url(#' "$dir" --include='*.svg' 2>/dev/null | while read -r p; do [ -f "$p" ] && [ ! -L "$p" ] && echo "$p"; done)
  echo "  stripped dangling filter refs in $n file(s) under $(basename "$dir")"
}

install_base
install_dark
strip_dangling_filters "$DEST/$BASE"
strip_dangling_filters "$DEST/$DARK"
