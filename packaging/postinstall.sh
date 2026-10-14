#!/bin/sh
# Обновляет кэш иконок после установки. Ошибки не роняют установку.
set -e
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t /usr/share/icons/WMDE || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t /usr/share/icons/WMDE-Dark || true
