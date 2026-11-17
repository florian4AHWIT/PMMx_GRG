# KM7-02 — Der Chi-Quadrat-Test
# Setup-Ritual: RStudio-Projekt pmm-km7-02, alles in analyse.R
# Daten: daten/betriebsdaten.csv (Kopie aus assets/betriebsdaten.csv)
# Ausführen aus dem Projektordner: Rscript analyse.R  /  Ctrl+Shift+S

library(tidyverse)

# ---------------------------------------------------------------------------
# 1a. Datensatz und Kreuztabelle
# ---------------------------------------------------------------------------
daten <- read_csv("daten/betriebsdaten.csv", show_col_types = FALSE) |>
  mutate(iok = if_else(is.na(masse_mm), NA,
              if_else(round(abs(masse_mm - 10), 10) > 0.15,
                      "ausserhalb", "in_Toleranz")))

cat("Zeilen gesamt:", nrow(daten), "| gültige Messungen:", sum(!is.na(daten$masse_mm)), "\n")
tab <- table(daten$maschine, daten$iok)
print(tab)
#          ausserhalb in_Toleranz
# M1          0           37
# M2          0           39
# M3          4           36

# ---------------------------------------------------------------------------
# 1c. Erwartete Häufigkeiten und Beiträge (von Hand nachgerechnet)
# erwartet = Zeilensumme * Spaltensumme / Gesamtsumme
# ---------------------------------------------------------------------------
erwartet <- outer(rowSums(tab), colSums(tab)) / sum(tab)
cat("\nErwartete Häufigkeiten unter H0:\n")
print(erwartet)
cat("Beiträge (b-e)^2/e:\n")
print(round((tab - erwartet)^2 / erwartet, 4))

# ---------------------------------------------------------------------------
# 1d. Unabhängigkeitstest + Fisher
# ---------------------------------------------------------------------------
cat("\n--- chisq.test ---\n")
warn_chi <- character()
res <- withCallingHandlers(chisq.test(tab),
  warning = function(w) { warn_chi <<- c(warn_chi, conditionMessage(w)); invokeRestart("muffleWarning") })
print(res)
cat("Warnung (wörtlich):", warn_chi, "\n")
cat("df = (Zeilen - 1) * (Spalten - 1) =", nrow(tab) - 1, "*", ncol(tab) - 1, "=",
    (nrow(tab) - 1) * (ncol(tab) - 1), "\n")

cat("\n--- fisher.test ---\n")
print(fisher.test(tab))

# ---------------------------------------------------------------------------
# 1e. Anpassungstest gegen die Sollquote von 10 % Ausschuss
# ---------------------------------------------------------------------------
quoten <- daten |> filter(!is.na(masse_mm)) |>
  group_by(maschine) |>
  summarise(n = n(), aus = sum(iok == "ausserhalb"), .groups = "drop") |>
  mutate(in_toleranz = n - aus)
print(quoten)

cat("\nAnpassungstest je Maschine (p = 0,9 / 0,1):\n")
anpassung <- map(quoten$maschine, function(m) {
  q <- quoten |> filter(maschine == m)
  w <- character()
  r <- withCallingHandlers(chisq.test(c(q$in_toleranz, q$aus), p = c(0.9, 0.1)),
    warning = function(e) { w <<- c(w, conditionMessage(e)); invokeRestart("muffleWarning") })
  list(maschine = m, x2 = unname(r$statistic), p = r$p.value, warnung = w)
})
for (a in anpassung) {
  cat(sprintf("%s: X2 = %.4f, p = %.5f%s\n", a$maschine, a$x2, a$p,
              if (length(a$warnung)) paste0(" | WARNUNG: ", a$warnung) else ""))
}

# ---------------------------------------------------------------------------
# 1f. Voraussetzungen: 80-%-Regel
# ---------------------------------------------------------------------------
cat("\nErwartete Häufigkeiten unter 5:", sum(erwartet < 5), "von", length(erwartet),
    "Zellen =", round(100 * sum(erwartet < 5) / length(erwartet), 1), "%\n")

# ---------------------------------------------------------------------------
# 1h. Ergebnis sichern (Kreuztabelle als Datei, nicht als Screenshot)
# ---------------------------------------------------------------------------
dir.create("ergebnisse", showWarnings = FALSE, recursive = TRUE)

urxn <- as.data.frame.matrix(tab) |> rownames_to_column("maschine")
write_csv(urxn, "ergebnisse/kreuztabelle.csv")
write_csv(as.data.frame.matrix(erwartet) |> rownames_to_column("maschine"),
          "ergebnisse/erwartet.csv")
write_csv(broom::tidy(res), "ergebnisse/testtidy.csv")

# Rücklesen und erneut testen
zurueck <- read_csv("ergebnisse/kreuztabelle.csv", show_col_types = FALSE) |>
  column_to_rownames("maschine")
res2 <- suppressWarnings(chisq.test(as.matrix(zurueck)))
cat("Rücklese-Prüfung X-squared:", round(unname(res2$statistic), 4), "\n")
stopifnot(abs(unname(res2$statistic) - 7.8714) < 0.001)

# Warum write_csv(tab, ...) scheitert und write.csv(row.names = FALSE) schweigt:
fehler <- tryCatch({ write_csv(tab, tempfile(fileext = ".csv")); "kein Fehler" },
                   error = function(e) conditionMessage(e))
cat("write_csv(tab, ...):", fehler, "\n")

# ---------------------------------------------------------------------------
# Beispiel 3: Transfer — Wareneingang und Schichtbetrieb
# ---------------------------------------------------------------------------
cat("\n--- 3a. Sollverteilung 50/30/20 ---\n")
beobachtet <- c(A = 96, B = 68, C = 36)
print(round(200 * c(0.5, 0.3, 0.2), 1))
print(chisq.test(beobachtet, p = c(0.5, 0.3, 0.2)))

cat("\n--- 3b. Nacharbeit nach Lieferant ---\n")
tab2 <- rbind(c(14, 82), c(18, 50), c(9, 27))
rownames(tab2) <- c("A", "B", "C")
colnames(tab2) <- c("nachbearbeitet", "ohne_Nacharbeit")
print(tab2)
erw2 <- outer(rowSums(tab2), colSums(tab2)) / sum(tab2)
cat("kleinste erwartete Häufigkeit:", min(erw2), "\n")
print(chisq.test(tab2))
print(fisher.test(tab2))

cat("\nKM7-02: Skript vollständig durchgelaufen.\n")
