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

# FindMySpot – AI-to-AI Figma Handoff

## Auftrag und Referenzhierarchie
Erstelle aus diesem lokalen Webprototyp eine präzise mobile Figma-Ausarbeitung. Ziel ist zunächst ein vollständiger visueller Entwurf; Figma-Prototypverbindungen sind optional. Nicht mit der Landingpage oder einer Desktop-Webseite verwechseln. Die Landingpage liefert Branding, der Prototyp liefert Informationsarchitektur und Interaktionen.

Priorität: (1) bestätigte Produktlogik in README, (2) gerenderte Screens und `styles.css`, (3) diese Figma-Empfehlungen. Nicht eigenständig Bewertungen, echte Authentifizierung, Dark Mode, neue Tabs, Monetarisierung oder Geolocation ergänzen. Favoriten und Bookmarks niemals zusammenlegen. Symbolbilder nicht als belegte Fotos der realen Orte beschriften.

## Figma-Dateistruktur
Seiten: `00 Readme & Flows`, `01 Foundations`, `02 Components`, `03 Screens — Pro`, `04 Screens — Pro Max`, `05 States & Edge Cases`.

Primärframe 393 × 852; zusätzliche responsive Prüfrahmen 402 × 874, 430 × 932 und 440 × 956. Dies sind Layout-Arbeitsgrössen, keine vollständige Hardware-Spezifikation. Framebreiten fluid behandeln. iOS Statusbereich und Home-Indikator als eigene System-Layer; nicht als Bestandteil der Markenkomponenten. SafeArea/Top und SafeArea/Bottom als explizite Variablen, Webwerte richten sich nach `env(safe-area-inset-*)`.

## Foundations
Farbvariablen in einer Light-Collection: `Brand/950 #003f38`, `Brand/900 #005449`, `Brand/800 #08675a`, `Accent/Lime #c7ed16`, `Accent/LimeSoft #eaf8a7`, `Accent/Leaf #71b82f`, `Text/Primary #15322d`, `Text/Secondary #63746f`, `Surface/Base #fbfdf9`, `Surface/Secondary #f1f7f2`, `Border/Default #dce8df`, `Surface/White #ffffff`. Zusätzlicher destruktiver Text `#ad3d38`.

Typografie: SF Pro bzw. verfügbare iOS-Systemschrift; Inter als Ersatz. H1 32/35.2, 750, Tracking -1.2; H2 21/27, 700, Tracking -.5; H3 16/20.8, 700; Body 13/20.8; Inputs 16; Eyebrow 10, 800, Tracking 16%; Nav Label 10/12, 600. Keine künstlichen Umbrüche in Ortsnamen; lange Namen können wachsen.

Abstandsvariablen: 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 32. Radien: Chip 12, Thumbnail 14, Field 14, Action 17, Card 22, Nav 26, Sheet 30 oben. Border 1 px. Glass: Base mit ca. 91% Deckkraft, Hintergrundblur 20, weisser Rand, Schatten (0,8,32,0) Brand950 bei 8%. Card-Schatten (0,3,12,0) Brand950 bei 2%. Keine Glass-Effekte auf jedem Inhalt.

## Screen 01 — Places / Map / Default
- **Purpose:** Direkt passende Orte in der Umgebung entdecken. Immer Einstieg bei Reload.
- **Layout:** Karte füllt den Screen; Header oben absolut, Hauptnav unten absolut. Header: Markenreihe, 17 px Abstand, Suchreihe, aktive Chips, Trefferpill. Kartensteuerung rechts bei etwa 54% Höhe.
- **Components:** MapCanvas, MapPin, DemoPosition, BrandHeader, SearchBar, FilterTrigger, MoreButton, ActiveFilterChip, ResultCount, LocateButton, AddButton, MapListToggle, BottomNav.
- **States:** 12 Seed-Orte, aktive Filter, Suchtext, Nulltreffer, Karte nicht erreichbar, Demo-Position aus.
- **Interactions:** Pan/Zoom auf Karte; Pin auswählen; Suche sofort; Filter öffnet Sheet; Plus startet Add; Locate zentriert.
- **Navigation:** Dashboard/Settings via Nav, List via Toggle, Details über Preview.
- **Spacing/Visual Behavior:** Header 18 px seitlich und oben plus Safe Area. Suche 48 px Höhe, Nachbarbuttons 46 px, Gap 8. Floating Nav 20 px Seitenabstand, 68 px hoch, 16 px plus Safe Area unten. Toggle 106 px plus Safe Area vom unteren Rand.
- **Figma Components/Variants:** PlacesScreen `View=Map`, `Selection=None`, `Results=Some|None|Unavailable`; Pin `Default|Selected`; DemoPosition `Visible|Hidden`.
- **Auto Layout:** Root als begrenzter Frame mit Clip Content. Karte absolut stretch. Header vertical Fill; Suchreihe horizontal Fill, SearchBar Fill, Iconbuttons Fixed. Chips horizontal Hug in horizontalem Scrollcontainer. Floating Controls absolut Bottom/Center oder Right.

## Screen 02 — Places / Map / Selected
- **Purpose:** Einen Ort ohne vollständigen Kontextwechsel einschätzen.
- **Layout:** Map wie Default; Preview ersetzt Toggle, Nav bleibt.
- **Components:** Selected MapPin, PlacePreview, PlaceCard, FavoriteButton, BookmarkButton, CloseButton.
- **States:** Favorit/Bookmark unabhängig an/aus; zweiter Pin ersetzt Auswahl; Auswahl kann nach Filteränderung verschwinden.
- **Interactions:** Bild/Titel → Detail; Sammelbuttons ohne Navigation; Schliessen oder freie Karte → keine Auswahl.
- **Navigation:** Back beendet Auswahl; Detail-Back kehrt zur ausgewählten Karte zurück.
- **Spacing/Visual Behavior:** Preview links/rechts 16 px, unten 103 px + Safe Area, 24 px Radius. Close 32 px, leicht oberhalb rechts. Selected Pin 46 px gegenüber 40 px normal, lime mit dunklem Symbol und weissem Rand.
- **Figma Components/Variants:** PlacePreview `Favorite=On|Off`, `Bookmark=On|Off`; Screen `Selection=Place`.
- **Auto Layout:** Preview vertical Hug mit Card Fill; Close absolute. Kein freier Abstandhalter für Toggle: Toggle vollständig ausblenden.

## Screen 03 — Places / List
- **Purpose:** Orte scanbar vergleichen.
- **Layout:** Derselbe fixierte Suchheader; scrollende Liste darunter. Listenüberschrift und Plus, danach Cards. Toggle und Nav bleiben unten sichtbar.
- **Components:** PlaceCard, ResultCount, ListHeader, SearchBar, EmptyState, MapListToggle.
- **States:** Mittelgross (Default), kompakt, Distanzsortierung, alphabetisch, Suche/Filter aktiv, leer.
- **Interactions:** Card-Titel/Bild → Detail; Herz/Bookmark direkt; Menü ändert Dichte/Sortierung.
- **Navigation:** Toggle Map; Hauptnav; Plus Add.
- **Spacing/Visual Behavior:** Inhalt beginnt 206 px + Safe Area oben. Seitenränder 18 px. Zwischen Cards 14 px. Unterer Scrollraum 184 px + Safe Area.
- **Figma Components/Variants:** PlaceCard `Density=Medium|Compact`; Results `Populated|Empty`.
- **Auto Layout:** Vertical scrolling Frame, Width Fill, Height Hug für Cards. In Cards Thumbnail Fixed, Text Fill. Lange Namen umbrechen. Kein horizontales Overflow auf 393 px.

## Screen 04 — Filter Bottom Sheet
- **Purpose:** Bedarf gezielt kombinieren und erst nach Bestätigung übernehmen.
- **Layout:** Abgedunkelte Karte/Liste hinten; Bottom Sheet mit Handle, Titel/Close, zwei Gruppen, Treffer-CTA und Reset.
- **Components:** ModalBackdrop, SheetShell, Choice, PrimaryButton, SecondaryButton.
- **States:** Entwurf leer, Mehrfachauswahl, aktive Ausgangswerte, 0 Treffer. Draft und Applied getrennt.
- **Interactions:** Aktivitäten ODER, Eigenschaften UND, Gruppen und Suche UND. Auswahl ändert CTA-Zahl. Reset löscht nur Entwurf. „Orte anzeigen“ übernimmt. Close/Backdrop/Back/Escape verwirft.
- **Navigation:** Rückkehr zum exakt zugrunde liegenden Map/List-Screen.
- **Spacing/Visual Behavior:** Max. 90% Viewporthöhe, Inhalt scrollbar, 22 px Seitenpadding, Radius 30 oben. Handle 36×4, oben 10, danach 17. Choices Gap 8, min. Höhe 44. Gruppenabstand 24. Footer opak/sticky.
- **Figma Components/Variants:** FilterSheet `Draft=Empty|Selected|NoResults`; Choice `Selected=Yes|No`; Button `Count=...` als Textproperty.
- **Auto Layout:** Sheet vertical Fill width / Hug height bis Max-Höhe. Choice-Gruppen Wrap. Footer Fixed/Hug, mittlerer Inhalt scrollend. Backdrop absolute Full Frame.

## Screen 05 — More / Map und More / List
- **Purpose:** Sekundäre Darstellungseinstellungen aus dem primären Suchflow herausnehmen.
- **Layout:** SheetShell, SettingsGroup, AddPlace-CTA, kurzer Laufzeithinweis.
- **Components:** SettingsRow, Switch, SelectField, LocateAction, AddAction.
- **States:** Map: Demo-Punkt an/aus. Liste: Medium/Compact, Distance/Name.
- **Interactions:** Einstellungen ändern sofort den Runtime-Wert und sind nach Schliessen sichtbar; Zentrieren setzt Demo-Ausschnitt; Add startet eigenen Flow.
- **Navigation:** Schliessen zurück, Add vorwärts.
- **Spacing/Visual Behavior:** Standard Sheet-Padding; Rows mindestens 58 px, Gruppenradius 22.
- **Figma Components/Variants:** MoreSheet `Context=Map|List`; Switch `On|Off`; Sort `Distance|Name`.
- **Auto Layout:** Vertikale Gruppe mit 1 px Dividern. Label Fill, Control Fixed.

## Screen 06 — Place Detail
- **Purpose:** Eignung bestätigen und Route oder Sammlung wählen.
- **Layout:** Hero-Galerie 290 px, Overlay-Back und Bildhinweis. Inhalt um 15 px über Hero geschoben, oben 25 px Rundung. Aktivitäten, Name, Luftlinie, Sammelaktionen, Eigenschaften, Beschreibung, Adresse, Route.
- **Components:** HeroGallery, BackButton, DetailHeading, FavoriteButton, BookmarkButton, DetailTags, DetailTextSection, AccessCard, RouteButton.
- **States:** Saved-Kombinationen 00/01/10/11, Matches hervorgehoben, Bildfehler, neu hinzugefügter Ort, fehlende ID.
- **Interactions:** Galerie horizontal wischen, Herz/Bookmark toggeln, Route extern. Keine Bewertungskomponente.
- **Navigation:** Back zum vorherigen Screen; externe Google-Maps-Route mit Zielkoordinaten.
- **Spacing/Visual Behavior:** Innenränder 22, H1 32, Aktionen 2 gleich breite Spalten mit 9 Gap. Eigenschaften bewusst vor dem langen Beschreibungstext. Tags 10×12 Padding, 8 Gap.
- **Figma Components/Variants:** DetailTag `Match=Yes|No`; Gallery `Index=1|2|Unavailable`; DetailSections separat wiederverwendbar.
- **Auto Layout:** Screen vertical scroll, Hero Fixed height, Text Hug. ActionRow horizontal Fill; TagGroup Wrap; RouteButton Fill. BottomNav sichtbar, Orte aktiv; unterer Inhalt mit 120 px plus Safe Area Abstand.

## Screen 07 — Dashboard
- **Purpose:** Eigene Lieblingsorte und Entdeckungen wiederfinden.
- **Layout:** Begrüssung mit Avatar, Claim, dunkle Zusammenfassung mit zwei Zählern. Favoriten zuerst, Bookmarks darunter; jeweils Titel/Zahl, Semantiksatz und Cards. Entdecken-CTA zuletzt.
- **Components:** Greeting, ProfileAvatar, CollectionSummary, CollectionSection, PlaceCard, EmptyState, BottomNav.
- **States:** Beide gefüllt, einzelne/alle leer, Sektionen ausgeblendet, geänderte Counts. Ein Ort kann in beiden Bereichen vorkommen.
- **Interactions:** Sammelaktionen aktualisieren live. Avatar → Settings. Card → Detail. Keine automatische Umwandlung von Bookmark in Favorit.
- **Navigation:** BottomNav; Orte-CTA; Detail.
- **Spacing/Visual Behavior:** 22 px Seitenpadding, 24 px + Safe Area oben; Banner Radius 25, Padding 21. Zähler 28 px lime. Cards wie Liste.
- **Figma Components/Variants:** CollectionSection `Type=Favorites|Bookmarks`, `State=Populated|Empty|Hidden`; Summary Count Textproperties.
- **Auto Layout:** Vertikale Scrollansicht. Greeting horizontal, Text Fill und Avatar Fixed. Sammlungen Hug; Hidden aus Layout entfernen, nicht leer stehenlassen. Nav absolute.

## Screen 08 — Settings / Profile
- **Purpose:** Persönliche Anzeige und simulierte Account-Aktionen.
- **Layout:** Eyebrow/Titel, Profilzeile, Bereichsgruppe, Accountgruppe, Markeninfobox.
- **Components:** ProfileAvatar, ProfileIdentity, SettingsGroup, SettingsRow, InfoBox, BottomNav.
- **States:** Default Josia/JS, bearbeitet, Dashboard-Sektionen verändert.
- **Interactions:** Profil bearbeiten, Dashboard anpassen, Logout/Account löschen öffnen Sheet.
- **Navigation:** BottomNav und Modals.
- **Spacing/Visual Behavior:** Avatar 78×78, Radius 28, Initialen 28; Gruppen 20 px Abstand, Radius 22; dezente rote Löschen-Zeile.
- **Figma Components/Variants:** ProfileAvatar `Size=Large|Small`; SettingsRow `Kind=Navigation|Destructive|Switch`.
- **Auto Layout:** Profile row horizontal, Avatar Fixed, Identität Fill; E-Mail darf umbrechen. Gruppen vertical Hug mit Dividern.

## Screen 09 — Edit Profile / Dashboard Preferences
- **Purpose:** Profilinhalt ändern bzw. Sammlungen sichtbar halten/verbergen.
- **Layout:** SheetShell mit Formular oder zwei Switch-Zeilen.
- **Components:** FormField, PrimaryButton, Switch, SettingsRow.
- **States:** Existing, Editing, Invalid; je Switch On/Off.
- **Interactions:** Initialen max. 2, Username max. 30, gültige E-Mail. Save übernimmt erst nach Validierung. Dashboard-Switches wirken unabhängig und löschen keine Daten.
- **Navigation:** Save oder Close zurück zu Settings.
- **Spacing/Visual Behavior:** Felder 16 px Text, Padding 14, Radius 14; Label 13/600 und 8 px Gap. Keyboard verkleinert sichtbaren Sheetbereich; Inhalt scrollbar.
- **Figma Components/Variants:** Field `State=Default|Focused|Invalid`; Switch `Value=On|Off`; ProfileSheet und PreferencesSheet separat.
- **Auto Layout:** Fields vertical Hug, Inputs Fill. Fehlertext Hug unter Input. Primärbutton Fill.

## Screen 10 — Logout / Delete / Signed out
- **Purpose:** Account-Abläufe verständlich simulieren.
- **Layout:** Bestätigungssheet mit Erklärung, CTA und Abbrechen. Danach zentrierter Screen mit App-Icon, Status und Demo-Neustart.
- **Components:** ConfirmationSheet, Primary/SecondaryButton, BrandIcon, SignedOutState.
- **States:** Logout confirmation, Delete confirmation, Logged out, Reset complete.
- **Interactions:** Logout verbirgt UI; Delete setzt Demo-Profil/Sammlungen/eigene Orte zurück. Keine externen Requests. Neustart → Karte.
- **Navigation:** Abbrechen zurück; bestätigen SignedOut; Neustart Map.
- **Spacing/Visual Behavior:** Kurzer klarer Text, keine aggressive Warnillustration. SignedOut ohne Hauptnav.
- **Figma Components/Variants:** Confirmation `Intent=Logout|Reset`; SignedOut `Reason=Logout|Reset`.
- **Auto Layout:** Sheet vertikal; SignedOut mittig mit 20 Gap, Button Fill.

## Screen 11 — AddPlace / Step 1
- **Purpose:** Einen eigenen Spot beschreiben.
- **Layout:** Back/Schritt/Abbrechen, drei Fortschrittssegmente, Eyebrow, Titel, Erklärung, Name, Adresse, Beschreibung, Weiter.
- **Components:** FlowHeader, Stepper, TextField, TextArea, PrimaryButton.
- **States:** Empty, Filled, Invalid, Returned with draft.
- **Interactions:** Alle Felder Pflicht; Eingabe bleibt bei Zurück erhalten. Weiter validiert.
- **Navigation:** Weiter Step 2, Abbrechen Map, Back Vorgänger.
- **Spacing/Visual Behavior:** Standard Page-Padding; Stepper 4 px hoch, Gap 6, Abstand 25. Keine Hauptnav.
- **Figma Components/Variants:** AddPlace `Step=1`; FormField states; Stepper `Current=1`.
- **Auto Layout:** Vertical scroll; Beschreibung mindestens 100 px; Button Fill unter Formular.

## Screen 12 — AddPlace / Step 2
- **Purpose:** Nutzung, Ausstattung und geografischen Punkt angeben.
- **Layout:** FlowHeader/Stepper, Activities Wrap, Features Wrap, Karteninstruktion, Karte, Koordinaten, Vorschau-CTA.
- **Components:** Choice, MapPositionPicker, CoordinateLabel, Toast.
- **States:** No selection, Valid selection, New pin, Map unavailable.
- **Interactions:** Mindestens eine Aktivität und Eigenschaft. Tap setzt Pin; Karte darf pannen/zoomen. Koordinaten aktualisieren sofort. Keine automatische Adressauflösung.
- **Navigation:** Vorschau Step 3; Back Step 1 mit Entwurf.
- **Spacing/Visual Behavior:** Map 230 px hoch, Radius 20; OSM-Attribution unten sichtbar; Auswahl wie FilterSheet.
- **Figma Components/Variants:** AddPlace `Step=2`; Picker `Default|PositionSet|Unavailable`.
- **Auto Layout:** Wrap-Auswahlgruppen, Map Fixed height / Fill width, Koordinaten Hug.

## Screen 13 — AddPlace / Step 3 und Success
- **Purpose:** Angaben prüfen und hinzufügen.
- **Layout:** FlowHeader/Stepper, Abschlussüberschrift, Review-Card mit Text und Tags, lime CTA, Laufzeithinweis.
- **Components:** ReviewCard, DetailTags, PrimaryButton, SuccessToast.
- **States:** Ready, Published; erneutes Bestätigen desselben Entwurfs darf keinen zweiten Ort erzeugen.
- **Interactions:** Submit fügt Runtime-Ort an; Filter/Suche werden geleert; Karte zentriert auf den neuen Pin, Preview erscheint.
- **Navigation:** Back Step 2; Submit MapSelected. Kein zusätzlicher blockierender Erfolgsscreen.
- **Spacing/Visual Behavior:** Review 17 px Padding, Radius 20; CTA 50 px Mindesthöhe.
- **Figma Components/Variants:** AddPlace `Step=3`; Review `Status=Ready|Published`; MapSelected `Source=NewPlace`.
- **Auto Layout:** Review vertical Hug, Wrap-Tags, CTA Fill; SuccessToast absolute über Nav.

## Komponentenvertrag
| Component | Properties / Variants | Inhalte und Verhalten | Auto Layout |
|---|---|---|---|
| PlaceCard | Density Medium/Compact; Favorite On/Off; Bookmark On/Off | Bild, Name, Luftlinie, 3 Tags, 2 Aktivitäten; Details-Link getrennt von Aktionen | Vertical Hug; Top horizontal; Thumbnail 102×112 oder 80×80; Text Fill; Footer horizontal |
| FavoriteButton | Selected; Size Icon/Label | Herz, „Lieblingsort“; unabhängig | Icon 42×42 bzw. Label Fill |
| BookmarkButton | Selected; Size Icon/Label | Lesezeichen, „Für später“ | wie FavoriteButton |
| SearchBar | Empty/Typing/Filled; Query | Suchicon, Eingabe, Clear | horizontal Fill; Höhe 48; Gap 9 |
| FilterSheet | Draft, Count | Activities OR; Features AND; Apply/Reset | Vertical + Wrap; CTA sticky |
| ActiveFilterChip | Label; Removable | entfernt genau ein Filterkriterium | horizontal Hug, min. 38 hoch |
| BottomNav | Active Dashboard/Places/Settings | feste Reihenfolge; aktuell dunkelgrün/lime | horizontal; drei gleiche Fill-Segmente; 68 hoch |
| MapListToggle | Active Map/List | wird bei Auswahl ausgeblendet | horizontal Hug; Padding 5; Buttons 10×18 |
| PlacePreview | Place + Saved states | Card und Close, ersetzt Toggle | Fill width, Hug height |
| Detail Sections | Heading, Content; Tag Match | Eigenschaften vor Beschreibung | vertical Hug, Tags Wrap |
| AddPlace Flow | Step 1/2/3; Validation | gemeinsamer Draft, kein Backend | Vertical scroll; fixed-width controls vermeiden |
| EmptyState | Collection/Search/Missing | Icon, Titel, Erklärung, optional Reset | vertical center/Hug |
| Toast | Message | kurzer nichtblockierender Status | Hug, max. 90% Screenbreite |
| SettingsRow | Navigation/Switch/Destructive | Label + rechts Control | horizontal Fill, min. 58 hoch |

## Unbedingt anzulegende Edge-Case-Frames
- Suche ohne Treffer mit Reset, aktive lange Filterchip-Reihe.
- Filterentwurf mit 0 Treffern, Abbrechen ohne Änderung.
- Ein Ort mit Herz UND Bookmark aktiv.
- Dashboard Favoriten leer, Bookmarks leer, beide ausgeblendet.
- Detail mit aktiv hervorgehobenem WLAN und mit langem Ortsnamen.
- Karte offline / Symbolbild nicht verfügbar.
- Add-Formular leer/ungültig, Kartenposition gewählt, Erfolg mit neuem Pin.
- Profilformular mit Tastatur und langer E-Mail, Logout und Reset.

## Abnahme
Prüfe alle vier Layoutbreiten, Textumbruch, Safe Areas, erreichbare letzte Inhalte oberhalb Floating Controls und ausreichende Textkontraste. Hauptinteraktionsflächen möglichst mindestens 44×44 px; kleine sichtbare Symbole dürfen grössere unsichtbare Hit-Areas besitzen. Verwende konsistente Vektoricons aus `app.js` oder ein optisch gleichwertiges 24-px-Line-Set. Keine 1:1-Fotobehauptung für Unsplash-Symbolbilder. Alle Screens mit sinnvollen Namen und Instanzen statt losen duplizierten Elementen anlegen. Als Abschluss Flow-Landkarte und Component-Variant-Matrix auf Seite 00 dokumentieren.

## Aktuelle UI-Revision: reduziert
Diese Revision ersetzt die frühere dekorative Dashboard-Gestaltung: kein Claim, kein grüner Banner, keine zusätzlichen Statistik-Kacheln und kein abschliessender Entdecken-CTA. Das Dashboard beginnt mit „Hallo, Josia“, kleinem JS-Avatar und getrennten Sammlungen. Zähler stehen nur an den Abschnittstiteln. Kurze Beschriftungen erklären Favoriten und Bookmarks. Demo-E-Mail: josia@example.ch (Platzhalter).

Aktuelle visuelle Werte haben Vorrang vor früheren Angaben: H1 28 px, H2 19 px; Card-Radius 14 px, Thumbnail 88×88 px, Cards ohne Schatten; Eigenschaftstags in Cards als ruhige Textzeile, aktive Tags weiterhin grün. Die separate Aktivitätszeile entfällt. BottomNav 64 px hoch mit Radius 20, aktive Navigation sehr hellgrün mit dunkelgrünem Text statt vollflächig dunkelgrün/limette. Toggle ebenso dezent. Inputs/Buttons Radius 12–13. Detailtitel „Ausstattung“ und „Über den Ort“, keine Hero-Slogans. Filter und AddFlow behalten alle Funktionen, verwenden aber sachliche Titel. Brandfarben unverändert; Akzentflächen bewusst sparsamer.
