# Lösung SA-00 — Was kann R?

Alle Antworten sind per `analyse.R` mit R 4.6.1 nachgerechnet.

## Beispiel 1 — Betriebsdaten

**1a.** 120 Zeilen, 3 Spalten. `masse_mm` ist `<dbl>` (Zahl mit Dezimalstellen).
`maschine` ist `<chr>`, weil es sich um Text handelt (`M1`, `M2`, `M3`) — die
Ziffer ist Teil der Bezeichnung, kein numerischer Wert.

**1b.** Vorhersage: drei Zeilen, Mittelwerte knapp um 10 mm.

| Maschine | n | Mittelwert (mm) |
|---|---|---|
| M1 | 37 | 10,0005 |
| M2 | 39 | 9,9769 |
| M3 | 40 | 10,0627 |

M1 hat nur 37 gültige Messungen, weil drei Werte fehlen (`NA`). `sum(!is.na())`
zählt nur die tatsächlich gemessenen Teile; `na.rm = TRUE` beim Mittelwert
verhindert, dass der Mittelwert selbst `NA` wird.

**1c.** 6 Teile liegen außerhalb von 10,00 ± 0,15 mm. Ohne `na.rm = TRUE`
liefert der Aufruf `NA` — eine einzige fehlende Messung genügt, um das
Ergebnis der Summe auf `NA` zu setzen.

**1d.** `analyse.R` läuft von oben nach unten ohne Console-Eingaben durch.

## Beispiel 2 — Selbsttest

| Frage | Lösungsmenge | Begründung |
|---|---|---|
| 2.1 | 3 | Nur das Skript ist als Datei gespeichert und reproduzierbar. |
| 2.2 | 4 | `<-` weist zu und druckt nichts; erst `mittel` allein zeigt 10,00667. |
| 2.3 | 1, 3 | 5076 − 3701 = 1375 g; `n()` zählt die Zeilen je Art. |
| 2.4 | 2, 4 | Der p-Wert beschreibt Rauschen, keine Existenz des Effekts; Tests sind KM-7-Stoff. |
| 2.5 | 1, 3, 4 | Jede Zeile steht im Weg; 120.000 Zeilen ändern den Code nicht; Skript ist wiederholbar. |
| 2.6 | 2, 3 | 342 Punkte (2 ohne Masse); `aes()` mappt, `geom_point()` zeichnet. |

## Beispiel 3 — Inseln statt Maschinen

**3a.** Vorhersage: 3 Zeilen, Biscoe am schwersten.

**3b.**

| Insel | n | Mittelwert (g) |
|---|---|---|
| Biscoe | 168 | 4716 |
| Dream | 124 | 3713 |
| Torgersen | 52 | 3706 |

**3c.** Laut `count(species, island)` leben alle 124 Gentoos auf Biscoe. Da
Gentoos mit 5076 g die schwerste Art sind, zieht das den Insel-Mittelwert von
Biscoe nach oben. Chinstrap kommt nur auf Dream vor.

**3d.** `t.test(body_mass_g ~ sex, data = penguins)` → p ≈ 4,79 · 10⁻¹⁶.
Mit drei Gruppen läuft der t-Test nicht einfach weiter: die Formel erwartet
genau zwei Gruppen. Für `island` bräuchte man eine ANOVA (und anschließend
post-hoc-Vergleiche).
