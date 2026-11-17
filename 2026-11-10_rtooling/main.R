# 2026-11-10_rtooling — Betriebsdaten einlesen und als Excel ausgeben
# Ursprung: 4ahwit-x/2026-11-10__chisq/main.R (nur read_csv)
# Erweiterung: CSV einlesen -> XLSX schreiben -> Ergebnis zurücklesen und prüfen

library(tidyverse)

# writexl ist für den Excel-Export zuständig (kein Java/Excel nötig).
# Einmalig installieren: install.packages("writexl")
if (!requireNamespace("writexl", quietly = TRUE)) {
  stop("Paket 'writexl' fehlt. Bitte install.packages(\"writexl\") ausführen.")
}
library(writexl)

pfad_csv  <- "data/betriebsdaten.csv"
pfad_xlsx <- "output/betriebsdaten.xlsx"

# 1. CSV einlesen (wie im Schuls-Skript, nur mit explizitem Pfad)
m <- read_csv(pfad_csv, show_col_types = FALSE)
cat("Eingelesen:", nrow(m), "Zeilen,", ncol(m), "Spalten\n")
glimpse(m)

# 2. Ausgabeordner anlegen und als Excel schreiben
dir.create(dirname(pfad_xlsx), showWarnings = FALSE, recursive = TRUE)
write_xlsx(m, pfad_xlsx)
cat("Excel geschrieben:", normalizePath(pfad_xlsx), "\n")

# 3. Kontrolle: XLSX wieder einlesen und mit dem Original vergleichen
if (requireNamespace("readxl", quietly = TRUE)) {
  rueck <- readxl::read_excel(pfad_xlsx)
  stopifnot(nrow(rueck) == nrow(m), ncol(rueck) == ncol(m))
  stopifnot(identical(names(rueck), names(m)))
  cat("Rücklese-Prüfung: OK —", nrow(rueck), "Zeilen,", ncol(rueck), "Spalten\n")
}

cat("\nRtooling: Skript vollständig durchgelaufen.\n")
