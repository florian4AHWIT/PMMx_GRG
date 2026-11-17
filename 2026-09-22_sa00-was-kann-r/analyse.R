# SA-00 — Was kann R? (Kernübung + Transfer)
# Läuft von oben nach unten ohne Console-Eingaben: Ctrl+Shift+S

library(tidyverse)
library(palmerpenguins)

# ---------------------------------------------------------------------------
# Beispiel 1a: Einlesen und Erstblick
# ---------------------------------------------------------------------------
teile <- read_csv("daten/betriebsdaten.csv", show_col_types = FALSE)
glimpse(teile)
# 120 Zeilen, 3 Spalten. masse_mm: <dbl>. maschine: <chr>, weil Maschinen-
# bezeichnungen Text sind (M1, M2, M3) — keine Zahl, auch wenn eine 1 drin steckt.

# ---------------------------------------------------------------------------
# Beispiel 1b: Kennzahlen je Maschine
# Vorhersage: 3 Zeilen (eine pro Maschine), Mittelwerte knapp unter/über 10 mm.
# ---------------------------------------------------------------------------
kennzahlen <- teile |>
  group_by(maschine) |>
  summarise(n = sum(!is.na(masse_mm)),
            mittel = mean(masse_mm, na.rm = TRUE),
            .groups = "drop")
print(kennzahlen)
# M1: 37 / 10.0005 · M2: 39 / 9.9769 · M3: 40 / 10.0627
# M1 hat n = 37, obwohl 40 Zeilen vorliegen: drei Messungen sind NA
# (fehlende Werte zahlen bei sum(!is.na(...)) nicht mit).

# ---------------------------------------------------------------------------
# Beispiel 1c: Toleranz prüfen (Soll 10,00 mm ± 0,15 mm)
# ---------------------------------------------------------------------------
aussreisser <- sum(abs(teile$masse_mm - 10) > 0.15, na.rm = TRUE)
cat("Außerhalb der Toleranz:", aussreisser, "\n")  # 6

# Ohne na.rm = TRUE liefert sum() NA: eine einzelne fehlende Messung
# reicht, um die gesamte Summe auf NA zu setzen (klassischer Fehler).
cat("Ohne na.rm:", sum(abs(teile$masse_mm - 10) > 0.15), "\n")

# ---------------------------------------------------------------------------
# Beispiel 3: Transfer — Inseln statt Maschinen
# ---------------------------------------------------------------------------
inseln <- penguins |>
  group_by(island) |>
  summarise(n = n(), mittel = round(mean(body_mass_g, na.rm = TRUE)),
            .groups = "drop")
print(inseln)
# Biscoe 168 / 4716 · Dream 124 / 3713 · Torgersen 52 / 3706

arten_inseln <- penguins |> count(species, island)
print(arten_inseln)
# Gentoos leben ausschließlich auf Biscoe (124 Tiere) — daher ist Biscoe
# im Schnitt die schwerste Insel. Chinstrap kommt nur auf Dream vor.

t_sex <- t.test(body_mass_g ~ sex, data = penguins)
print(t_sex)
# p ≈ 4,79e-16 — sehr kleiner p-Wert.
# Mit drei Gruppen (island) läuft t.test() nicht einfach weiter: die
# Formel verträgt genau zwei Gruppen. Für drei Inseln wäre eine ANOVA
# (aov()) bzw. ein post-hoc-Verfahren nötig.

cat("\nSA-00: Skript vollständig durchgelaufen.\n")
