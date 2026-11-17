# Lösung KM7-02 — Der Chi-Quadrat-Test

**Ordner:** R-Projekt `pmm-km7-02` · alle Zahlen mit `analyse.R` nachgerechnet.
**Daten:** `daten/betriebsdaten.csv` (Soll 10,00 mm ± 0,15 mm).

## 1a. Der Datensatz

| | außerhalb | in_Toleranz |
|---|---|---|
| M1 | 0 | 37 |
| M2 | 0 | 39 |
| M3 | 4 | 36 |

**1b, Vorhersagen:**

1. **116** gültige Messungen, nicht 120 — vier Werte sind `NA` (M1: drei,
   M2: eine). `table()` lässt `NA`standardmäßig aus; die Spalte `iok` wird
   für diese vier Zeilen ebenfalls `NA`.
2. M1 erwartet: (37 · 4) / 116 = **1,2759** Ausschussteile unter H0.
3. **3 von 6 Zellen** liegen unter 5 (1,2759 / 1,3448 / 1,3793 in der Spalte
   „außerhalb"). Das sind **50 %** — die 80-%-Regel ist **verletzt**. Folglich
   ist die Chi-Quadrat-Näherung nicht verlässlich; `fisher.test()` ist der
   passendere Test.

## 1c. Teststatistik von Hand

| Zelle | beobachtet | erwartet | Beitrag (b−e)²/e |
|---|---|---|---|
| M1 außerhalb | 0 | 1,2759 | 1,2759 |
| M2 außerhalb | 0 | 1,3448 | 1,3448 |
| M3 außerhalb | 4 | 1,3793 | **4,9793** |

Die sechs Beiträge summieren sich auf **7,8714**. M3 liefert den größten
Beitrag — dort fallen die größte absolute Abweichung (4 statt 1,379) und der
kleinste Nenner zusammen. Der kleine Nenner allein erklärt es nicht: M1 hat
mit 1,276 einen fast gleich großen Erwartungswert, aber nur 1,276 als Beitrag.
Entscheidend ist die quadrierte Abweichung; der Nenner verstärkt sie zusätzlich.

## 1d. Unabhängigkeitstest

| Kennzahl | Wert |
|---|---|
| X² | 7,8714 |
| df | 2 |
| p (Chi) | 0,01953 |
| p (Fisher) | 0,03347 |

**df:** (Zeilen − 1) · (Spalten − 1) = (3 − 1) · (2 − 1) = **2**.

**R-Warnung wörtlich:** `In chisq.test(tab) : Chi-Quadrat-Approximation kann inkorrekt sein`

Die p-Werte weichen ab, weil `chisq.test()` die diskrete Verteilung der
Häufigkeiten durch eine stetige χ²-Verteilung annähert, während
`fisher.test()` die exakte Wahrscheinlichkeit aus der hypergeometrischen
Verteilung berechnet. Bei erwarteten Häufigkeiten unter 5 ist die Näherung ungenau —
hier ist Fishers p mit 0,03347 die belastbarere Zahl (immer noch < 0,05).

**Deutscher Satz mit 0,0195:** „Wenn die Maschine unabhängig davon wäre, ob ein
Teil innerhalb der Toleranz liegt, wäre eine mindestens so große Abweichung
wie die beobachtete in etwa **1,95 %** der Fälle zu sehen." Bei α = 0,05 wird
H0 damit verworfen: Maschine und Ausschuss hängen zusammen.

## 1e. Anpassungstest gegen 10 % Sollausschuss

| Maschine | beobachtet (in / aus) | erwartet (in / aus) | X² | p-Wert |
|---|---|---|---|---|
| M1 | 37 / 0 | 37 / 3,7 | 4,1111 | 0,04260 |
| M2 | 39 / 0 | 39 / 3,9 | 4,3333 | 0,03737 |
| M3 | 36 / 4 | 36 / 4,0 | 0,0000 | 1,00000 |

**M1 und M2 fallen statistisch auf** (p < 0,05), und zwar mit **weniger**
Ausschuss als den 10 % erwartet — also in die *gute* Richtung. M3 liegt mit
genau 4 Ausschussteilen bei 10 % und fällt nicht auf (p = 1). Dass der Test
die Richtung nicht liefert, erkennt man daran, dass er nur X² und einen
zweiseitigen p-Wert ausgibt: Der Beitrag ist quadrirt, daher zählt nur die
Größe der Abweichung, nicht ihr Vorzeichen. Die Richtung liest man aus der
Kreuztabelle bzw. aus (beobachtet − erwartet) ab.

**Drei Sätze, warum kein Güteurteil:** Der Anpassungstest prüft nur, ob die
beobachtete Verteilung mit der Sollverteilung vereinbar ist — bei M1 und M2
bedeutet ein signifikanter p-Wert lediglich „weicht ab", nicht „schlecht".
Er kennt keine Richtung und keine Kosten/Nutzen-Bewertung; ein zu guter Wert
kann sogar ausschlaggebend sein. Für ein Güteurteil braucht es zusätzlich
Toleranzgrenzen, Ausschusskosten und die Frage, ob die 10 % überhaupt ein
Maximum oder ein Zielwert sind.

## 1f. Voraussetzungen

1. Unter 5 liegen 1,2759 / 1,3448 / 1,3793 — **3 von 6 Zellen = 50 %**.
2. Die 80-%-Regel ist verletzt. `p = 0,0195` ist nur eine Näherung und darf
   nicht als exakt interpretiert werden; mit `fisher.test()` ergibt sich
   p = 0,03347 (weiterhin signifikant).
3. Ohne `suppressWarnings()` erscheint bei jedem Anpassungstest dieselbe
   Warnung: `Chi-Quadrat-Approximation kann inkorrekt sein`. Damit sind auch
   die p-Werte aus 1e (0,04260 / 0,03737 / 1) nur Näherungswerte.

## 1g. Kapitel-Check

1. **Drei Voraussetzungen:** (a) kategorielle Daten in einer Kreuztabelle,
   (b) unabhängige Beobachtungen (keine Paare/Wiederholungen), (c) erwartete
   Häufigkeiten groß genug (80-%-Regel, keine Zelle < 1). Erfüllt sind (a) und
   (b) — jede Zeile ist ein anderes Teil. Verletzt ist (c).
2. Der **Unabhängigkeitstest** fragt: „Hängen zwei Merkmale zusammen?" —
   Aufruf `chisq.test(tab)`, eine Tabelle mit zwei Dimensionen. Der
   **Anpassungstest** fragt: „Passt die Verteilung zu einer vorgegebenen?" —
   Aufruf `chisq.test(vektor, p = c(...))`, mit expliziten Sollwahrscheinlichkeiten.
3. Der Kollege hat **nicht recht**. p < 0,05 heißt nur, dass die Tabelle unter
   H0 unwahrscheinlich ist — nicht, welche Maschine „schlecht" ist und schon
   gar nicht, in welche Richtung die Abweichung geht. Zudem ist die
   chi-Quadrat-Näherung hier wegen der 50 % kleinen Erwartungswerte unzuverlässig.

## 1h. Ergebnis sichern

Gespeichert: `ergebnisse/kreuztabelle.csv`, `ergebnisse/erwartet.csv`,
`ergebnisse/testtidy.csv`. Die Kreuztabelle hat `maschine` als erste Spalte und
die sechs korrekten Zahlen.

- `write_csv(tab, ...)` scheitert, weil `tab` ein Objekt der Klasse `table`
  ist und `write_csv()` ein data.frame oder tibble erwartet.
- `write.csv(tab, ..., row.names = FALSE)` schweigt, verwirft aber genau damit
  die Maschinenbezeichnungen — die Namen sind Zeilennamen, keine Spalte.
- Nach `column_to_rownames("maschine")` ergibt der erneute Test
  **X-squared = 7,8714** — identisch mit dem Original.
- Bei `erwartet.csv` ohne `row.names` fehlen ebenfalls die Maschinenlabels;
  `broom::tidy(res)` erzeugt stattdessen eine einzeilige Tabelle mit
  `statistic`, `p.value`, `df` und `method`.

## 2. Selbsttest (WÜ-Format)

| Frage | Lösungsmenge |
|---|---|
| 2.1 | 1 |
| 2.2 | 1 |
| 2.3 | 1 — df = (3−1)(2−1) = 2 |
| 2.4 | 1, 2 |
| 2.5 | 1, 2 |
| 2.6 | 1, 2 |
| 2.7 | 1, 2 |
| 2.8 | — (keine Aussage stimmt) |

## 3. Transfer — Wareneingang und Schichtbetrieb

**3a.** Erwartet bei 200 Teilen: A = 100, B = 60, C = 40.
`chisq.test(c(96, 68, 36), p = c(0.5, 0.3, 0.2))` → X² = **1,6267**, df = 2,
p = **0,4434**. Die Lieferung passt zur Sollverteilung 50/30/20; es gibt
keinen Hinweis auf eine Abweichung. Alle erwarteten Häufigkeiten ≥ 40, die
80-%-Regel ist erfüllt.

**3b.** X² = **3,9968**, df = 2, p = **0,1356**; Fisher p = 0,1363. Kleinste
erwartete Häufigkeit = 7,38 ≥ 5 → Voraussetzung erfüllt, der Chi-Test ist
hier zulässig. Wäre sie verletzt, wäre `fisher.test(tab2)` zu verwenden, weil
es die exakte p-Wahrscheinlichkeit ohne Large-Sample-Näherung liefert.

**3c.** Ein signifikantes Ergebnis würde nur sagen: Die Verteilung der
Nacharbeit unterscheidet sich zwischen den Lieferanten. Es benennt weder den
schlechtesten Lieferanten noch die Richtung — dafür braucht es die
Einzelbeiträge bzw. standardisierte Residuen und die tatsächlichen
Nacharbeitsquoten (14/96 ≈ 14,6 %, 18/68 ≈ 26,5 %, 9/36 = 25 %). Für ein
Lieferantenurteil fehlen außerdem Stückzahlen, Kosten und die Frage, ob die
Nacharbeit systematisch oder zufällig ist.
