# Lösung SA-01 — Daten visualisieren

Alle Antworten mit `analyse.R` erzeugt; die Bilder liegen in `plots/`.

## 1. Setup + erstes Ritual

- **Zeilen:** 344 · **Spalten:** 8
- **`species`:** `factor` · **`body_mass_g`:** `integer`
- `install.packages("tidyverse")` lädt das Paket **einmalig** aus dem Internet
  in die Bibliothek und muss nur bei Neuinstallation/Update wiederholt werden.
  `library(tidyverse)` lädt das bereits installierte Paket **in die aktuelle
  Sitzung** und ist nach jedem Neustart von R/RStudio nötig.

## 2. Die Grammatik übertragen

Ja — innerhalb **aller drei Arten** steigt die Körpermasse mit der
Flossengröße ( Korrelation je Art: Adelie ≈ 0,87, Chinstrap ≈ 0,66,
Gentoo ≈ 0,87). Die schwerste Art ist **Gentoo** (Mittelwert 5076 g).

## 3. Vorhersagen

**a)** In der ersten Zeile liegt `color = "red"` *außerhalb* von `aes()` — alle
Punkte sind rot, es gibt keine Legende. In der zweiten Zeile mapped `color`
innerhalb von `aes()` auf die Spalte `species`: jede Art bekommt eine eigene
Farbe und eine Legende erscheint. Die x-Achse zeigt in beiden Fällen die drei
Arten; die Punkte sind bei der ersten Version über der Art gestapelt.

**b)** R meldet: `Cannot use `+` with a single argument.` Das `+` steht in einer
neuen Anweisung und hat links keinen Operanden — es wird als unäres Plus
interpretiert. Deshalb gehört das `+` in ggplot2 immer ans **Zeilenende**.

## 4. Eigene Frage

**Frage:** Hängt die Körpermasse mit der Schnabellänge zusammen — und
unterscheidet sich dieser Zusammenhang zwischen den drei Arten?

**Was der Plot zeigt:** Innerhalb jeder Art steigt die Körpermasse deutlich
mit der Schnabellänge; die drei Regressionsgeraden verlaufen ähnlich steil,
liegen aber auf unterschiedlichem Niveau (Gentoo am höchsten). Die Art
erklärt also vor allem das Niveau, die Schnabellänge die Streuung innerhalb
einer Art.

**Passendes Geom:** Ein Streudiagramm mit `geom_smooth()`, weil zwei
Zahlen-Spalten auf Zusammenhang geprüft werden. Ein Histogramm zeigt nur die
Verteilung *einer* Variablen, ein Balkendiagram nur Anzahlen von Kategorien —
beide können die Paarung der Werte nicht darstellen.

## 5. Kapitel-Check

**`+` am Zeilenende:** ggplot2 überlädt den `+`-Operator, um Ebenen an ein
Plot-Objekt anzuhängen. Dafür muss links ein Plot-Objekt stehen. Steht das `+`
am Anfang der nächsten Zeile, beginnt R eine neue Anweisung ohne linken
Operanden und bricht mit `Cannot use '+' with a single argument.` ab.

**`<-` im Skript:** Die Zuweisung speichert den Wert unter einem Namen, sodass
er später erneut verwendet werden kann. In der Konsole getippte Ergebnisse
sind nach dem Schließen weg und machen das Skript nicht reproduzierbar.
