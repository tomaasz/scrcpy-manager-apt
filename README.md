# scrcpy Manager — Linux Preview

Ubuntu **24.04** / Debian **13**, komputery **x64 (amd64)**.

Z pulpitem: otwórz program z menu. **Bez pulpitu lub WSLg: `scrcpy-manager --web`**.
Otwórz pełny jednorazowy link z terminala w Chrome lub Edge.
[Instrukcja / Desktop, WSL and headless guide](GUI.md).

## Instalacja / Installation

Wklej do terminala / Paste into a terminal:

```sh
curl -fsSL https://tomaasz.github.io/scrcpy-manager-apt/install.sh | sudo sh
```

Jeśli brakuje polecenia curl: `sudo apt install curl`.
Instalator dodaje podpisane repozytorium, instaluje program, ADB i scrcpy.
Potem otwórz **scrcpy Manager** z menu aplikacji albo wpisz `scrcpy-manager --web`.
Nie uruchamiaj aplikacji przez sudo. W telefonie włącz debugowanie USB i zaakceptuj
zgodę na połączenie. Po instalacji reguł USB może być potrzebne ponowne podłączenie kabla.

The installer adds a signed repository and installs the app, ADB and scrcpy.
Open **scrcpy Manager** from the applications menu, or run `scrcpy-manager --web`. Run the app as your
normal user. Enable USB debugging on Android and accept the connection prompt.
You may need to reconnect the USB cable after installing device rules.

## Nowości 0.7.18 / Changes

Poprawka pakietu **0.7.18-2**: zajęty port panelu Web wyświetla krótką instrukcję
zamiast stosu błędów. Po aktualizacji uruchom panel ponownie.

Package **0.7.18-2**: a busy Web port shows a short recovery message instead of a
stack trace. Restart the panel after upgrading.

Linux i Web: ikony z telefonu, kopiowanie zapisanych aplikacji i zmiana kolejności.
Linux: obrót, bufor obrazu oraz kodek i jakość dźwięku. Web: dźwięk ustawiany osobno
dla aplikacji. Pobranie ikony wymaga gotowego telefonu i kliknięcia „Ikona z telefonu”.

Linux and Web: phone icons, duplicate saved apps and reorder the list. Linux adds
rotation, video buffer and audio quality controls. Web adds per-app audio choices.
Select a ready phone and click “Icon from phone” to retrieve an icon.

## Aktualizacje / Updates

Aktualizacje pojawią się w systemowym menedżerze aktualizacji. Możesz też wpisać:

```sh
sudo apt update
sudo apt install --only-upgrade scrcpy-manager scrcpy
```

Updates are delivered through your normal system update manager.

## Usunięcie / Removal

```sh
sudo apt remove scrcpy-manager
```

Zapisane ustawienia pozostają w katalogu użytkownika. ADB i scrcpy mogą być używane
przez inne programy, więc pozostają zainstalowane. Opcjonalnie usuń kanał aktualizacji:

```sh
sudo rm /etc/apt/sources.list.d/scrcpy-manager.sources
sudo rm /usr/share/keyrings/scrcpy-manager-archive-keyring.gpg
sudo apt update
```

Your saved settings are preserved. ADB and scrcpy are retained for other applications.
The optional commands above remove this update channel only.

## Weryfikacja / Verification

Klucz podpisujący / Signing key fingerprint:

```text
CFF184718B470F389319AABF6B5DD55898A9A341
```

APT sprawdza podpisy oraz sumy paczek. Podpisy są odnawiane codziennie i ważne przez
30 dni. Klucz wygasa 14 listopada 2028; jego wymiana będzie wymagała aktualizacji
instrukcji i instalatora. Nie wyłączaj sprawdzania podpisów ani ważności repozytorium.

APT verifies signatures and package hashes. Metadata is renewed daily and expires
after 30 days. The signing key expires on 14 November 2028; rotation requires an
installer/instructions update. Do not disable signature or expiry checks.

## Zawartość / Contents

- `scrcpy-manager` **0.7.18-2**: Linux + Web Preview, z dołączonym .NET i panelem bez pulpitu.
- `scrcpy` **5.0.1-1sm1**: klient i zgodny serwer Android 5.0.1; prywatne SDL **3.4.18**.
- FFmpeg i pozostałe biblioteki pochodzą z systemu. Nie dodajemy statycznego FFmpeg.
- Licencje Managera i zależności: `/opt/scrcpy-manager/licenses/`,
  `/usr/share/doc/scrcpy-manager/copyright`, `/usr/share/doc/scrcpy/`.
- Oryginalne źródła scrcpy i SDL oraz ich opis: `sources/`. Skrypty budowania
  klienta i podpisywania indeksów: `admin/`. Sumy plików: `SHA256SUMS`.

This public repository distributes binary packages and upstream dependencies.
The Manager application's development repository remains private. Existing
licenses included in the packages continue to apply. The root MIT license covers
the distribution scripts; third-party code retains its original licenses.

Linux remains a **Preview**. No ARM or native Wayland support is claimed.
Installation and window startup are tested in disposable Ubuntu/Debian containers.
Pixel 8 Pro video, navigation and audio transfer through WSL were confirmed in an
earlier 0.7.17 session; they were not re-tested as a full streaming session for
0.7.18. The 0.7.18 phone-icon retrieval and Web API were tested separately on
that phone with `com.android.settings`. Other devices still need hardware testing.

This repository provides its own `scrcpy` package, which upgrades Ubuntu's older
package and replaces its matching `scrcpy-server`. Both suites are built separately
against each distribution's FFmpeg. Keep the matching client/server together.

The workflow makes a small monthly maintenance commit to keep GitHub's public
repository schedule active. Only that separate job has repository write access;
it does not receive the signing key. The publishing job has read access and the
signing secret. The maintainer must still monitor the daily workflow and signed
`Valid-Until` dates and re-enable scheduling if GitHub disables it.

## Bez pulpitu / Headless

Uruchom / Run `scrcpy-manager --web` bez sudo / without sudo. Otwórz pełny link / Open the full login URL in Chrome or Edge. [Instrukcja / Guide](GUI.md).

Web Preview: testy z materiałem testowym przeszły; pełny test z fizycznym telefonem pozostaje do wykonania. / Fixture-based checks passed; physical phone video/control/audio validation is pending.
