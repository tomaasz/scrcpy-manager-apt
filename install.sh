#!/bin/sh
# One-time setup. Supported: Ubuntu 24.04 / Debian 13, amd64.
set -eu
umask 022
REPOSITORY=https://tomaasz.github.io/scrcpy-manager-apt
FINGERPRINT=CFF184718B470F389319AABF6B5DD55898A9A341

fail() { printf '%s\n' "$*" >&2; exit 1; }
[ "$(id -u)" = 0 ] || fail 'Uruchom instalator przez sudo. / Please run with sudo.'
[ -r /etc/os-release ] || fail 'Nie rozpoznano systemu. / Unknown system.'
. /etc/os-release
case "${ID:-}:${VERSION_CODENAME:-}" in
 ubuntu:noble|debian:trixie) suite=$VERSION_CODENAME ;;
 *) fail 'Obsługiwane: Ubuntu 24.04 i Debian 13. / Supported: Ubuntu 24.04 and Debian 13.' ;;
esac
[ "$(dpkg --print-architecture)" = amd64 ] || fail 'Wymagany komputer x64 (amd64). / An amd64 computer is required.'

if [ -z "${DISPLAY:-}" ]; then
 printf '%s\n' 'Uwaga: w tej sesji nie wykryto ekranu. Instalacja nie dodaje obsługi okien.' \
  'Note: no display detected in this session. Installation does not add window support.'
fi
printf '%s\n' 'Instalowanie scrcpy Manager i potrzebnych składników… / Installing scrcpy Manager…'
apt-get update
apt-get install -y ca-certificates curl gnupg
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT HUP INT TERM
mkdir -m 700 "$temporary/gnupg"
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 --retry 3 \
 "$REPOSITORY/archive-key.gpg" -o "$temporary/key.gpg"
actual=$(gpg --homedir "$temporary/gnupg" --batch --with-colons --show-keys "$temporary/key.gpg" | awk -F: '$1 == "fpr" {print $10}')
[ "$actual" = "$FINGERPRINT" ] || fail 'Klucz repozytorium nie pasuje. Instalacja przerwana. / Repository key mismatch. Installation stopped.'

mkdir -p /usr/share/keyrings /etc/apt/sources.list.d
install -m 644 "$temporary/key.gpg" /usr/share/keyrings/scrcpy-manager-archive-keyring.gpg
cat > "$temporary/scrcpy-manager.sources" <<SOURCES
Types: deb
URIs: $REPOSITORY/
Suites: $suite
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/scrcpy-manager-archive-keyring.gpg
SOURCES
install -m 644 "$temporary/scrcpy-manager.sources" /etc/apt/sources.list.d/scrcpy-manager.sources
apt-get update
apt-get install -y scrcpy-manager
if [ -n "${DISPLAY:-}" ]; then
 printf '%s\n' 'Gotowe. Otwórz scrcpy Manager z menu aplikacji. / Done. Open scrcpy Manager from the applications menu.'
else
 printf '%s\n' 'Zainstalowano. Do otwarcia programu potrzebny jest dostęp do ekranu.' \
  'Linux: uruchom z pulpitu. WSL: włącz WSLg albo użyj wersji Windows.' \
  'Linux bez ekranu: potrzebny jest zdalny pulpit; sam terminal nie wyświetli okna.' \
  'Installed. Open from a Linux desktop, enable WSLg, or use the Windows version.' \
  'A headless Linux machine needs a remote desktop to display the window.' \
  'Pomoc / Help: https://github.com/tomaasz/scrcpy-manager-apt/blob/main/GUI.md'
fi
