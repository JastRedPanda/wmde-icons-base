# Установка на deb/rpm-дистрибутивах без сборки из сырцов вручную

Шаблон: см. предыдущие компоненты (data-вариант `wmde-themes`). Автор собирает пакеты у себя локально, как сейчас `makepkg -si`.

Опорные платформы — Debian stable и Fedora: `.deb` собираем на Debian (встаёт и на Ubuntu/Mint),
`.rpm` — на Fedora (встаёт и на RHEL/openSUSE). Наоборот не гарантируется.

Пакет data-only: компиляции нет, только `just install` + nFPM. Тулчейн не нужен.

## Собрать

```sh
# зависимости сборки: just + nfpm
cargo install --locked nfpm  # или бинарник с github.com/goreleaser/nfpm/releases

just deb   # -> target/wmde-icons-base_*.deb
just rpm   # -> target/wmde-icons-base-*.rpm
```

Версия — ТОЛЬКО `1.10.0.<rev-list>.g<sha>`, как `pkgver()` в `PKGBUILD`
(без describe: теги по датам сбрасывали бы счётчик и версия пошла бы назад).

## Поставить

```sh
# Debian/Ubuntu/Mint
sudo apt install ./target/wmde-icons-base_*.deb

# Fedora/RHEL/openSUSE
sudo dnf install ./target/wmde-icons-base-*.rpm
```

`wmde-icons` (WMDE-Extra, нижний слой) — в recommends: в PKGBUILD это hard dep,
но пакета пока нет в репозиториях дистрибутивов. Когда выйдет единый
репозиторий WMDE — переключить в depends. Обратную зависимость (icons на base)
не заявляем специально: был бы цикл.
