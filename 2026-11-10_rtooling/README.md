# 2026-11-10_rtooling — CSV nach Excel

## Aufgabenstellung (aus `4ahwit-x/README.md`)

> Recherchiere eigenständig, wie du das eingelesene Betriebsdaten-File als
> Excel wieder in das R-Projekt zurückschreiben kannst. Erweitere das in der
> Schule erstellte Skript dahingehend, dass CSV eingelesen und im Excel-Format
> ausgegeben wird.

## Recherche: Wie schreibt R eine Excel-Datei?

| Paket | Funktion | Bemerkung |
|---|---|---|
| **`writexl`** | `write_xlsx(daten, "datei.xlsx")` | Empfohlen für diesen Fall: keine externen Abhängigkeiten, kein Excel/Java nötig, sehr schnell. |
| `openxlsx` | `write.xlsx(daten, "datei.xlsx")` | Mehr Formatierungsmöglichkeiten (Formatierung, mehrere Sheets mit `openxlsx::addWorksheet()`), schwerer. |
| `readxl` | `read_excel()` | Liest Excel **ein** — nützt hier nur für die Rückkontrolle. |
| `readr` | `write_csv()` | Schreibt CSV, **kein** Excel-Format. |

Entscheidung: **`writexl`**. Installation (einmalig):

```r
install.packages("writexl")
```

## Umsetzung

`main.R` erweitert das Schuls-Skript um drei Schritte:

1. `read_csv("data/betriebsdaten.csv")` — CSV einlesen (120 Zeilen, 3 Spalten)
2. `write_xlsx(m, "output/betriebsdaten.xlsx")` — als echte `.xlsx` schreiben
3. `readxl::read_excel(...)` — Datei zurücklesen und Zeilen/Spalten/Spaltennamen
   gegen das Original prüfen

Der Ausgabeordner wird mit `dir.create(..., recursive = TRUE)` automatisch
angelegt, damit das Skript in einem frischen Klon direkt läuft.

## Ausführen

```sh
cd 2026-11-10_rtooling
Rscript main.R
```

Erzeugt `output/betriebsdaten.xlsx`.
