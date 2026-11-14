# Jak otworzyć program / Opening the application

scrcpy Manager jest aplikacją z oknem. Można go zainstalować na Linuksie bez
pulpitu, ale do używania trzeba zapewnić miejsce do wyświetlania okien.
Instalator APT instaluje program i narzędzia do telefonu. Nie instaluje pulpitu
ani zdalnego dostępu. Nie trzeba mieć całego pulpitu, ale potrzebne jest działające
X11 lub XWayland. Ta wersja nie ma panelu w przeglądarce ani trybu obsługi w terminalu.

## Linux z pulpitem

Otwórz **scrcpy Manager** z menu aplikacji. Możesz też wpisać w terminalu
otwartym na tym pulpicie `scrcpy-manager` — bez sudo.

Jeżeli okno się nie otwiera, sprawdź, czy inne aplikacje z oknami działają w tej
samej sesji. Na pulpicie Wayland potrzebny jest też działający XWayland.
Nie ustawiaj `DISPLAY=:0` na ślepo: to nie tworzy ekranu ani dostępu do niego.

## WSL na komputerze z Windows

Najprościej uruchomić wersję Windows bezpośrednio w Windows. Jeżeli chcesz
używać wersji Linux, WSL musi mieć działające WSLg lub inne poprawnie skonfigurowane
wyświetlanie okien. Samo zainstalowanie Debiana w WSL nie gwarantuje, że jest dostępne.

Konfiguracja WSLg: [oficjalna instrukcja Microsoft](https://learn.microsoft.com/windows/wsl/tutorials/gui-apps).
Aktualizowanie i restartowanie WSL może zatrzymać inne uruchomione w nim programy;
zapisz wcześniej pracę. Po konfiguracji otwórz nową sesję WSL i sprawdź inną prostą
aplikację z oknem. Dopiero potem uruchom `scrcpy-manager`.
Wyświetlanie okien i dostęp do telefonu przez USB to oddzielne sprawy — w WSL
telefon może wymagać dodatkowego udostępnienia USB albo połączenia sieciowego.

## Linux bez ekranu albo zwykłe SSH

Jeżeli komputer nie ma obsługi okien, użyj zdalnego pulpitu z innego komputera
albo uruchom Manager na komputerze z ekranem i dostępem do telefonu.
Instalacja zdalnego pulpitu zależy od systemu i zasad sieci; nie dodajemy go
automatycznie. Okno Managera i okna telefonu muszą być dostępne w tej sesji.
Samo SSH bez przekazywania okien nie wystarczy. Wirtualny ekran Xvfb służący do
testów również nie daje użytkownikowi widocznego okna.

## English

Manager is a graphical application. A full desktop is optional, but a working
X11/XWayland display is required. APT does not install a desktop or remote access.
There is currently no browser UI or terminal management mode.

- **Linux desktop:** open the app from the menu or run `scrcpy-manager` from that
  desktop's terminal, without sudo. Wayland desktops also need working XWayland.
- **WSL:** use the Windows edition directly, or configure WSLg using Microsoft's
  guide above. Display support and Android USB access are separate requirements.
- **Headless/SSH:** connect through a properly configured remote desktop or use
  a computer with a display and phone access. Plain SSH and Xvfb alone do not
  provide a visible window. Do not set DISPLAY blindly or disable X server access controls.
