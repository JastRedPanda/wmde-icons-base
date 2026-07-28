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
# We install exactly two themes:
#   WMDE-Base       full art, DARK ink (#5d656b) - the set for LIGHT backgrounds
#   WMDE-Base-Dark  actions/places/devices recoloured to LIGHT ink (#d3dae3), the rest
#                   inherited from WMDE-Base - the set for DARK backgrounds
#
# Upstream builds the Dark variant out of ~20 relative symlinks back into the base
# theme; Inherits= does the same job with no symlinks, and the precedence is right
# because the only dirs Dark carries are the ones it recolours.
#
# Usage: wmde-install.sh <icons-dir>      e.g. "$pkgdir/usr/share/icons"

set -euo pipefail

SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DEST=${1:?usage: wmde-install.sh <icons-dir>}

BASE=WMDE-Base
DARK=WMDE-Base-Dark

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

  write_index "$dir" "$BASE" 'hicolor'
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

  write_index "$dir" "$DARK" "$BASE,hicolor"
  link_2x "$dir" 16 22 24 32
}

# The shipped index.theme names the theme and its fallback on exactly two lines; the
# Directories list is the same for both variants (entries whose directory is absent are
# skipped by the icon loaders, which is what makes the Dark variant's inheritance work).
write_index() {
  local dir=$1 name=$2 inherits=$3
  install -Dm0644 "$SRC_DIR/src/index.theme" "$dir/index.theme"
  sed -i -e "s/^Name=.*/Name=$name/" -e "s/^Inherits=.*/Inherits=$inherits/" "$dir/index.theme"

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

install_base
install_dark
