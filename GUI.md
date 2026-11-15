# scrcpy Manager: okno lub przeglądarka

## Linux bez pulpitu i WSL

Od wersji 0.7.17 można uruchomić lokalny panel **Web Preview**:

```sh
scrcpy-manager --web
```

Nie używaj sudo. Otwórz **pełny link pokazany w terminalu** w aktualnym Chrome
lub Edge. W WSL możesz otworzyć go w przeglądarce Windows. Nie potrzebujesz WSLg,
X11 ani pulpitu Linux. Terminal pozostaje otwarty podczas pracy; Ctrl+C kończy
serwer i sesję telefonu. Opcjonalnie zmień port: `scrcpy-manager --web --port=17832`.
Link daje dostęp do telefonu — zachowaj go dla siebie. Jest jednorazowy.
Jeżeli port jest zajęty, panel może już działać w innym terminalu. Zakończ go
tam przez Ctrl+C lub uruchom nowy panel na innym porcie:
`scrcpy-manager --web --port=17832`. Po aktualizacji zamknij stary panel i uruchom
go ponownie, aby korzystać z nowej wersji.
Po wylogowaniu lub po 8 godzinach uruchom serwer ponownie, aby dostać nowy link.
Panel działa tylko na tym komputerze. Zdalne SSH wymaga przekierowania portu:

```sh
ssh -L 17831:127.0.0.1:17831 użytkownik@komputer
# Na zdalnym komputerze:
scrcpy-manager --web
```

Następnie otwórz pokazany link lokalnie. Nie otwieraj portu w routerze.
Telefon musi być widoczny dla ADB **na komputerze z uruchomionym Managerem**.
W WSL USB wymaga osobnego udostępnienia urządzenia; alternatywą jest debugowanie Wi-Fi.
Panel ma listę telefonów, parowanie Wi-Fi, zapisane aplikacje, obraz, sterowanie
i opcjonalny dźwięk. Dźwięk wymaga wsparcia telefonu i przeglądarki.
Od wersji 0.7.19 przycisk **Dodaj aplikacje z telefonu** uzupełnia listę skrótami
do znanych aplikacji z wybranego telefonu, zachowując własne wpisy i ustawienia.
Ustawienia okien, UHID i specjalne sterowanie myszą RDP pozostają w wersji desktopowej.
Web Preview przeszedł testy automatyczne i przeglądarkowe z materiałem testowym;
pełny test obrazu, sterowania i dźwięku na fizycznym telefonie pozostaje do wykonania.

## Linux z pulpitem

Otwórz **scrcpy Manager** z menu lub wpisz `scrcpy-manager` bez sudo.
Tryb okienkowy wymaga X11 lub XWayland. Nie ustawiaj DISPLAY na ślepo.
Możesz też używać panelu przez `scrcpy-manager --web`.

## English

Run `scrcpy-manager --web` without sudo and open the complete one-time URL printed
in the terminal in current Chrome or Edge. No Linux display or WSLg is needed;
Windows browsers can access the WSL localhost port. Keep the process running;
Ctrl+C stops it. Access expires after 8 hours; restart after logout for a new link.
If the port is busy, stop the earlier panel with Ctrl+C in its terminal or use
another port: `scrcpy-manager --web --port=17832`. Restart the panel after an
upgrade to use the newly installed version.
The server listens on loopback only. For SSH use local port forwarding as above.
ADB must reach the phone from the machine running Manager; WSL USB forwarding is
separate from browser access. Web Preview hardware video/input/audio validation
on a physical phone is still pending. Desktop-only window/UHID/RDP options remain
available in the graphical edition.
