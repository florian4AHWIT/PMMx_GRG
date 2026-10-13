# Hausaufgabe UE 1 — Daten visualisieren

Name: Florian Hasler_____________ &nbsp;&nbsp;&nbsp; Abgabe: _____________

**Lektüre:** R4DS 2e, [Kap. 1 Data visualization](https://r4ds.hadley.nz/data-visualize.html)
und [Kap. 2 Workflow: basics](https://r4ds.hadley.nz/workflow-basics.html) —
lies sie zuerst, die Aufgaben bauen darauf auf.

---

## 1. Setup + erstes Ritual

Installiere `tidyverse` und `palmerpenguins` (falls noch nicht geschehen) und
führe aus:

```r
library(tidyverse)
library(palmerpenguins)

glimpse(penguins)
```

- Wie viele Zeilen (Pinguine)? ____344__ &nbsp; Wie viele Spalten? _8_____
- Welchen Typ hat `species`? ____factor____ &nbsp; `body_mass_g`? _____integer___

---

## 2. Die Einstiegsfrage nachbauen

Baue im **Skript** (nicht in der Konsole!) das Ziel-Bild aus der Stunde nach:

```r
ggplot(penguins,
       aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)")
```

- Steigt die Körpermasse mit der Flossengröße für **alle drei Arten**? ____ja, sie steigt____
- Welche Art ist am schwersten? ________Gentoo_______

---

## 3. Vorhersagen (ohne R — erst hinschreiben!)

**a)** Was unterscheidet diese beiden Zeilen im Ergebnis?

```r
ggplot(penguins, aes(x = species, y = body_mass_g)) + geom_point(color = "red")
ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) + geom_point()
```

Vorhersage: ______Die Farbe der Pinguine ist einmal nur rot und bei der anderen ist die Farbe der Spezies entscheidend.
___________________________________________

<br>R-Ergebnis (ausführen und vergleichen): _________R Studios hat auf der x-Achse die arten der Pinguine angebracht.________________________________________

**b)** Was passiert, wenn du das `+` an den Zeilenanfang stellst?

```r
ggplot(penguins, aes(x = body_mass_g))
  + geom_histogram(binwidth = 250)
```

Vorhersage: ______________Arten und geom_ wird auf der x-Achse angezeigt___________________________________

<br>R-Ergebnis: ___Konnte nicht ausgeführt werden (Single Argument)______________________________________________

---

## 4. Eine eigene Frage finden

Wähle zwei Zahlen-Spalten der Pinguine, die dich interessieren, und baue ein
Streudiagramm mit sinnvollen `labs()`-Achsentiteln. Ergänze `geom_smooth()`.

- Deine Frage (in einem Satz): __________Wie verhaltet sich das Alter zum Geschlecht der Pinguine?_______________________________________
- Was zeigt der Plot? (2 Sätze): _____Es ist ziemlich ausgegelichen und es gibt keine besonderen Merkmale!____________________________________________

  _________________________________________________

---

## 5. Kapitel-Check (Kap. 2 — Workflow: basics)

Antworte in eigenen Worten (1–2 Sätze je Frage):

- Warum steht das `+` in `ggplot2` **immer am Zeilenende** — was würde auch
  technisch passieren, wenn du es ans Zeilenanfang stellst? Wie meldet sich R?

  _________Würde diese Anweisung am Anfang der Zeile stehen, dann wären nicht alle wichitgen Werte die in der Anweisung stehen im Diagramm enthalten.________________________________________

- Warum speichert man Werte mit `<-` in einem Skript, statt sie in der
  Konsole direkt auszurechnen?

  _____Damit man immer wieder auf sie zugreifen kann.____________________________________________
