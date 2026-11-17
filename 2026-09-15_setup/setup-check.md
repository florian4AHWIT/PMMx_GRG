# Setup-Prüfung — 2026-09-15 / 2026-09-22

Ergebnis des Skripts `setup-check.R` auf diesem Rechner.

| Nr. | Kontrolle | Ergebnis |
|---|---|---|
| 1 | R installiert | ✅ R 4.6.1 (2026-06-24, ucrt) |
| 2 | RStudio installiert | ✅ RStudio startet, Console zeigt `>` |
| 3 | `tidyverse` + `palmerpenguins` | ✅ beide geladen (tidyverse 2.0.0) |
| 4 | `glimpse(penguins)` | ✅ **344 Zeilen, 8 Spalten** |
| 5 | Git installiert + konfiguriert | ✅ `git --version`, `user.name`, `user.email` gesetzt |
| 6 | GitHub-Account + Repo geklont | ✅ `origin` → `https://github.com/florian4AHWIT/PMMx_GRG.git` |
| 7 | Lektion SA-01 geöffnet | ✅ `unterricht/SA-01-datenvisualisierung-ggplot/lesson.html` |
| 8 | Ziel-Plot gebaut | ✅ siehe `../2026-10-06_sa01-ggplot/analyse.R` |

**Zusatzpaket für die Rtooling-Aufgabe:** `writexl` wurde nachinstalliert
(`install.packages("writexl")`), weil es für den CSV→Excel-Export nötig ist.

Alle 8 Punkte erfüllt (8/8).
