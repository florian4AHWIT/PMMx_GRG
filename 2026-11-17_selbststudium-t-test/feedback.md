# KM7-01 — Lösung und Feedback zur Lektion

**Datum:** 2026-11-17 · **Ordner:** R-Projekt `pmm-km7-01`
Alle Zahlen wurden mit `analyse.R` gegen `daten/betriebsdaten.csv` nachgerechnet.

---

## 1. Vorhersagen

**a)** Gültige Messungen: **M1 = 37, M2 = 39, M3 = 40**.

**b)** **M3** hat den größten Abstand zum Sollmaß: 10,0627 mm, also
**+0,0627 mm (rund 6 Hundertstel)**. M2 liegt bei −0,0231 mm (2 Hundertstel).

**c)** Der Vergleich **M1 ↔ M3** fällt leichter durch. Zwar streut M3 mit
0,070 mm stärker als M2 mit 0,040 mm, aber der Mittelunterschied ist mit
0,062 mm fast dreimal so groß wie bei M1↔M2 (0,024 mm). Entscheidend ist das
Verhältnis von Effekt zu Streuung (Cohen's d ≈ 1,15 gegenüber ≈ 0,65) — und
tatsächlich ist der p-Wert mit 4,1 · 10⁻⁶ deutlich kleiner als 0,0055.

## 2. Der ungepaelte Vergleich (Welch)

- **H0:** μ(M1) = μ(M3) — die Maschinen liefern im Mittel dasselbe Maß.
- **H1:** μ(M1) ≠ μ(M3) — die Mittelwerte unterscheiden sich.

| Kennzahl | Wert |
|---|---|
| t | −5,1132 |
| Freiheitsgrade | 55,272 |
| p-Wert | 4,092 · 10⁻⁶ |
| 95-%-KI (M1 − M3) | [−0,08659 ; −0,03783] mm |

In ganzen Sätzen: M3 liegt **mindestens 0,0378 mm** und **höchstens
0,0866 mm** über M1. Das gesamte Intervall liegt innerhalb der Toleranz von
±0,15 mm — der Unterschied ist also statistisch klar, aber maßlich unkritisch.

## 3. Der gepaarte Vergleich

**a)** **10** Differenzen sind positiv, **0** negativ.

**b)** t = **5,9822** · df = **9** · p = **0,000207**.

**c)** Der Test rechnet nicht mit den 37 bzw. 40 Einzelmessungen, sondern mit
den **10 Chargenmitteln** — also 10 Paaren. Die Freiheitsgrade sind
`n_Paare − 1 = 9`.

**d)**

| Berechnung | t-Wert |
|---|---|
| über die Differenzen | **5,9822** ✅ stimmt mit R |
| über die Messwerte (Mittelwertdifferenz / Streuung) | −5,1132 ❌ |

Daraus lernt man: Die gepaarte Formel verwendet die **Streuung der
Differenzen** (0,0335 mm), nicht die Streuung der Einzelmessungen. Weil beide
Maschinen dieselben Chargen bearbeiten, fällt die Chargenstreuung heraus —
dadurch wird der Test empfindlicher.

## 4. Kapitel-Check (Navarro Kap. 13)

**a)** Ein z-Test setzt die bekannte Standardabweichung σ der Grundgesamtheit
voraus. In der Praxis kennt man sie nicht und schätzt sie aus der Stichprobe
(als `s`). Der t-Test berücksichtigt die zusätzliche Unsicherheit dieser
Schätzung durch die t-Verteilung mit dickeren Rändern und Freiheitsgraden —
bei kleinem n fällt er daher konservativer aus als der z-Test.

**b)** Nein. `p = 0,42` heißt nur: Die Daten sprechen nicht gegen H0. Das ist
kein Beweis für Gleichheit — es könnte auch ein Fehler 2. Art sein (H0 wird
nicht abgelehnt, obwohl ein Unterschied existiert), etwa bei zu kleiner
Stichprobe. „Nicht signifikant" ≠ „kein Unterschied".

**c)** Drei Situationen mit paarweise zusammengehörenden Werten:

1. Dasselbe Teil vor und nach einer Justierung messen — das Teil ist sein
   eigener Vergleichspartner.
2. Zwei Maschinen, die dieselbe Charge bearbeiten — Charge und Material sind
   identisch.
3. Zwei Messverfahren am selben Werkstück durch denselben Messplatz —
   Umgebungs- und Bedienereinflüsse sind konstant.

## 5. Die Frage hinter der Aufgabe

**a)** Nein, das wäre keine Basis für eine Prozessänderung. Der Unterschied
beträgt nur 0,024 mm und liegt damit weit innerhalb der Toleranz von
±0,15 mm. Dass p = 0,0055 „signifikant" ist, liegt vor allem an der großen
Stichprobe: p misst, wie gut der Unterschied detectable ist, nicht wie groß
oder teuer er ist. Eine Umstellung wäre Aufwand ohne Qualitätsgewinn.

**b)** „Statistisch signifikant" bedeutet: Ein so großer Unterschied ist bei
gültiger H0 unwahrscheinlich — das ist die **Stärke** des Tests, auch kleine
Effekte sicher zu finden. „Wirtschaftlich nicht relevant" bedeutet: Der
Effekt ist für den Prozess zu klein, um etwas zu ändern — das ist die
**Grenze** des Tests, denn der p-Wert sagt nichts über die Effektgröße aus.

**c)** Man bräuchte deutlich **mehr Messungen** (ungefähr das Vierfache, um
den nachweisbaren Unterschied zu halbieren). Wirksamer ist es, die Zahl der
**Chargen** zu erhöhen, nicht nur die Teile pro Charge: Teile derselben Charge
sind ähnlich (gemeinsame Material- und Maschinenbedingungen), liefern also
weniger neue Information als eine zusätzliche, unabhängige Charge.

---

## Feedback zur Lektion KM7-01

**Was gut funktioniert hat:**

- Der Einstieg mit den kontrollierten Zahlen (37/39/40 gültige Messungen,
  Sollmaß 10,00 ± 0,15 mm) macht die Daten greifbar; die Vorhersagen in
  Aufgabe 1 sind eine gute Aktivierung.
- Der Weg vom ungepaarten zum gepaarten Test über dieselben Maschinen ist
  didaktisch stark: Man sieht direkt, dass nur die Chargenpaarung die
  Freiheitsgrade von 55 auf 9 bringt.
- Aufgabe 5 stellt mit „statistisch vs. wirtschaftlich" genau die Frage, die
  im späteren Berufsleben entscheidet.

**Wo ich mir mehr Unterstützung wünsche:**

- Bei Aufgabe 3d („t von Hand nachrechnen") fehlt ein Hinweis, *welche*
  Streuung gemeint ist. Ohne den Satz „Streuung der Differenzen" ist der
  Vergleich mit dem Messwert-t-Wert verwirrend — hier hat mich erst das
  Ausführen beider Varianten aufgeklärt.
- Bei Aufgabe 5c wäre ein kurzer Hinweis zum Stichprobenumfang
  (Vierfach-Regel) oder ein Mini-Beispiel hilfreich; „Richtung begründen"
  ohne Anhaltspunkt fühlt sich sehr offen an.
- Die Toleranz ±0,15 mm wird in mehreren Aufgaben gebraucht. Eine feste
  Callout-Box am Anfang statt der verstreuten Erwähnungen würde das
  Nachschlagen erleichtern.

Insgesamt: klare Lektion, gute Datenbasis — die kleinen Lücken liegen in den
„warum"-Begründungen, nicht im Rechenteil.
