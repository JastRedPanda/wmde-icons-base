set export
rootdir := ''
prefix := '/usr'
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
