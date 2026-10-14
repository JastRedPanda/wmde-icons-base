set export
rootdir := ''
prefix := '/usr'
# Чтобы shell() работал и на Windows с Git Bash; на Linux игнорируется
set windows-shell := ["C:\\Program Files\\Git\\bin\\sh.exe", "-cu"]
base-dir := absolute_path(clean(rootdir / prefix))
install-dir := base-dir / 'share'
icons := install-dir / 'icons'

default:
    @just --list

# Install the two user-facing themes (WMDE + WMDE-Dark). See wmde-install.sh for what
# each one carries and why the Dark variant only recolours a few directories.
install:
    mkdir -p {{icons}}
    ./wmde-install.sh {{icons}}

# Uninstalls everything (requires same arguments as given to install)
uninstall:
    rm -rf {{icons}}/WMDE {{icons}}/WMDE-Dark

# Show the current git commit
git-rev:
    @git rev-parse --short HEAD

# Версия пакета как pkgver() в PKGBUILD: ТОЛЬКО rev-list, БЕЗ describe —
# теги по датам сбрасывали бы счётчик и версия пошла бы назад.
wmde-version := shell('printf "1.10.0.%s.g%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"')

# Раскладывает тему в target/staging (тот же набор, что PKGBUILD кладёт в $pkgdir).
# Сборки нет (data-only) — вендор-рецепты не нужны.
package-staging staging="target/staging":
    #!/usr/bin/env bash
    set -e
    rm -rf {{staging}}
    just rootdir="{{staging}}" install
    # Каноникализация симлинков арта (./x, ../../-цепочки): lintian E
    # symlink-contains-spurious-segments/lengthy-symlink. Резолвится в тот же
    # файл, поведение темы не меняется.
    find "{{staging}}" -type l | while read -r l; do \
        t="$(readlink "$l")"; \
        n="$(realpath -m --relative-to="$(dirname "$l")" "$(dirname "$l")/$t")"; \
        [ "$t" != "$n" ] && ln -sfn "$n" "$l" || true; \
    done
    just package-doc "{{staging}}"

# doc для deb/rpm: копирайт + changelog.yaml (nFPM сам разложит changelog
# в changelog.Debian.gz для deb и в %changelog для rpm)
package-doc staging="target/staging":
    #!/usr/bin/env bash
    set -e
    mkdir -p "{{staging}}/usr/share/doc/wmde-icons-base"
    cp packaging/copyright "{{staging}}/usr/share/doc/wmde-icons-base/copyright"
    chmod 644 "{{staging}}/usr/share/doc/wmde-icons-base/copyright"
    printf -- '- semver: %s\n  date: %s\n  packager: WMDE <wmde@wmde.fun>\n  urgency: low\n  distribution: unstable\n  deb:\n    urgency: low\n    distributions:\n      - unstable\n  changes:\n    - note: Automated build via nFPM (see INSTALL.deb-rpm.md).\n' "{{wmde-version}}-1" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > target/changelog.yaml

# Собирает .deb через nFPM (нужен nfpm в PATH)
deb:
    #!/usr/bin/env bash
    set -e
    just package-staging
    export WMDE_VERSION="{{wmde-version}}"
    nfpm package --config packaging/nfpm.yaml --packager deb --target target/

# Собирает .rpm через nFPM (нужен nfpm в PATH)
rpm:
    #!/usr/bin/env bash
    set -e
    just package-staging
    export WMDE_VERSION="{{wmde-version}}"
    nfpm package --config packaging/nfpm.yaml --packager rpm --target target/
