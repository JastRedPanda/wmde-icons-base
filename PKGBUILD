# Maintainer: WMDE <https://wmde.fun>
# Contributor: Vince Liuice <vinceliuice@hotmail.com> (original Qogir-icon-theme)
#
# Builds our fork Lin-WMDE/wmde-icons-base (branch wmde) of the Qogir icon theme.
# Data-only: installs /usr/share/icons/WMDE and /usr/share/icons/WMDE-Dark.
#
# NOTE ON THE NAME: "base" is historical - this started as a fallback set filling the
# plain (non -symbolic) names Qt asks for and wmde-icons lacked. It is now the base layer
# in the other sense: this art IS the WMDE look and owns the user-facing theme names.
# wmde-icons provides WMDE-Extra underneath it, for the WMDE-specific names this set has
# no art for. The package was not renamed to avoid a provides/replaces migration.
#
# Separate package on purpose: wmde-icons is CC-BY-SA (Cosmic/Pop/Adwaita art) and this
# is GPL-3.0. CC-BY-SA-4.0 -> GPLv3 is a ONE-WAY compatibility and CC-BY-SA-3.0 has none
# at all, so merging the two sets into one tarball would force the whole thing to GPL and
# strand the Adwaita art. Two packages, two licences, nothing mixed.
#
# We ship neither the X cursor themes nor the Manjaro/Ubuntu colour variants upstream
# also builds.
pkgname=wmde-icons-base
pkgver=1.0.0
pkgrel=1
pkgdesc="WMDE icon theme (fork of Qogir) - installs /usr/share/icons/WMDE{,-Dark}"
arch=('any')
url="https://wmde.fun"
# Upstream carries the plain GPLv3 text with no "or (at your option) any later version"
# grant anywhere, so this is GPL-3.0-only, not -or-later.
license=('GPL-3.0-only')
# wmde-icons supplies WMDE-Extra, the last stop before hicolor in both themes' chains.
depends=('hicolor-icon-theme' 'wmde-icons')
makedepends=('just' 'git')
source=("$pkgname::git+https://github.com/Lin-WMDE/wmde-icons-base.git#branch=wmde")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/$pkgname"
  # WMDE version: <COSMIC major.minor>.<WMDE release>.<commits since the nearest tag>.g<short>.
  # Plain rev-list, NOT git describe: upstream tags this repo by date, so a describe-based
  # count would reset to a small number on every new upstream tag and the pkgver would go
  # backwards - pacman would then refuse the upgrade.
  printf '1.10.0.%s.g%s' "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
}

package() {
  cd "$srcdir/$pkgname"
  just rootdir="$pkgdir" prefix=/usr install
  install -Dm644 COPYING "$pkgdir/usr/share/licenses/$pkgname/COPYING"
  install -Dm644 AUTHORS "$pkgdir/usr/share/licenses/$pkgname/AUTHORS"
}
