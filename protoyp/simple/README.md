## Kartenbetrieb ohne API-Key
Die MapTiler-Umstellung wurde auf Wunsch verworfen. Es wird kein Account oder API-Key benötigt. `maps.js` bündelt die bisherige OpenStreetMap-Kartenquelle für beide Karten. Diese Datei beim Kopieren mitnehmen.

Über HTTP/HTTPS werden OSM-Kacheln geladen. Beim direkten Öffnen über file:// werden keine Kartenkacheln angefordert: Ein Hinweis erklärt die Einschränkung; die Liste bleibt verwendbar. Für die Online-Karte ohne lokale Serverinstallation muss der Prototyp über einen Weblink bereitgestellt werden. Ein Hosting ist noch nicht eingerichtet. Direktes Öffnen einer Datei mit funktionierender Online-Karte wird nicht zugesagt.

## Compact View — flache Listenzeilen
Die kompakte Orte-Liste verwendet flache Zeilen statt verkleinerter Cards: mindestens 76 px hoch, 48×48 px Thumbnail, Name 14 px und Distanz 11 px. Herz und Bookmark stehen rechts mit jeweils 44×44 px Touchfläche. Keine Tags, kein separater Aktionsbereich unter dem Text, kein Card-Rahmen; nur eine feine untere Trennlinie. Lange Namen dürfen umbrechen und die Zeilenhöhe erweitern. Figma: horizontales Auto Layout, Bild und Aktionen Fixed, Text Fill, Zeilenhöhe Hug mit Minimum 76. Diese Werte ersetzen frühere Compact-Spezifikationen. Die normale Card-Ansicht bleibt unverändert.

## Navigation auf Detailseiten
Die Floating BottomNav bleibt auf Ortsdetails sichtbar. „Orte“ ist aktiv, Dashboard und Settings sind direkt erreichbar. „Orte“ öffnet die Karte. Der separate Zurück-Button führt weiterhin zum vorherigen Screen. Detailinhalt hat unten 120 px plus Safe Area Abstand, damit Route planen und letzte Hinweise vollständig oberhalb der Navigation gescrollt werden können. Diese Regel ersetzt ältere gegenteilige Detail-Spezifikationen.

# Aktueller Stand: drei Regionen und optionaler Standort
Diese Erweiterung ersetzt frühere Aussagen, dass keine Geolocation existiert. Es gibt jetzt 22 Seed-Orte: 12 St. Gallen, 5 Gossau SG (inkl. Arnegg), 5 Zürich. Eigenschaften, Koordinaten und Symbolbilder bleiben illustrative Beispieldaten.

Der Ortsname oben rechts ist jetzt ein Button für das Sheet „Standort & Region“. Es bietet die drei Demo-Regionen sowie „Aktuellen Standort verwenden“. Der Standortbutton rechts auf der Karte startet dieselbe einmalige Abfrage. Kein automatischer Prompt beim Start, kein watchPosition, kein Speichern auf Disk. Erfolg setzt den Bezugspunkt für alle Distanzen/Sortierungen und zentriert die Karte. Auswahl einer Demo-Region ersetzt und verwirft den aktuellen Standort; Reload/Logout setzt ihn zurück. Region/Standortwechsel leert Suche und Filter. Standortdaten werden nicht an einen eigenen Server oder den Routenlink übergeben; durch OSM-Kachelanfragen wird der angezeigte Kartenausschnitt an den Kartenanbieter übertragen.

States für Figma: Demo, Loading (Button deaktiviert), Granted mit Genauigkeit, Denied, Timeout, Unavailable, Insecure HTTP. Rückfall behält den bisherigen Bezugspunkt; Fehler werden im Standort-Sheet angezeigt. Aktionen: erneut versuchen oder Demo-Region wählen. Standort- und Regionwechsel beeinflussen Sammlungen nicht.

**iPhone:** Die bestehende LAN-Adresse über HTTP kann keine Geolocation freigeben. Dafür braucht die Seite eine vertrauenswürdige HTTPS-Adresse. Auf dem Mac gilt localhost als sicherer Kontext. Es wurde kein Hosting und kein öffentlicher Tunnel eingerichtet. Die Demo-Regionen funktionieren weiter über HTTP. Technische Grundlage: https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition

Ortsquellen für Namen/Lage (Ausstattung weiterhin Demo): https://www.stadtgossau.ch/freizeit/8614 , https://www.stadtgossau.ch/_docn/1692089/Raumkonzept_Bericht_und_Analyse.pdf , https://www.stadtgossau.ch/_doc/5420623 , https://www.stadt-zuerich.ch/platzspitz , https://www.stadt-zuerich.ch/josefwiese , https://www.stadt-zuerich.ch/blatterwiese , https://www.stadt-zuerich.ch/de/stadtleben/sport-und-erholung/park-und-gruenanlagen/rieterpark.html

---

# FindMySpot – mobiler UX-Prototyp

## Zweck und Umfang
Dieser klickbare HTML-Prototyp bringt die erste Produktidee auf den Bildschirm und dient als visuelle Vorlage für eine spätere, auch nicht klickbare Figma-Ausarbeitung. Er ist unabhängig von der nativen Swift-App und von Supabase. Keine Datenbank, Authentifizierung, Geolocation oder dauerhafte Speicherung. Alle Änderungen verfallen beim Reload. Der Start ist bei jedem Laden **Orte → Karte**, auch wenn vorher ein Detail-Hash in der URL stand.

## Starten
Im Terminal:

```sh
cd /Users/demo/dev/findmyspot/protoyp/simple
python3 -m http.server 8080 --bind 0.0.0.0
```

Am Mac `http://localhost:8080` öffnen. Zum Beenden Ctrl+C. Ist der Port belegt, beispielsweise 8081 verwenden.

### Auf einem iPhone im gleichen WLAN
1. Mac und iPhone mit demselben WLAN verbinden; Gastnetze können Geräte voneinander isolieren.
2. IP des Macs unter Systemeinstellungen → WLAN → Details → TCP/IP nachsehen. Alternativ `ipconfig getifaddr en0` (der WLAN-Adapter kann anders heissen).
3. In Safari `http://<MAC-IP>:8080` eingeben, etwa `http://192.168.1.20:8080`. Auf dem iPhone nicht `localhost` verwenden.
4. Falls macOS fragt, eingehende Verbindungen für Python zulassen. Mac eingeschaltet und Server laufend lassen.
5. Optional Safari → Teilen → Zum Home-Bildschirm. Der Prototyp verwendet Safe-Area-Abstände, `viewport-fit=cover` und `100dvh`.

Internet ist für Tailwind CDN, Leaflet, OSM-Kacheln und Unsplash-Fotos nötig. Ohne Leaflet gibt es eine verständliche Ersatzansicht und Zugang zur Liste; Bildfehler erhalten eine grüne Ersatzfläche mit Alternativtext. Der Prototyp ist keine Offline-PWA.

## Dateien
- `index.html`: Einstieg, Meta-Tags, CDN-Ressourcen, Hauptcontainer.
- `app.js`: Rendering, UI-Ereignisse, Runtime-State, History, Kartenintegration und Formulare.
- `data.js`: zwölf Demo-Orte, Aktivitäten, Eigenschaften, Symbolbilder und Demo-Position.
- `styles.css`: originale Farbwerte, mobile Komponenten, Blur, Safe Areas, Animationen.
- `app-icon.png`: unveränderte Kopie aus `landing-page/public/app-icon.png`.
- `FIGMA_SPEC.md`: verbindliche Übergabe für die visuelle Figma-Rekonstruktion.

## Branding und Designentscheidungen
Quelle: `landing-page/src/index.css`, `landing-page/src/components/sections/HeroSection.tsx`, `landing-page/src/data/site.ts` und das vorhandene App-Icon. Die Farbwerte sind exakt übernommen:

| Token | Wert | Verwendung |
|---|---|---|
| brand-950 | #003f38 | dunkelste Markenfarbe, Toast |
| brand-900 | #005449 | primäre Aktionen, aktive Navigation, Pins |
| brand-800 | #08675a | Fokus, kleine Labels |
| lime | #c7ed16 | besondere Primäraktion, aktive Akzente |
| lime-soft | #eaf8a7 | ausgewählte Tags, Sammlungsschalter |
| leaf | #71b82f | verfügbarer ergänzender Markenton |
| ink | #15322d | Haupttext |
| muted | #63746f | sekundärer Text |
| surface | #fbfdf9 | Seitenhintergrund |
| surface-alt | #f1f7f2 | ruhige Container |
| line | #dce8df | feine Trennlinien |

Light Mode ist fest. iOS-Systemschrift steht im Prototyp vor Inter, um auf dem iPhone eine native Anmutung zu erhalten. Überschriften 32 px, Abschnittstitel 21 px, Card-Titel 16 px, sekundäre Texte 13 px. Aufgeräumte Hierarchie, gerundete Cards, wenige grüne Akzente. Blur konzentriert sich auf die schwebende Navigation und Kartensteuerung; Inhalte bleiben weitgehend opak. Limette wird mit dunklem Text kombiniert.

Der Viewport ist mobil fluid, am Desktop auf 480 px begrenzt. Seitenränder 18–22 px. iPhone-Pro- und Pro-Max-Breiten werden ohne fest eingebauten Telefonrahmen unterstützt. Für Designprüfungen: 393, 402, 430 und 440 CSS-Pixel Breite, wechselnde Höhen und Safari-Werkzeugleisten testen. Keine simulierte Uhr oder Dynamic Island: diese kommen auf einem echten Gerät vom System.

## Informationsarchitektur und Navigation
Die schwebende Bottom Navigation hat immer die Reihenfolge **Dashboard | Orte | Settings**. Sie ist auf diesen drei Hauptscreens sichtbar und auf Hinzufügen-Seiten verborgen; auf Detailseiten sichtbar mit aktivem Orte-Tab. Hauptscreen-Wechsel und Unterseiten erzeugen echte `history.pushState`-Einträge. `popstate` stellt die Route wieder her; Bildschirm-Zurück verwendet `history.back()`. Filter und Menüs sind ebenfalls History-Zustände: Back schliesst zunächst das Sheet. Kein Router-Paket nötig.

Routen enthalten `screen`, optional `view`, `selected`, `id`, `sheet` oder `step` und eine interne Tiefe. Filter, Suchtext und Sammlungen sind globaler Runtime-State und werden durch Back nicht zurückgesetzt. Der Kartenausschnitt bleibt über Kartenbewegungen erhalten. Listen starten beim erneuten Rendern grundsätzlich oben; Änderungen einer Sammlung auf Dashboard/Detail erhalten die aktuelle Scrollposition. Ein Reload setzt die gesamte Demo zurück und überschreibt die Einstiegsroute mit der Karte. Browser-Forward kann zuvor besuchte Screens wiederherstellen; es ist keine persistente Deep-Link-Anwendung.

## Orte – Karte und Liste
Die Karte nutzt Leaflet 1.9.4 und OpenStreetMap. Ausgangspunkt `[47.4245, 9.3767]`, Zoom 14. Der Punkt ist ausdrücklich eine **feste Demo-Position**, kein ermittelter Standort. Distanzen werden per Haversine als Luftlinie von dieser Position berechnet und nie als Gehzeit verkauft.

Oben: Logo/Name, St. Gallen, Suchfeld, separater Filterbutton, Drei-Punkte-Menü, aktive Filterchips und Trefferzahl. Das Suchfeld durchsucht Name, Adresse, Beschreibung, Aktivitäten und Eigenschaften ohne Beachtung der Grossschreibung. Suche wirkt sofort auf Map und List. Entfernen eines Chips wirkt sofort; es gibt einen Nulltrefferzustand mit gemeinsamem Reset.

Der Toggle Karte/Liste schwebt über der Hauptnavigation. Ein Pin öffnet die PlacePreview an genau dieser Stelle: der Toggle verschwindet. Ein anderer Pin ersetzt die Auswahl. Freie Karte oder Schliessen beendet die Vorschau. Die Preview enthält Bild, Namen, Distanz, Tags, Aktivitäten und beide Sammelaktionen. Titel/Bild führen zur Detailseite. Pins sind Tastatur-fokussierbar und tragen den Ortsnamen.

In der Liste erscheinen mittelgrosse Cards mit 102 × 112 px Thumbnail, Name, Distanz, bis zu drei Eigenschaftstags und separatem Aktionsbereich. Standardsortierung: nächste Orte zuerst. Das Drei-Punkte-Menü bietet in der Liste kompakte Cards und Sortierung nach Name; auf der Karte Demo-Punkt ein/aus und Zentrieren. Diese Einstellungen gelten sofort nach Schliessen und bleiben während der Laufzeit erhalten.

**Ort hinzufügen** ist über einen kleinen Plus-Button rechts auf der Karte, im Listenheader und im Orte-Menü erreichbar. Dadurch konkurriert kein zusätzlicher breiter Call-to-Action mit Toggle oder Preview.

## FilterSheet
Das iOS-artige Sheet öffnet über dem aktuellen Screen mit Backdrop, Handle und Schliessen. Aktivitäten: Lernen, Entspannen, Treffen, Warten, Spazieren. Eigenschaften: Ruhig, Sitzplätze, WLAN, Steckdose, Wetterschutz, WC, Barrierearm, Im Grünen, Aussicht.

Innerhalb der Aktivitäten gilt ODER: mindestens eine passt. Eigenschaften sind UND: alle gewählten Eigenschaften müssen vorkommen. Gruppen und Textsuche werden ebenfalls per UND verbunden. Keine Auswahl bedeutet keine Einschränkung. Das Sheet kopiert die aktiven Filter in einen Entwurf. Auswahl und Reset ändern nur den Entwurf; der CTA zeigt die resultierende Trefferzahl. Erst „Orte anzeigen“ übernimmt. Schliessen, Backdrop, Escape und Back verwerfen den Entwurf. Die Trefferberechnung berücksichtigt die vorhandene Textsuche.

## Detailseite
Horizontal wischbare Hero-Galerie, Zurück oben, Symbolbildhinweis, Aktivitäten, Name, Distanz, unabhängige Favorit/Bookmark-Aktionen, prominente Eigenschaften, Beschreibung, Adresse/Zugang und externer Routenlink. Aktive Filtertags sowie Eigenschaften, die den Suchbegriff enthalten, werden grün und mit Häkchen markiert. Keine Bewertungen.

„Route planen“ öffnet einen Google-Maps-Routenlink mit Zielkoordinaten und Gehmodus in einem neuen Tab. Der Prototyp übermittelt keine echte Nutzerposition. Der externe Kartendienst entscheidet selbst über seinen Startpunkt.

## Favoriten versus Bookmarks
**Herz / Favorit / Lieblingsort:** „Hier komme ich gerne wieder hin.“
**Lesezeichen / Bookmark / Für später:** „Diesen Ort möchte ich noch entdecken oder später nutzen.“

Beide Zustände sind unabhängige Mengen von Orts-IDs. Ein Ort darf in beiden vorkommen; Favorisieren entfernt keinen Bookmark. Ein erneuter Tap entfernt nur den betroffenen Zustand. Seed: zwei Favoriten, drei Bookmarks. Dashboard zeigt getrennte Überschriften, Erklärungen, Zähler und eigene leere Zustände. Alle Aktionen greifen auf dieselben Mengen zu, deshalb sind Karte, Liste, Detail und Dashboard konsistent. Dashboard-Einstellungen blenden Sektionen lediglich aus und löschen nichts.

## Ort hinzufügen
1. **Die Idee:** Name, Adresse/Lage und Beschreibung. Pflichtfelder, Längenbegrenzungen; reiner Leerraum ist nicht gültig. Eingaben bleiben beim Schritt-Zurück erhalten.
2. **Die Details:** mindestens eine Aktivität und Eigenschaft; interaktive Karte zum Setzen der Koordinaten. Feste vorgewählte Demo-Position, kein Geocoding. Adresse und Kartenposition sind unabhängig und müssen bewusst zusammenpassen.
3. **Vorschau:** alle Angaben prüfen; CTA legt den Ort einmal im Runtime-Array an. Er erhält Symbolbilder, neue ID und `created: true`.

Nach Hinzufügen: Suche/Filter leeren, Karte auf den neuen Ort zentrieren, Preview öffnen. Damit verschwindet der neue Ort nicht unbemerkt hinter bestehenden Filtern. Er ist sofort auch in der Liste, favoritisierbar und bookmarkbar. Abbrechen führt zur Karte. Reload entfernt neue Orte.

## Settings und Account-Demo
Avatar als editierbare Initialen, Username und E-Mail. Profil bearbeiten im Sheet, mit Pflichtfeldern und E-Mail-Validierung. Dashboard-Sichtbarkeit über zwei unabhängige Switches. Logout und Account löschen haben eindeutige Bestätigungsdialoge, welche die Simulation erklären. Logout verbirgt das Profil hinter einer Demo-Neustartansicht; Sammlungen bleiben bis zum Reload erhalten. Account löschen setzt Profil, eigene Orte und Sammlungen zurück. „Demo neu starten“ öffnet die Karte. Es werden keine externen Account-Aktionen ausgeführt.

## Datenmodell und State
`Place`: `id`, `name`, `subtitle`, `address`, numerische `lat/lng`, `photos: string[]`, `activities: string[]`, `features: string[]`, `description`, `access`, `created: boolean`.

`state`: `places`, `favorites: Set`, `bookmarks: Set`, `query`, aktive `activities/features`, `profile {name,email,avatar}`, `dashboard {favorites,bookmarks}`, `showPosition`, `compact`, `sort`, `signedIn` und optional `deleted`.

Zusätzlich: Route, Kartenausschnitt, Filterentwurf und AddPlace-Entwurf. Kein localStorage, SessionStorage, Cookie, Backend-Request oder Geolocation-API. Nutzereingaben werden vor HTML-Ausgabe escaped. Bilder kommen ausschliesslich aus vorgegebenen HTTPS-URLs.

## Wiederverwendbare Komponenten
`PlaceCard` verbindet Thumbnail/Details-Link mit separaten `FavoriteButton` und `BookmarkButton`. `SearchBar` ist von Filtertrigger und sekundärem Menü getrennt. `FilterSheet` nutzt `Choice` und einen eigenen Entwurf. `ActiveFilterChip` entfernt genau ein Kriterium. `BottomNav`, `MapListToggle` und `PlacePreview` bilden drei klar getrennte Navigationsebenen. `Detail Sections` verwenden wieder dieselben Tags und Sammelzustände. `AddPlace Flow` verwendet FormField, Choice, Kartenposition und Review. `EmptyState`, Toast, IconButton, PrimaryButton, ProfileAvatar, SettingsRow und Switch sind weitere gemeinsame Muster. Exakte Figma-Varianten siehe Übergabe.

## Animation, Bedienung und Grenzen
Transitions ca. 200–220 ms, Sheets gleiten kurz hoch, Buttons erhalten eine kleine Druckreaktion. `prefers-reduced-motion` deaktiviert Bewegung. Sheets haben Dialog-Semantik, inerten Hintergrund, Tab-Fokusbegrenzung und Escape-Schliessen. Iconbuttons tragen Labels, Toggle-Aktionen `aria-pressed`, Navigation `aria-current`, Toasts `aria-live`. Eingaben sind 16 px gross, um iOS-Autozoom zu vermeiden. Blatt- und Hauptinhalte können separat scrollen; sichere Abstände schützen die Home-Leiste.

Demo-Ortsnamen beziehen sich auf St. Gallen, aber Koordinaten, Ausstattung und Zugang sind illustrative Angaben. Unsplash-Fotos sind **Symbolbilder**, keine dokumentarischen Fotos dieser Orte. „Barrierearm“ ist keine geprüfte Zusicherung. Vor Produktiveinsatz braucht es verifizierte Daten, Nutzungsrechte/Quellenprüfung, robuste Bildauswahl, Auth/Backend und ein Accessibility-Audit.

## Testablauf für Mac und iPhone
- Frischer Aufruf: Karte, 12 Orte, echte OSM-Kacheln, keine Standortabfrage.
- Pin wählen → Preview statt Toggle → Detail → Zurück → Preview → Schliessen.
- Liste → WLAN filtern → Bibliothek; Filter schliessen ohne Übernahme; einzelne Chips entfernen; Nulltreffer und Reset.
- Herz/Lesezeichen separat ändern; Dashboard prüft beide Zähler und leere Zustände.
- Detail: Tags hervorgehoben, Bilder wischbar, Route öffnet extern.
- Neuen Ort mit Pflichtfeldern, Tags und Pin anlegen; Map/List/Detail prüfen; Reload entfernt ihn.
- Profil ändern, Sektionen ausblenden, Logout und Demo-Neustart; Account-Reset simulieren.
- Safari Back/Forward, Bildschirmrotation, Tastatur, Home-Screen-Modus, grössere Textdarstellung und schlechte Verbindung prüfen.

Technische Referenzen: [Leaflet Quick Start](https://leafletjs.com/examples/quick-start/), [Tailwind Play CDN](https://tailwindcss.com/docs/installation/play-cdn). Tailwind Play CDN ist hier bewusst für den Entwicklungsprototyp verwendet.

## Durchgeführte Prüfung
Im eingebetteten Browser geprüft: OSM-Karte und 12 Ortsmarker plus Demo-Punkt, Pin-Preview statt Toggle, Liste, WLAN-Filter mit einem Ergebnis, Detailnavigation, Favorit entfernen und unmittelbar geänderter Dashboard-Zähler, vollständiger AddPlace-Flow bis zur neuen Preview, Profil speichern und Reload auf den Seed-Kartenzustand. Responsive DOM-Prüfung bei 393×852, 402×874, 430×932 und 440×956: kein horizontaler Overflow; BottomNav innerhalb des Viewports. Keine JavaScript-Fehler in der Browserkonsole bei diesen Abläufen. JavaScript-Syntax zusätzlich geprüft. Ein echter iPhone-/Safari-Gerätetest wurde nicht durchgeführt; die obige Checkliste deckt die noch manuell zu prüfenden Geräteeigenschaften ab.

## Aktuelle UI-Revision: reduziert
Diese Revision ersetzt die frühere dekorative Dashboard-Gestaltung: kein Claim, kein grüner Banner, keine zusätzlichen Statistik-Kacheln und kein abschliessender Entdecken-CTA. Das Dashboard beginnt mit „Hallo, Josia“, kleinem JS-Avatar und getrennten Sammlungen. Zähler stehen nur an den Abschnittstiteln. Kurze Beschriftungen erklären Favoriten und Bookmarks. Demo-E-Mail: josia@example.ch (Platzhalter).

Aktuelle visuelle Werte haben Vorrang vor früheren Angaben: H1 28 px, H2 19 px; Card-Radius 14 px, Thumbnail 88×88 px, Cards ohne Schatten; Eigenschaftstags in Cards als ruhige Textzeile, aktive Tags weiterhin grün. Die separate Aktivitätszeile entfällt. BottomNav 64 px hoch mit Radius 20, aktive Navigation sehr hellgrün mit dunkelgrünem Text statt vollflächig dunkelgrün/limette. Toggle ebenso dezent. Inputs/Buttons Radius 12–13. Detailtitel „Ausstattung“ und „Über den Ort“, keine Hero-Slogans. Filter und AddFlow behalten alle Funktionen, verwenden aber sachliche Titel. Brandfarben unverändert; Akzentflächen bewusst sparsamer.
